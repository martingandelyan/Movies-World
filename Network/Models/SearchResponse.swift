//
//  SearchResponse.swift
//  MoviesFromTheWorld
//
//  Created by Martin on 24.12.25.
//

import Foundation

struct SearchResponse: Decodable {
    let search: [Movie]

    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}
