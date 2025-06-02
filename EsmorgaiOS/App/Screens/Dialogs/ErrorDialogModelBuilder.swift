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
            case .commonError2: return nil
            case .expiredCode: return nil
            case .noInternet: return .noConnection
            }
        }

        var image: String? {
            switch type {
            case .commonError: return "error_icon"
            case .commonError2: return "error_icon"
            case .expiredCode: return "error_icon"
            case .noInternet: return nil
            }
        }

        var primaryText: String {
            switch type {
            case .commonError: return LocalizationKeys.DefaultError.titleExpanded.localize()
            case .commonError2: return LocalizationKeys.DefaultError.title.localize()
            case .expiredCode: return LocalizationKeys.ActivateAccount.errorTitle.localize()
            case .noInternet: return LocalizationKeys.NoConnection.title.localize()
            }
        }

        var secondaryText: String? {
            switch type {
            case .commonError: return nil
            case .commonError2: return nil
            case .expiredCode: return nil
            case .noInternet: return LocalizationKeys.NoConnection.body.localize()
            }
        }

        var buttonText: String {
            switch type {
            case .commonError: return LocalizationKeys.Buttons.retry.localize()
            case .commonError2: return LocalizationKeys.Buttons.cancel.localize()
            case .expiredCode: return LocalizationKeys.Buttons.retryVerify.localize()
            case .noInternet: return LocalizationKeys.Buttons.ok.localize()
            }
        }

        return ErrorDialog.Model(animation: animation,
                                 image: image,
                                 primaryText: primaryText,
                                 secondaryText: secondaryText,
                                 buttonText: buttonText,
                                 handler: handler,
                                 dialogType: type

        )
    }
}
