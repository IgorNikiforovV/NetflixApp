//
//  YoutubeSearchResult.swift
//  NetflixCopy
//
//  Created by Игорь Никифоров on 12.07.2023.
//

import Foundation

struct YoutubeSearchResult: Codable {
    let items: [VideoObject]
}

struct VideoObject: Codable {
    let id: IdVideoObject
    let kind: String?
}

struct IdVideoObject: Codable {
    let kind: String
    let videoId: String
}
