//
//  iTunesSearchResult.swift
//  
//
//  Created by Shagun Madhikarmi on 18/11/2019.
//

import Foundation

public struct iTunesSearchResult: Codable {
    public let artistId: Int
    public let artistName: String
    public let artistViewUrl: URL
    public let artworkUrl100: URL
    public let collectionType: iTunesSearchResultCollectionType?
    public let wrapperType: iTunesSearchResultType

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.artistId = try container.decode(Int.self, forKey: .artistId)
        self.artistName = try container.decode(String.self, forKey: .artistName)
        self.artistViewUrl = try container.decode(URL.self, forKey: .artistViewUrl)
        self.artworkUrl100 = try container.decode(URL.self, forKey: .artworkUrl100)
        self.wrapperType = try container.decode(iTunesSearchResultType.self, forKey: .wrapperType)
        self.collectionType = try container.decodeIfPresent(iTunesSearchResultCollectionType.self, forKey: .collectionType) ?? nil
    }
}
