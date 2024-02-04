//
//  locarieTests.swift
//  locarieTests
//
//  Created by qiuty on 2023/10/30.
//

@testable import locarie
import XCTest

final class locarieTests: XCTestCase {
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each
    // test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of
    // each test method in the class.
  }

  func testExample() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the
    // correct results.
    // Any test you write for XCTest can be annotated as throws and async.
    // Mark your test throws to produce an unexpected failure when your test
    // encounters an uncaught error.
    // Mark your test async to allow awaiting for asynchronous code to complete.
    // Check the results with assertions afterwards.
  }

  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    measure {
      // Put the code you want to measure the time of here.
    }
  }

  func testUserDtoDecode() throws {
    let decoder = JSONDecoder()
    let data = """
      {
        "id": 1,
        "type": "BUSINESS",
        "username": "Iron man",
        "firstName": "Tony",
        "lastName": "Stark",
        "email": "123@456.com",
        "avatarUrl": null,
        "businessName": "Iron shop",
        "coverUrls": null,
        "homepageUrl": null,
        "category": "Bar",
        "introduction": null,
        "phone": null,
        "openHour": null,
        "openMinute": null,
        "closeHour": null,
        "closeMinute": null,
        "location": null,
        "address": "Shreeji Newsagents"
      }
    """
    .data(using: .utf8)!
    let dto = try decoder.decode(UserDto.self, from: data)
    print(dto)
  }
}
