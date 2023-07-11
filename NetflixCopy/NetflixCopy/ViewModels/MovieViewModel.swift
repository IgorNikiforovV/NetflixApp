//
//  MovieViewModel.swift
//  NetflixCopy
//
//  Created by Игорь Никифоров on 11.07.2023.
//

import Foundation

struct MovieViewModel {
    let titleName: String
    let posterURL: String
    
    init(content: Content) {
        titleName = content.originalTitle ?? ""
        posterURL = "\(Constants.posterBaseURL)\(content.posterPath ?? "")"
    }
}
