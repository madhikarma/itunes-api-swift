@testable import iTunesAPI
import XCTest

final class iTunesAPITests: XCTestCase {
//    func testGetSearchResults() {
//        let searchAPI = iTunesSearchAPI()
//        let expectation = XCTestExpectation()
//        searchAPI.getResults(searchTerm: "Bonobo", parameters: ["entity": "allArtist", "attribute": "allArtistTerm"]) { (result) in
//            expectation.fulfill()
//            switch result {
//            case .success(let values):
//                print("search success: \(values)")
//                XCTAssertTrue(values.count > 0)
//            case .failure(let error):
//                XCTFail("Error: expected search results but instead there was an error: \(error)")
//            }
//        }
//        XCTWaiter().wait(for: [expectation], timeout: 5)
//    }

    func testGetLookupResults() {
        let searchAPI = iTunesSearchAPI()
        let expectation = XCTestExpectation()
        let lookupExpectation = XCTestExpectation()

        // 1
        searchAPI.getResults(searchTerm: "Bonobo", parameters: nil) { result in
            expectation.fulfill()
            switch result {
            case let .success(searchResults):
                guard let id = searchResults.first?.artistId else {
                    XCTFail("Error: expecte to find a single result with an id")
                    return
                }
                // 2
                searchAPI.lookup(id: id, parameters: ["entity": "album"]) { lookupResult in
                    switch lookupResult {
                    case let .success(values):
                        print("lookup success: \(values)")
                        XCTAssertTrue(values.count > 0)
                    case let .failure(error):
                        XCTFail("Error: expected search results but instead there was an error: \(error)")
                    }
                    lookupExpectation.fulfill()
                }
            case let .failure(error):
                XCTFail("Error: expected looks results but instead there was an error: \(error)")
            }
        }
        wait(for: [expectation, lookupExpectation], timeout: 10.0)
    }

    static var allTests = [
//        ("testGetSearchResults", testGetSearchResults),
        ("testGetLookupResults", testGetLookupResults),
    ]
}
