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
    
    static func loadWeatherReportDTO() throws -> WeatherReportDTO {
        if let cached = _cachedDTO { return cached }
        
        let data = try loadJSON(named: "data")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let dto = try decoder.decode(WeatherReportDTO.self, from: data)
        _cachedDTO = dto
        return dto
    }
    
    static func loadJSON(named name: String) throws -> Data {
        if name == "data", let cached = _cachedData { return cached }
        
        let bundle = Bundle(for: BundleToken.self)
        guard let url = bundle.url(forResource: name, withExtension: "json") else {
            throw LoadError.resourceNotFound
        }
        let data = try Data(contentsOf: url)
        if name == "data" { _cachedData = data }
        return data
    }
}
