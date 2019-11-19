//
//  iTunesSearchError.swift
//  
//
//  Created by Shagun Madhikarmi on 19/11/2019.
//

import Foundation

public enum iTunesSearchError: Error {
    case missingData
    case badData(Error?)
    case unknown(Error?)
}
