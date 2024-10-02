//
//  ErrorDialogModelBuilder.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 30/9/24.
//

import Foundation

class ErrorDialogModelBuilder {

    static func build(type: ErrorDialog.DialogType, handler: (() -> Void)? = nil) -> ErrorDialog.Model {

        var animation: Animation? {
            switch type {
            case .commonError: return nil
            case .noInternet: return .noConnection
            }
        }

        var image: String? {
            switch type {
            case .commonError: return "error_icon"
            case .noInternet: return nil
            }
        }

        var primaryText: String {
            switch type {
            case .commonError: return LocalizationKeys.DefaultError.titleExpanded.localize()
            case .noInternet: return LocalizationKeys.NoConnectionError.primaryText.localize()
            }
        }

        var secondaryText: String? {
            switch type {
            case .commonError: return nil
            case .noInternet: return LocalizationKeys.NoConnectionError.seconadryText.localize()
            }
        }

        var buttonText: String {
            switch type {
            case .commonError: return LocalizationKeys.Buttons.retry.localize()
            case .noInternet: return LocalizationKeys.NoConnectionError.buttonText.localize()
            }
        }

        return ErrorDialog.Model(animation: animation,
                                 image: image,
                                 primaryText: primaryText,
                                 secondaryText: secondaryText,
                                 buttonText: buttonText,
                                 handler: handler)
    }
}
