//
//  LocalUserDataSourceTests.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 6/9/24.
//

import Nimble
import XCTest
@testable import EsmorgaiOS

final class LocalUserDataSourceTests: XCTestCase {
    
    private var sut: LocalUserDataSource!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = LocalUserDataSource()
        sut.clearAll()
    }
    
    override func tearDownWithError() throws {
        sut.clearAll()
        sut = nil
        try super.tearDownWithError()
    }
    
    
    func tests_given_get_user_when_empty_cache_then_return_nil_result() async {
        
        await expect { self.sut.getUser }.to(beNil())
    }
    
    func test_given_save_user_in_cache_when_get_user_then_return_data() async {
        
        let user = UserModelBuilder().build()
        try? await sut.saveUser(user)
        await expect { self.sut.getUser }.to(equal(user))
    }
    
    
    func test_given_save_user_in_cache_and_when_clear_then_all_local_user_data_is_clear() async { //Revisar
        let user = UserModelBuilder().build()
        try? await sut.saveUser(user)
        
        sut.clearAll()
        
        let savedUser = await sut.getUser()
        expect(savedUser).to(beNil())
    }
}
