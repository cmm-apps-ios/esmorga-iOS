//
//  Result+IsSuccess.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 3/10/24.
//

import Foundation

extension Result {
    var isSuccess: Bool {
        if case .success = self {
            return true
        }
        return false
    }
}
