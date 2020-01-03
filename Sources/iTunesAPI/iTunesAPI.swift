//
//  iTunesSearchAPI.swift
//
//
//  Created by Shagun Madhikarmi on 18/11/2019.
//
import Foundation

public class iTunesSearchAPI {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    
    // MARK: - Initialisers
    
    public init(session: URLSession = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    
    // MARK: - Search
    
    @discardableResult
    public func getResults(searchTerm: String, parameters: [String: String]?, completion: @escaping (Result<[iTunesSearchResult], iTunesSearchError>) -> ()) -> URLSessionTask {
        
        let url = buildSearchURL(searchTerm: searchTerm, parameters: parameters)
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            let result = self.parseResponse(data: data, response: response, error: error)
            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()
        return task
    }
    
    @discardableResult
    public func lookup(id: Int, parameters: [String: String]?, completion: @escaping (Result<[iTunesSearchResult], iTunesSearchError>) -> ()) -> URLSessionTask {
        let url = buildLookupURL(id: id, parameters: parameters)
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            let result = self.parseResponse(data: data, response: response, error: error)
            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()
        return task
    }
    
    
    // MARK: - Private - URLs
    
    private func buildLookupURL(id: Int, parameters: [String: String]?) -> URL {

        var queryParameters = ["id": "\(id)"]
        if let _ = parameters {
            queryParameters.merge(parameters!) { $1 }
        }
        return buildURL(path: "/lookup", parameters: queryParameters)
    }
    
    private func buildSearchURL(searchTerm: String, parameters: [String: String]?) -> URL {
        
        var queryParameters = ["term": searchTerm]
        if let _ = parameters {
            queryParameters.merge(parameters!) { $1 }
        }
        return buildURL(path: "/search", parameters: queryParameters)
    }

    private func buildURL(path: String, parameters: [String: String]?) -> URL {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "itunes.apple.com"
        urlComponents.path = path
        urlComponents.queryItems = parameters?.map { (key: String, value: String) in
            return URLQueryItem(name: key, value: value)
        }
        
        guard let url = urlComponents.url else {
            fatalError("Error: expected iTunes URL but instead it is nil")
        }
        return url
    }
    
    private func parseResponse(data: Data?, response: URLResponse?, error: Error?) -> Result<[iTunesSearchResult], iTunesSearchError> {
               
        guard let jsonData = data else {
            return .failure(iTunesSearchError.emptyData)
        }

        if let error = error {
            return .failure(iTunesSearchError.unknown(error))
        }
        
        do {
            let searchResponse = try decoder.decode(iTunesSearchResponse.self, from: jsonData)
            return .success(searchResponse.results)
        } catch (let jsonError) {
            return .failure(iTunesSearchError.parsingData(jsonError))
        }
    }
}
