//
//  iTunesSearchError.swift
//
//
//  Created by Shagun Madhikarmi on 19/11/2019.
//

import Foundation

public enum iTunesSearchError: Error {
    case emptyData
    case parsingData(Error?)
    case unknown(Error?)
}
