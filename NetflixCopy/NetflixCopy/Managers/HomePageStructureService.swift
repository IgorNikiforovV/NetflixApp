//
//  HomePageStructureService.swift
//  NetflixCopy
//
//  Created by Игорь Никифоров on 14.07.2023.
//

import Foundation

enum Section: Int, CaseIterable {
    case trendiongMovie = 0
    case trendingTv = 1
    case popular = 2
    case upcoming = 3
    case topRated = 4
}

final class HomePageStructureService {
    private(set) var conentShelves: [Section: [Content]] = [:]

    func fetchConentShelves(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()

        for section in Section.allCases {
            switch section {
            case .trendiongMovie:
                dispatchGroup.enter()
                APIManager.shared.getTrendingMovie { [weak self] result in
                    switch result {
                    case .success(let content):
                        self?.conentShelves[.trendiongMovie] = content
                    case .failure(let error):
                        print("Error in secrion 'trendiongMovie': \(error.localizedDescription)")
                    }
                    dispatchGroup.leave()
                }
                
            case .trendingTv:
                APIManager.shared.getTrendingTvs { [weak self] result in
                    dispatchGroup.enter()
                    switch result {
                    case .success(let content):
                        self?.conentShelves[.trendingTv] = content
                    case .failure(let error):
                        print("Error in secrion 'trendingTv': \(error.localizedDescription)")
                    }
                    dispatchGroup.leave()
                }
                
            case .popular:
                APIManager.shared.getPopularMovies { [weak self] result in
                    dispatchGroup.enter()
                    switch result {
                    case .success(let content):
                        self?.conentShelves[.popular] = content
                    case .failure(let error):
                        print("Error in secrion 'popular': \(error.localizedDescription)")
                    }
                    dispatchGroup.leave()
                }
                
            case .upcoming:
                APIManager.shared.getUpcomingMovies { [weak self] result in
                    dispatchGroup.enter()
                    switch result {
                    case .success(let content):
                        self?.conentShelves[.upcoming] = content
                    case .failure(let error):
                        print("Error in secrion 'upcoming': \(error.localizedDescription)")
                    }
                    dispatchGroup.leave()
                }
                
            case .topRated:
                APIManager.shared.getToRatedMovies { [weak self] result in
                    dispatchGroup.enter()
                    switch result {
                    case .success(let content):
                        self?.conentShelves[.topRated] = content
                    case .failure(let error):
                        print("Error in secrion 'topRated': \(error.localizedDescription)")
                    }
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .global(qos: .userInitiated)) {
            completion()
        }
    }
}
