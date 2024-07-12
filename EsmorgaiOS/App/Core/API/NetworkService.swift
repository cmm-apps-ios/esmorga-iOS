//
//  NetworkService.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 9/7/24.
//

import Foundation
import Alamofire

public protocol NetworkService {
    var url: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var headers: HTTPHeaders { get }
}
