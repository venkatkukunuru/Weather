//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by venkat kukunuru on 5/21/19.
//  Copyright © 2019 venkat kukunuru. All rights reserved.
//

import XCTest
@testable import Weather

class WeatherTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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

    func testExtendedInfoTitleStrings() {
        
        let feelLikeInfo = ExtendedInfo.feelLike.stringValue
        XCTAssertEqual(feelLikeInfo, "FEEL LIKE :  ")
        
        let chanceOfRainInfo = ExtendedInfo.dewPoint.stringValue
        XCTAssertEqual(chanceOfRainInfo, "DEW POINT :  ")
        
        let uvIndexInfo = ExtendedInfo.uvIndex.stringValue
        XCTAssertEqual(uvIndexInfo, "UV INDEX :  ")
        
        let windIndexInfo = ExtendedInfo.wind.stringValue
        XCTAssertEqual(windIndexInfo, ExtendedInfo.wind.rawValue.uppercased() + " :  ")
    }
    

}
