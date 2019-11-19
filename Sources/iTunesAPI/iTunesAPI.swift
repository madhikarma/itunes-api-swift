//
//  iTunesSearchAPI.swift
//
//
//  Created by Shagun Madhikarmi on 18/11/2019.
//
import Foundation

public class iTunesSearchAPI {
    
    private let session: URLSession
    private let jsonDecoder: JSONDecoder = JSONDecoder()
    
    
    // MARK: - Initialisers
    
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    
    // MARK: - Search
    
    @discardableResult
    public func getResults(searchTerm: String, completion: @escaping (Result<[iTunesSearchResult], iTunesSearchError>) -> ()) -> URLSessionTask {
        let url = buildSearchURL(searchTerm: searchTerm)
        let task = session.dataTask(with: url) { (data, response, error) in
            let result = self.parseResponse(data: data, response: response, error: error)
            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()
        return task
    }
    
    
    // MARK: - Lookup
    
    @discardableResult
    public func lookup(id: Int, parameters: [String: String]?, completion: @escaping (Result<[iTunesSearchResult], iTunesSearchError>) -> ()) -> URLSessionTask {
        let url = buildLookupURL(id: id, parameters: parameters)
        let task = session.dataTask(with: url) { (data, response, error) in
            let result = self.parseResponse(data: data, response: response, error: error)
            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()
        return task
    }
    
    // MARK: - Private
    
    private func buildLookupURL(id: Int, parameters: [String: String]?) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "itunes.apple.com"
        urlComponents.path = "/lookup"
        
        var queryItems: [URLQueryItem] = []
        if let queryParameters = parameters {
            for (key, value) in queryParameters {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            urlComponents.queryItems = queryItems
        }

        guard let url = urlComponents.url else {
            fatalError("Error: expected iTunes URL but instead it is nil")
        }
        return url
    }
    
    private func buildSearchURL(searchTerm: String) -> URL {
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
