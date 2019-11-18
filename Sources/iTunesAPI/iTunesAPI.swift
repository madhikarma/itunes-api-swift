import Foundation

public enum iTunesSearchError: Error {
    case missingData
    case badData(Error?)
    case unknown(Error?)
}

public enum iTunesSearchResultType: String, Codable {
    case track, collection, artist
}

public struct iTunesSearchResponse: Codable {
    
    let results: [iTunesSearchResult]
}
    
public struct iTunesSearchResult: Codable {
    public let wrapperType: iTunesSearchResultType
    public let artistId: Int
    public let artistName: String
    public let artistViewUrl: URL
    public let artworkUrl100: URL
    public let artworkUrl30: URL
    public let artworkUrl60: URL
}

public class iTunesSearchAPI {
    
    private let session: URLSession
    private let jsonDecoder: JSONDecoder = JSONDecoder()
    
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    @discardableResult
    public func getResults(searchTerm: String, completion: @escaping (Result<[iTunesSearchResult], iTunesSearchError>) -> ()) -> URLSessionTask {

        let url = buildURL(searchTerm: searchTerm)
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let this = self else {
                return
            }
            let result = this.parseResponse(data: data, response: response, error: error)
            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()
        return task
    }
    
    private func buildURL(searchTerm: String) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "itunes.apple.com"
        urlComponents.path = "/search"
        urlComponents.queryItems = [URLQueryItem(name: "term", value: searchTerm)]
        
        guard let url = urlComponents.url else {
            fatalError("Error: expected iTunes URL but instead it is nil")
        }
        return url
    }
    
    private func parseResponse(data: Data?, response: URLResponse?, error: Error?) -> Result<[iTunesSearchResult], iTunesSearchError> {
        
        guard let jsonData = data else {
            return .failure(iTunesSearchError.missingData)
        }
        
        do {
            let searchResponse = try jsonDecoder.decode(iTunesSearchResponse.self, from: jsonData)
            return .success(searchResponse.results)
        } catch (let jsonError) {
            return .failure(iTunesSearchError.badData(jsonError))
        }
    }
}
