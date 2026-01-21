# WeatherReport

An iOS SwiftUI app that fetches and displays aviation weather reports (METAR/TAF) for airports using the ForeFlight QA endpoint.

## Requirements Covered

### Data
- Fetch JSON from:
  - `https://qa.foreflight.com/weather/report/<airportIdentifier>` (e.g. `.../kpwm`)
- HTTP header:
  - `ff-coding-exercise: 1`

### User Interface
- List of previously requested locations (pre-populated with **KPWM** & **KAUS**)
- Text input for an airport identifier (e.g. `kaus`) to add to the list and automatically navigate to details
- Details screen:
  - Initially shows **Conditions**
  - Can switch to **Forecast** and updates UI accordingly

### Features
- Persist the list of requested airports between app launches (UserDefaults)
- A test suite focused on stability (ViewModels + formatting logic)

## Project Structure (high-level)

- `App/`
  - `WeatherReportApp.swift` – app entry point
  - `RootView.swift` – navigation root and dependency handoff
  - `AppDependencies.swift` – composition root for dependency injection
- `Domain/Models/`
  - API DTO models (`WeatherReportDTO`, etc.)
- `Services/`
  - `WeatherService` – networking + JSON decoding
  - `AirportsStorage` – airport list persistence (UserDefaults)
  - `Mock/` – mocks used by tests / previews (e.g. `MockWeatherService`)
- `Presentation/`
  - `Features/` – feature-based UI modules (e.g. AirportsList, WeatherDetails)
  - `Formatter/` – date/number/text formatting used to build view data

## Architecture & Design Decisions

- **SwiftUI + MVVM**
  - Views are kept thin: render state and forward user actions.
  - ViewModels own loading state and orchestrate async fetching and refreshing.

- **Dependency Injection (DI) via Composition Root**
  - `AppDependencies` creates concrete implementations (services, storage).
  - External dependencies are abstracted behind protocols for easy mocking and testing.

- **Feature-based organization**
  - Code is grouped by feature to keep responsibilities localized and scalable.

- **Navigation**
  - `NavigationStack` is driven by a dedicated router (`AppRouter`) which owns the navigation path
    and centralizes route handling (list → details).

- **Isolated formatting logic**
  - Date/number/text formatting is extracted into dedicated units,
    making it deterministic and easily testable
    (e.g. configurable locale, calendar, time zone).

### Alternatives Considered

- **TCA (The Composable Architecture)**  
  Excellent consistency and testability, but introduces framework dependency and boilerplate
  that is unnecessary for a small, focused app.

- **MVI (Model–View–Intent)**  
  Provides a strict unidirectional data flow, but adds ceremony with limited payoff at this scale.

### Data Caching

The app is designed to support lightweight per-airport caching.

A simple **JSON-based disk cache** was chosen as the best trade-off between simplicity,
debuggability, and minimal overhead — sufficient for storing the latest weather payload per airport
without introducing database or schema complexity.

## TODO

1. **Settings View**
   - Clear cache, setup maxAge, reload interval
   
2. **A11y** 

3. **L10n**

## Tests

- Unit tests focus on correctness and stability of:
  - ViewModels (using `MockWeatherService` and mock storage)
  - Formatting logic (date/number/text)
- Network and persistence are mocked via protocols to avoid flaky integration tests.

## Notes

- No third-party libraries are required.
