//
//  iTunesSearchResult.swift
//  
//
//  Created by Shagun Madhikarmi on 18/11/2019.
//

import Foundation

public struct iTunesSearchResult: Codable {
    public let wrapperType: iTunesSearchResultType
    public let artistId: Int
    public let artistName: String
    public let artistViewUrl: URL
    public let artworkUrl100: URL
    public let artworkUrl30: URL
    public let artworkUrl60: URL
}
