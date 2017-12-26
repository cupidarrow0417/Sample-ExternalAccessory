//
//  Sample_ExternalAccessoryTests.swift
//  Sample-ExternalAccessoryTests
//
//  Created by NishiokaKohei on 2017/12/23.
//  Copyright © 2017年 Kohey.Nishioka. All rights reserved.
//

import XCTest
import ExternalAccessory
@testable import Sample_ExternalAccessory

class Sample_ExternalAccessaryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testInactiveaccessory() -> Void {
        let manager = EAAccessoryManager.shared()
        let mediator = ExternalAccessoryMediator("test", manager: manager, automatic: false)

        XCTAssertTrue(mediator.protocolName == "test")

        mediator.execute(with: "", handler: { _ in })

        XCTAssertTrue(mediator.state is EAInactive)
        XCTAssertTrue(mediator.isActive == false)
        XCTAssertTrue(mediator.isAutomatic == false)
    }

    func testActiveaccessory() -> Void {
        class EAAccessoryMock: EAAccessing {
            func readProtocolStrings() -> [String] {
                return ["test"]
            }
            func accessible(with protocolName: @escaping (String) -> Bool) -> Bool {
                return readProtocolStrings().contains(where: protocolName)
            }
            func isConnected() -> Bool {
                return true
            }
        }
        class EAAccessoryManagerMock: EAManagable {
            func readConnectedAccessories() -> [EAAccessing] {
                let object = EAAccessoryMock()
                return [object]
            }
        }


        let mock = EAAccessoryManagerMock()
        let mediator = ExternalAccessoryMediator("test", manager: mock, automatic: true)

        XCTAssertTrue(mediator.protocolName == "test")

        mediator.execute(with: "", handler: { _ in  })

        XCTAssertTrue(mediator.state is EAActive)
        XCTAssertTrue(mediator.isActive == true)
        XCTAssertTrue(mediator.isAutomatic == true)

        mediator.disconnect()
        XCTAssertTrue(mediator.state is EAInactive)

        var data: String = ""
        mediator.execute(with: "test_data", handler: { (result) in
            switch result {
            case .success(let string):
                print(string)
                data = string
                break
            default:
                break
            }
        })

        XCTAssertTrue(mediator.state is EAActive)
        XCTAssertTrue(data == "test_data")
    }

}
