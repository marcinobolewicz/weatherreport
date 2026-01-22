import SwiftUI

@Observable
@MainActor
final class WeatherDetailsViewModel {
    let airportIdentifier: String
    private let weatherRepository: WeatherRepository
    private let presenter: WeatherDetailsPresenting
    private let appSettings: AppSettingsProviding

    var selectedTab: DetailTab = .conditions
    var state: LoadState = .idle
    var conditions: ConditionsViewData?
    var forecast: ForecastViewData?

    var reportDate: String?
    var infoMessage: String?
    var maxAgeExceeded: Bool = false
    
    private let sleeper: any Sleeping
    
    private var loadTask: Task<Void, Never>?
    private var autoRefreshTask: Task<Void, Never>?

    init(
        airportIdentifier: String,
        appSettings: AppSettingsProviding,
        weatherRepository: WeatherRepository,
        presenter: WeatherDetailsPresenting = WeatherDetailsPresenter(),
        sleeper: any Sleeping = LiveSleeper()
    ) {
        self.airportIdentifier = airportIdentifier
        self.appSettings = appSettings
        self.weatherRepository = weatherRepository
        self.presenter = presenter
        self.sleeper = sleeper
    }

    // MARK: - Lifecycle

    func onAppear() {
        guard state == .idle else { return }
        loadOnAppear()
        updateAutoRefresh()
    }

    func onDisappear() {
        loadTask?.cancel()
        loadTask = nil
        stopAutoRefresh()
    }

    // MARK: - User actions

    func refresh() {
        runLiveFetch { [airportIdentifier, weatherRepository] in
            try await weatherRepository.refresh(airport: airportIdentifier)
        }
    }

    // MARK: - Auto refresh

    func updateAutoRefresh() {
        stopAutoRefresh()

        guard appSettings.autoRefreshEnabled else { return }
        startAutoRefresh(every: appSettings.autoRefreshIntervalSeconds)
    }
    
    private func startAutoRefresh(every seconds: UInt64) {
        autoRefreshTask?.cancel()
        autoRefreshTask = Task { [weak self] in
            guard let self else { return }
            while !Task.isCancelled {
                do {
                    try await sleeper.sleep(seconds: seconds)
                } catch is CancellationError {
                    break
                } catch {
                    break
                }

                if Task.isCancelled { break }
                await self.autoRefreshTick()
                
            }
        }
    }

    func stopAutoRefresh() {
        autoRefreshTask?.cancel()
        autoRefreshTask = nil
    }

    private func autoRefreshTick() async {
        do {
            let result = try await weatherRepository.refresh(airport: airportIdentifier)
            await apply(dto: result.dto, source: result.source)
        } catch is CancellationError {
        } catch {
            if state == .loaded {
                infoMessage = "Could not refresh – showing cached data."
            } else {
                state = .failed(message: userFacingMessage(for: error))
            }
        }
    }

    // MARK: - Private loading

    private func loadOnAppear() {
        loadTask?.cancel()

        loadTask = Task { [airportIdentifier, weatherRepository] in
            state = .loading
            infoMessage = nil

            do {
                for try await event in weatherRepository.observeOnAppear(airport: airportIdentifier) {
                    switch event {
                    case .cache(let dto, let retrievedAt):
                        await apply(dto: dto, retrievedAt: retrievedAt, source: .cache)

                    case .live(let dto, let retrievedAt):
                        await apply(dto: dto, retrievedAt: retrievedAt, source: .live)

                    case .refreshFailedUsingCache:
                        infoMessage = "Could not refresh – showing cached data."
                    }
                }
            } catch is CancellationError {
            } catch {
                state = .failed(message: userFacingMessage(for: error))
            }
        }
    }

    // MARK: - Shared live fetch runner (used by pull-to-refresh etc.)

    private func runLiveFetch(
        _ operation: @escaping @Sendable () async throws -> ReportResult
    ) {
        loadTask?.cancel()

        loadTask = Task {
            do {
                let result = try await operation()
                await apply(dto: result.dto, source: result.source)
            } catch is CancellationError {
            } catch {
                if state == .loaded {
                    infoMessage = "Could not refresh – showing cached data."
                } else {
                    state = .failed(message: userFacingMessage(for: error))
                }
            }
        }
    }

    // MARK: - Apply

    private func apply(dto: WeatherReportDTO, source: ReportResult.Source) async {
        async let conditionsViewData = presenter.makeConditions(from: dto)
        async let forecastViewData  = presenter.makeForecast(from: dto)

        let (conditions, forecast) = await (conditionsViewData, forecastViewData)

        self.conditions = conditions
        self.forecast = forecast
        self.state = .loaded

        self.infoMessage = (source == .cache) ? "Showing cached data." : nil
    }

    private func apply(dto: WeatherReportDTO, retrievedAt: Date, source: ReportResult.Source) async {
        await apply(dto: dto, source: source)
        reportDate = await presenter.makeReportDateString(from: retrievedAt)
        maxAgeExceeded = calculateMaxAgeExceeded(source: source, retrievedAt: retrievedAt)
    }
    
    private func calculateMaxAgeExceeded(source: ReportResult.Source, retrievedAt: Date) -> Bool {
        source == .cache && Date().timeIntervalSince(retrievedAt) > Double(appSettings.cacheMaxAge)
    }
    
    // MARK: - Errors

    private func userFacingMessage(for error: Error) -> String {
        "Load failed"
    }
}
