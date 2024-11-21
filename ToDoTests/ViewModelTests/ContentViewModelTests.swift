//
//  ContentViewModelTests.swift
//  ToDoTests
//
//  Created by PinkXaciD on 2024/11/21.
//

import XCTest
@testable import ToDo

final class ContentViewModelTests: XCTestCase {
    var vm: ContentViewModel = .init(fetchOnStart: false)
    
    override func setUp() {
        vm.savedToDos = []
    }
    
    func testIsVMFetchingFromNetwork() {
        let expectations = XCTestExpectation(description: "View model got data from network")
        
        let publisher = vm.$savedToDos
            .sink { entities in
                if !entities.isEmpty {
                    expectations.fulfill()
                }
            }
    
        vm.fetchFromNetwork(false)
        
        wait(for: [expectations], timeout: 10)
        publisher.cancel()
        
        XCTAssertFalse(vm.savedToDos.isEmpty)
        XCTAssertEqual(vm.savedToDos.count, 30)
    }
    
    func testIsVMFetchingFromCD() {
        let expectations = XCTestExpectation(description: "View model got data from core data")
        
        let publisher = vm.$savedToDos
            .sink { entities in
                if !entities.isEmpty {
                    expectations.fulfill()
                }
            }
    
        vm.fetchFromCD()
        
        wait(for: [expectations], timeout: 10)
        publisher.cancel()
        
        XCTAssertFalse(vm.savedToDos.isEmpty)
    }
}
