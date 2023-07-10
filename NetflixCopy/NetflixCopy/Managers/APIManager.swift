//
//  APIManager.swift
//  NetflixCopy
//
//  Created by Игорь Никифоров on 10.07.2023.
//

import Foundation

enum APIError: Error {
   case failedToGetData
}

struct Constants {
    static let API_KEY = "81449d29fdcafd4dfea5e06eab9d3954"
    static let baseURL = "https://api.themoviedb.org"
}

class APIManager {
    static let shared = APIManager()
    
    enum ContentPath: String {
        case trendingMovie = "trending/movie/day"
        case trendingTv = "trending/tv/day"
        case upcomingMovie = "movie/upcoming"
        case popularMovie = "movie/popular"
        case ratedMovie = "movie/top_rated"
    }
    
    func getTrendingMovie(completion: @escaping (Result<[Content], APIError>) -> Void) {
        getMovies(path: .trendingMovie, completion: completion)
    }
    
    func getTrendingTvs(completion: @escaping (Result<[Content], APIError>) -> Void) {
        getMovies(path: .trendingTv, completion: completion)
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Content], APIError>) -> Void) {
        getMovies(path: .upcomingMovie, completion: completion)
    }
    
    func getPopularMovies(completion: @escaping (Result<[Content], APIError>) -> Void) {
        getMovies(path: .popularMovie, completion: completion)
    }
    
    func getToRatedMovies(completion: @escaping (Result<[Content], APIError>) -> Void) {
        getMovies(path: .ratedMovie, completion: completion)
    }
    
    private func getMovies(path: ContentPath, completion: @escaping (Result<[Content], APIError>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/\(path.rawValue)?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data, error == nil else { return completion(.failure(.failedToGetData)) }
            
            do {
                let result = try JSONDecoder().decode(TrendingContentResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                print(error.localizedDescription)
                completion(.failure(.failedToGetData))
            }
        }
        task.resume()
    }
}
