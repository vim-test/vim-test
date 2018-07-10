import XCTest
@testable import VimTest

final class VimTestFinalTests: XCTestCase {
  func testExample() {
    XCTAssertEqual(VimTest().text, "Hello, World!")
  }

  static var allTests = [
    ("testExample", testExample),
  ]
}
