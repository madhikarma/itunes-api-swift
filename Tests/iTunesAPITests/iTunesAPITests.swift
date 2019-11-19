import XCTest
@testable import iTunesAPI

final class iTunesAPITests: XCTestCase {
    func testGetSearchResults() {
        let searchAPI = iTunesSearchAPI()
        print(Date().timeIntervalSince1970)
        let expectation = XCTestExpectation()
        
        searchAPI.getResults(searchTerm: "Bonobo") { (result) in
            expectation.fulfill()
            switch result {
            case .success(let searchResults):
                XCTAssertTrue(searchResults.count > 0)
            case .failure(let error):
                XCTFail("Error: expected search results but instead there was an error: \(error)")
            }
        }
        XCTWaiter().wait(for: [expectation], timeout: 5)
    }

    static var allTests = [
        ("testGetSearchResults", testGetSearchResults),
    ]
}
