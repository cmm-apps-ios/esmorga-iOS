//
//  FirstLaunchManagerTests.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 10/3/25.
//

import Foundation
import Testing
@testable import EsmorgaiOS

@Suite(.serialized)
final class FirstLaunchManagerTests {

    private var sut: FirstLaunchManager!
    private var userDefaults: UserDefaults!
    private var sessionKeychain: CodableKeychain<AccountSession>!

    init() {
        userDefaults = UserDefaults.standard
        userDefaults.clear()
        sessionKeychain = AccountSession.buildCodableKeychain()
        try? sessionKeychain.delete()
        sut = FirstLaunchManager(userDefaults: userDefaults)
    }

    deinit {
        userDefaults.clear()
        userDefaults = nil
        try? sessionKeychain.delete()
        sessionKeychain = nil
        sut = nil
    }

    @Test
    func test_given_first_launch_when_session_data_stored_then_delete_session_keychain() {

        try? sessionKeychain.store(codable: AccountSession(accessToken: "fakeToken", refreshToken: "fakeRefresh", ttl: 1000))

        #expect(sessionKeychain.isLogged == true)
        #expect(userDefaults.bool(forKey: PreferencesKeys.General.firstTimeAppLaunch.rawValue) == false)

        sut.setFirstLaunch()

        #expect(sessionKeychain.isLogged == false)
        #expect(userDefaults.bool(forKey: PreferencesKeys.General.firstTimeAppLaunch.rawValue) == true)
    }

    @Test
    func test_given_not_first_launch_when_session_data_stored_then_not_delete_session_keychain() {

        try? sessionKeychain.store(codable: AccountSession(accessToken: "fakeToken", refreshToken: "fakeRefresh", ttl: 1000))
        userDefaults.set(true, forKey: PreferencesKeys.General.firstTimeAppLaunch.rawValue)

        #expect(sessionKeychain.isLogged == true)
        #expect(userDefaults.bool(forKey: PreferencesKeys.General.firstTimeAppLaunch.rawValue) == true)

        sut.setFirstLaunch()

        #expect(sessionKeychain.isLogged == true)
        #expect(userDefaults.bool(forKey: PreferencesKeys.General.firstTimeAppLaunch.rawValue) == true)
    }
}
