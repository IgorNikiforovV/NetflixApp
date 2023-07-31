//
//  Movie.swift
//  NetflixCopy
//
//  Created by Игорь Никифоров on 10.07.2023.
//

import Foundation

struct TrendingContentResponse: Decodable {
    let results: [Content]
}

struct Content: Decodable {
    let id: Int
    let title: String?
    let originalLanguage: String?
    let originalTitle: String?
    let originalName: String?
    let overview: String?
    let posterPath: String?
    let mediaType: String?
    let voteAverage: Double
    let releaseDate: String?
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case originalName = "original_name"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case voteCount = "vote_count"
    }
}
