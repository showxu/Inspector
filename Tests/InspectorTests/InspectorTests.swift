
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
        measure {
            print(allClass)
        }
        addTeardownBlock {
            self.allClass = []
        }
    }

    static let allTests = [
        ("test getClassList", testGetClassList),
        ("test printClassList", testPrintClassList)
    ]
}
