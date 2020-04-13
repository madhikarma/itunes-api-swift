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
    public let artistViewUrl: URL?
    public let artworkUrl100: URL?
    public let collectionType: iTunesSearchResultCollectionType?
    public let collectionName: String?
    public let wrapperType: iTunesSearchResultType

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        artistId = try container.decode(Int.self, forKey: .artistId)
        artistName = try container.decode(String.self, forKey: .artistName)
        artistViewUrl = try container.decodeIfPresent(URL.self, forKey: .artistViewUrl) ?? nil
        artworkUrl100 = try container.decodeIfPresent(URL.self, forKey: .artworkUrl100) ?? nil
        wrapperType = try container.decode(iTunesSearchResultType.self, forKey: .wrapperType)
        collectionType = try container.decodeIfPresent(iTunesSearchResultCollectionType.self, forKey: .collectionType) ?? nil
        collectionName = try container.decodeIfPresent(String.self, forKey: .collectionName) ?? nil
    }
}
