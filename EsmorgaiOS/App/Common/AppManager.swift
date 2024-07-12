//
//  AppManager.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 12/7/24.
//

import Foundation

class AppManager: ObservableObject {

    static let shared = AppManager()

    @Published var showSnackbar = false
    @Published var snackbarMessage = ""

    func showSnackbarWith(text: String) {
        self.snackbarMessage = text
        self.showSnackbar = true
    }

    func hideToast() {
        self.showSnackbar = false
    }
}
