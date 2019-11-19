import XCTest
@testable import iTunesAPI

final class iTunesAPITests: XCTestCase {
    func testGetSearchResults() {
        let searchAPI = iTunesSearchAPI()
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
    
    func testGetLookupResults() {
        let searchAPI = iTunesSearchAPI()
        let expectation = XCTestExpectation()
        let waiter = XCTWaiter()
        
        // 1
        searchAPI.getResults(searchTerm: "Bonobo") { (result) in
            expectation.fulfill()
            switch result {
            case .success(let searchResults):
                guard let id = searchResults.first?.artistId else {
                    XCTFail("Error: expecte to find a single result with an id")
                    return
                }
                // 2
                let lookupExpectation = XCTestExpectation()
                searchAPI.lookup(id: id, parameters: ["entity": "album"]) { (lookupResult) in
                    switch lookupResult {
                        case .success(let searchResults):
                            XCTAssertTrue(searchResults.count > 0)
                        case .failure(let error):
                            XCTFail("Error: expected search results but instead there was an error: \(error)")
                        }
                    }
                waiter.wait(for: [lookupExpectation], timeout: 5)
            case .failure(let error):
                XCTFail("Error: expected looks results but instead there was an error: \(error)")
            }
        }
        waiter.wait(for: [expectation], timeout: 5)
    }


    static var allTests = [
        ("testGetSearchResults", testGetSearchResults),
    ]
}
