//
//  ProfileViewModelMapper.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 24/2/25.
//

import Foundation

class ProfileViewModelMapper {
    func map(user: UserModels.User) -> ProfileModels.LoggedModel {

        let userItems = [ProfileModels.UserDataItem(title:LocalizationKeys.Profile.name.localize(), value: user.name + user.lastName, type: .name),
                         ProfileModels.UserDataItem(title:LocalizationKeys.Profile.email.localize(), value: user.email, type: .email)]

        let optionsItems = [ProfileModels.OptionItem(title: LocalizationKeys.Profile.changePassword.localize(),
                                                     image: "arrow.right",
                                                     type: .changePassword),
                            ProfileModels.OptionItem(title: LocalizationKeys.Profile.logout.localize(),
                                                     image: "arrow.right",
                                                     type: .closeSession)]

        return ProfileModels.LoggedModel(userSection: ProfileModels.UserData(items: userItems), optionsSection: ProfileModels.Options(title: LocalizationKeys.Profile.options.localize(), items: optionsItems))
    }
}
