//
//  ProfileModels.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 15/2/25.
//

import Foundation

//Define modelos estructurados en ProfileModels para representar los datos que se mostrarán en la vista ProfileView
//Agrupamos la info del usuario y opciones de perfil de forma que sea reusable.

enum ProfileModels {
    struct ErrorModel {
        let animation: Animation
        let title: String
        var buttonText: String
    }
    
    struct LoggedModel {
        var userSection: UserData
        var optionsSection: Options
    }
    
    struct UserData {
        var items: [UserDataItem]
    }
    
    struct UserDataItem: Identifiable {
        var id: String {title} //ID personalizado en UserDataItem y OptionItem para el ProfileView.
        var title: String
        var value: String
        var type: UserDataItemType
    }
    
    enum UserDataItemType {
        case name
        case email
    }
    
    struct Options {
        var title: String
        var items: [OptionItem]
    }
    
    struct OptionItem:Identifiable {
        var id: String {title} //ID personalizado en UserDataItem y OptionItem para el ProfileView.
        var title: String
        var image: String
        var type: OptionsItemType
    }
    
    enum OptionsItemType {
        case changePassword
        case closeSession
    }
}
