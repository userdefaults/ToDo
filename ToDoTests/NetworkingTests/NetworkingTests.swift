//
//  NetowrkingTests.swift
//  ToDoTests
//
//  Created by PinkXaciD on 2024/11/21.
//

import XCTest
@testable import ToDo

final class NetowrkingTests: XCTestCase {
    var networkManager: NetworkManager?
    
    override func setUp() {
        super.setUp()
        networkManager = NetworkManager()
    }
    
    override func tearDown() {
        super.tearDown()
        networkManager = nil
    }
    
    func testDownloadingData() async {
        let expectations = XCTestExpectation(description: "Data downloaded")
        var itemsCount = 0
        
        await networkManager?.getData { entities in
            itemsCount = entities.count
            expectations.fulfill()
        }
        
        await fulfillment(of: [expectations], timeout: 10)
        
        XCTAssertEqual(itemsCount, 30)
    }
}
