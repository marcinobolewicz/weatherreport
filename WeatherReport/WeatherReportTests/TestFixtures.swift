//
//  TestFixtures.swift
//  WeatherReportTests
//
//  Created by Marcin Obolewicz on 16/01/2026.
//

import Foundation
@testable import WeatherReport

enum TestFixtures {
    
    private final class BundleToken {}
    
    enum LoadError: Error {
        case resourceNotFound
    }
    
    private static var _cachedDTO: WeatherReportDTO?
    private static var _cachedData: Data?
    private static let cacheLock = NSLock()
    
    static func loadWeatherReportDTO() throws -> WeatherReportDTO {
        cacheLock.lock()
        if let cached = _cachedDTO {
            cacheLock.unlock()
            return cached
        }
        cacheLock.unlock()
        
        let data = try loadJSON(named: "data")
        let decoder = DefaultJSONCoding().makeDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let dto = try decoder.decode(WeatherReportDTO.self, from: data)
        cacheLock.lock()
        _cachedDTO = dto
        cacheLock.unlock()
        return dto
    }
    
    static func loadJSON(named name: String) throws -> Data {
        cacheLock.lock()
        if name == "data", let cached = _cachedData {
            cacheLock.unlock()
            return cached
        }
        cacheLock.unlock()
        
        let bundle = Bundle(for: BundleToken.self)
        guard let url = bundle.url(forResource: name, withExtension: "json") else {
            throw LoadError.resourceNotFound
        }
        let data = try Data(contentsOf: url)
        if name == "data" {
            cacheLock.lock()
            _cachedData = data
            cacheLock.unlock()
        }
        return data
    }
}
