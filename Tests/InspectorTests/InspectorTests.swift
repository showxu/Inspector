
import XCTest
@testable import Inspector

class ClassTests: XCTestCase {
    
    lazy var allClass: [AnyClass] = {
        return Class.getClassList() ?? []
    }()
    
    override func setUp() {
        super.setUp()
    }
    
    func testGetClassList() {
        measure {
            _ = allClass
        }
    }
    
    func testPrintClassList() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        measure {
            print(allClass)
        }
    }

    static var allTests = [
        ("test getClassList", testGetClassList),
        ("test printClassList", testPrintClassList)
    ]
}
