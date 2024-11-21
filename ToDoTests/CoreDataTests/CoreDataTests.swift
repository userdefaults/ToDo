//
//  CoreDataTests.swift
//  ToDoTests
//
//  Created by PinkXaciD on 2024/11/20.
//

import XCTest
import CoreData
@testable import ToDo

final class CoreDataTests: XCTestCase {
    var dataManager: DataManager? = nil
    
    override func setUp() {
        super.setUp()
        dataManager = DataManager()
        dataManager?.clearAll()
    }
    
    override func tearDown() {
        super.tearDown()
        dataManager = nil
    }
    
    func testAddingValues() throws {
        let expectation = XCTestExpectation(description: "Add todo")
        
        let publisher = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
        
        let name = "Name"
        let description = "Description"
        
        dataManager?.newToDo(name: name, description: description)
        
        wait(for: [expectation], timeout: 3)
        publisher.cancel()
        
        let savedToDos = try dataManager?.fetch(fetchRequest: ToDoEntity.fetchRequest())
        XCTAssertEqual(savedToDos?.count, 1)
        XCTAssertEqual(name, savedToDos?.first?.wrappedName)
        XCTAssertEqual(description, savedToDos?.first?.userDescription)
    }
    
    func testDeletingValues() throws {
        let expectation = XCTestExpectation(description: "Delete todo")
        
        let publisher = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
        
        let name = "Name"
        let description = "Description"
        
        dataManager?.newToDo(name: name, description: description)
        
        let savedToDos = try dataManager?.fetch(fetchRequest: ToDoEntity.fetchRequest())
        
        guard let savedToDos else {
            XCTFail("Failed to fetch")
            return
        }
        
        for savedToDo in savedToDos {
            dataManager?.context.delete(savedToDo)
        }
        
        dataManager?.save()
        
        guard let fetchedAfterDeleting = try dataManager?.fetch(fetchRequest: ToDoEntity.fetchRequest()) else {
            XCTFail("Failed to fetch")
            return
        }
        
        wait(for: [expectation], timeout: 3)
        publisher.cancel()
        XCTAssertTrue(fetchedAfterDeleting.isEmpty)
    }
}
