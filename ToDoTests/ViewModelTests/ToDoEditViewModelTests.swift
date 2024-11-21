//
//  ToDoEditViewModelTests.swift
//  ToDoTests
//
//  Created by PinkXaciD on 2024/11/21.
//

import XCTest
@testable import ToDo

final class ToDoEditViewModelTests: XCTestCase {
    var vm: ToDoEditViewModel = .init()
    
    override func setUp() {
        vm.description = ""
        vm.name = ""
    }
    
    func testViewModelCreatingNewObjects() throws {
        let expectation = XCTestExpectation(description: "Add todo from VM")
        
        let publisher = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
            .sink { _ in
                expectation.fulfill()
            }
        
        let name = "NameAddedFromVM"
        let description = "DescriptionAddedFromVM"
        
        vm.name = name
        vm.description = description
        vm.save()
        
        wait(for: [expectation], timeout: 3)
        publisher.cancel()
        
        let fetchedResults = try DataManager.shared.fetch(fetchRequest: ToDoEntity.fetchRequest())
        
        XCTAssertTrue(fetchedResults.contains(where: { $0.name == name && $0.userDescription == description }))
    }
}
