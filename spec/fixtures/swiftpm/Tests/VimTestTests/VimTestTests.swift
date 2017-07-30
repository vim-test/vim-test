import XCTest
@testable import VimTest

class VimTestTests: XCTestCase {
  func testExample() {
    XCTAssertEqual(VimTest().text, "Hello, World!")
  }

  func testOther() {
    XCTAssertEqual(true, true)
  }

  static var allTests = [
    ("testExample", testExample),
    ("testOther", testOther)
  ]
}
