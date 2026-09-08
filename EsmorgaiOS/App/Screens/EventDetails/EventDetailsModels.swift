//
//  EventDetailsModels.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 3/10/24.
//

import Foundation

// TODO: Think about refactoring this. Maybe its redudant if we already have a model from domain. Also the names are confusing.

enum EventDetails {

    struct Model {
        let imageUrl: URL?
        let title: String
        let body: String
        let deadline: String
        let descriptionTitle: String
        let descriptionBody: String
        let locationTitle: String
        let locationBody: String
        var primaryButton: Button
        var secondaryButton: Button

        static var empty: Model {
            return Model(imageUrl: nil,
                         title: "",
                         body: "",
                         deadline: "",
                         descriptionTitle: "",
                         descriptionBody: "",
                         locationTitle: "",
                         locationBody: "",
                         primaryButton: .init(title: "", isLoading: false),
                         secondaryButton: .init(title: "", isLoading: false))
        }
    }

    struct Button {
        var title: String
        var isLoading: Bool
    }
}
