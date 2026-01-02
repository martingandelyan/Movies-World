//
//  Movie.swift
//  MoviesFromTheWorld
//
//  Created by Martin on 24.12.25.
//

import Foundation

struct Movie: Codable {
    let imdbID: String
    let title: String
    let year: String
    let poster: String
    let type: String

    enum CodingKeys: String, CodingKey {
        case imdbID
        case title = "Title"
        case year = "Year"
        case poster = "Poster"
        case type = "Type"
    }
}


