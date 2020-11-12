//
//  ScheduleTests.swift
//  ScheduleTests
//
//  Created by Govardhan Goli on 10/29/20.
//

import XCTest
@testable import Schedule
var  sut: ViewController!
class ScheduleTests: XCTestCase {

    override func setUpWithError() throws {
        super.setUp()
        sut = ViewController()
       
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let guess = "2020-11-02T20:30:00z"
       let value = sut.convertDateFormat(inputDate: guess)
        XCTAssertEqual(value, "Mon, Nov 2", "equal")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
