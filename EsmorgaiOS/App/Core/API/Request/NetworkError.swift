//
//  NetworkError.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 26/7/24.
//

import Foundation

enum NetworkError: Error, Equatable {
    case noInternetConnection
    case mappingError
    case genaralError(code: Int)
}
