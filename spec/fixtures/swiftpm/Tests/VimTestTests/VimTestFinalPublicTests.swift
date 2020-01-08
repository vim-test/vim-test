import XCTest
@testable import VimTest

final public class VimTestFinalPublicTests: XCTestCase {
  func testExample() {
    XCTAssertEqual(VimTest().text, "Hello, World!")
  }

  static var allTests = [
    ("testExample", testExample),
  ]
}
