//
//  LoginViewModelTests.swift
//  KitAppTests
//
//  Created by Kenneth Esguerra on 7/13/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import XCTest
@testable import KitApp

class LoginViewModelTests: XCTestCase {
    
    var sut: LoginViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = LoginViewModel()
    }
    
    
    func testInit() {
        XCTAssertNotNil(sut.sectionViewModels)
    }
    
    func testStart() {
        XCTAssertTrue(sut.sectionViewModels.value.count == 0)
        sut.start()
        XCTAssertTrue(sut.sectionViewModels.value.count == 1)
    }
    
    func testStart_RowViewModels_InSectionViewModel() {
        sut.start()
        XCTAssertNotNil(sut.sectionViewModels.value.first?.rowViewModels[0])
        XCTAssertNotNil(sut.sectionViewModels.value.first?.rowViewModels[1])
        XCTAssertNotNil(sut.sectionViewModels.value.first?.rowViewModels[2])
        XCTAssertNotNil(sut.sectionViewModels.value.first?.rowViewModels[3])
        XCTAssertNotNil(sut.sectionViewModels.value.first?.rowViewModels[4])
        
        
        XCTAssertTrue(sut.sectionViewModels.value.first?.rowViewModels[0] is ImageCellViewModel)
        XCTAssertTrue(sut.sectionViewModels.value.first?.rowViewModels[1] is TextFieldCellViewModel)
        XCTAssertTrue(sut.sectionViewModels.value.first?.rowViewModels[2] is TextFieldCellViewModel)
        XCTAssertTrue(sut.sectionViewModels.value.first?.rowViewModels[3] is RadioButtonTableViewCellViewModel)
        XCTAssertTrue(sut.sectionViewModels.value.first?.rowViewModels[4] is ButtonTableViewCellViewModel)
    }
    
    func testCellIdentifier() {
        sut.start()
        
        XCTAssertTrue(sut.cellIdentifier(for: sut.sectionViewModels.value.first?.rowViewModels[0] as! RowViewModel) == ImageTableViewCell.nibName)
        XCTAssertTrue(sut.cellIdentifier(for: sut.sectionViewModels.value.first?.rowViewModels[1] as! RowViewModel) == TextFieldTableViewCell.nibName)
        XCTAssertTrue(sut.cellIdentifier(for: sut.sectionViewModels.value.first?.rowViewModels[2] as! RowViewModel) == TextFieldTableViewCell.nibName)
        XCTAssertTrue(sut.cellIdentifier(for: sut.sectionViewModels.value.first?.rowViewModels[3] as! RowViewModel) == RadioButtonTableViewCell.nibName)
        XCTAssertTrue(sut.cellIdentifier(for: sut.sectionViewModels.value.first?.rowViewModels[4] as! RowViewModel) == ButtonTableViewCell.nibName)
    }
    
    func test_Content_Manager() {
        
    }
}

extension LoginViewModelTests {
    class MockLoginViewModel: LoginViewModel {
        var isNotifierCalled = false
    }
    
    class MockContentManager: ContentManagerProtocol {
        
    }
}
