//
//  LoginViewControllerTests.swift
//  KitAppTests
//
//  Created by Kenneth Esguerra on 7/13/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import XCTest
@testable import KitApp

class LoginViewControllerTests: XCTestCase {
    
    var sut: LoginViewController!
    
    var loginViewModel: LoginViewModel!

    override func setUpWithError() throws {
        
        sut = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginViewController") as? LoginViewController
        
        
        
        _ = sut.view
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    
    func testInit(){
        XCTAssertNotNil(sut.viewModel)
        XCTAssertNotNil(sut.tableView)
    }
    
    func test_Number_Of_Sections_In_TableView() {
        let numberOfSections = sut.tableView.dataSource?.numberOfSections?(in: sut.tableView) ?? 0
        
        XCTAssertEqual(numberOfSections, sut.viewModel.sectionViewModels.value.count)
    }
    
    func test_Number_Of_Rows_In_Section_In_TableVIew() {
        let numberOfRows = sut.tableView.dataSource?.tableView(sut.tableView, numberOfRowsInSection: 0)
        
        let sectionViewModel = sut.viewModel.sectionViewModels.value[0]
        XCTAssertEqual(numberOfRows, sectionViewModel.rowViewModels.count)
    }
    
    func test_Cell_For_Row_In_TableView() {
        let indexPath = IndexPath(row: 0, section: 0)
        
        let cell = sut.tableView.dataSource?.tableView(sut.tableView, cellForRowAt: indexPath) as? CellConfigurable
        
        XCTAssertNotNil(cell)
    }
    
    
    func test_Height_For_Row_In_TableView() {
        let indexPath = IndexPath(row: 0, section: 0)
        
        
        let height = sut.tableView.delegate?.tableView?(sut.tableView, heightForRowAt: indexPath) ?? 0.0
        
        
        let sectionViewModel = sut.viewModel.sectionViewModels.value[indexPath.section]
        let rowViewModel = sectionViewModel.rowViewModels[indexPath.row]
        
        XCTAssertEqual(height, CGFloat(rowViewModel.rowHeight))
    }
}


extension LoginViewControllerTests {
    class MockLoginViewModel: LoginViewModel {
        var startCalled = false
        
        override func start() {
            super.start()
            
            startCalled = true
            
        }

    }
    
    final class MockLoginViewController: LoginViewController {
        private(set) var performSegueCallCount = 0
        private(set) var performSegueArgsIdentifier: [String] = []
        private(set) var performSegueArgsSender: [Any?] = []
        
        var prepareForSegueCalled = false
        
        override func performSegue(withIdentifier identifier: String, sender: Any?) {
            performSegueCallCount += 1
            performSegueArgsIdentifier.append(identifier)
            performSegueArgsSender.append(sender)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            super.prepare(for: segue, sender: sender)
            
            prepareForSegueCalled = true
        }
    }
    
}
