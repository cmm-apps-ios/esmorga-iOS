//
//  ViewState.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 13/8/24.
//

import Foundation

protocol ViewStateProtocol: Equatable {
    static var ready: Self { get }
}
