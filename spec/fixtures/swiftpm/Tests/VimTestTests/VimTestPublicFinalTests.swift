import XCTest
@testable import VimTest

public final class VimTestPublicFinalTests: XCTestCase {
  func testExample() {
    XCTAssertEqual(VimTest().text, "Hello, World!")
  }

  static var allTests = [
    ("testExample", testExample),
  ]
}
