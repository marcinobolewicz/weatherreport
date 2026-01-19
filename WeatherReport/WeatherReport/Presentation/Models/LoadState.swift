//
//  LoadState.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 19/01/2026.
//

enum LoadState: Equatable {
    case idle
    case loading
    case loaded
    case failed(message: String)
}
