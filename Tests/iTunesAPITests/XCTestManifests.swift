import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        return [
            testCase(iTunesAPITests.allTests),
        ]
    }
#endif
