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
    static let posterBaseURL = "https://image.tmdb.org/t/p/w500"
    static let youtubeAPI_KEY = "AIzaSyA_83CNGwTHzPyRt69HRoPGK6Q90pZDUoA"
    static let youtubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

class APIManager {
    static let shared = APIManager()
    
    enum ContentPath: String {
        case trendingMovie = "trending/movie/day"
        case trendingTv = "trending/tv/day"
        case upcomingMovie = "movie/upcoming"
        case popularMovie = "movie/popular"
        case ratedMovie = "movie/top_rated"
        case discoverMovie = "discover/movie"
        case searchMovie = "search/movie"
    }
    
    func getTrendingMovie(completion: @escaping (Result<[Content], APIError>) -> Void) {
        getMovies(path: .trendingMovie, params: "&language=en-US&page=1", completion: completion)
    }
    
    func getTrendingTvs(completion: @escaping (Result<[Content], APIError>) -> Void) {
        getMovies(path: .trendingTv, params: "&language=en-US&page=1", completion: completion)
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Content], APIError>) -> Void) {
        getMovies(path: .upcomingMovie, params: "&language=en-US&page=1", completion: completion)
    }
    
    func getPopularMovies(completion: @escaping (Result<[Content], APIError>) -> Void) {
        getMovies(path: .popularMovie, params: "&language=en-US&page=1", completion: completion)
    }
    
    func getToRatedMovies(completion: @escaping (Result<[Content], APIError>) -> Void) {
        getMovies(path: .ratedMovie, params: "&language=en-US&page=1", completion: completion)
    }
    
    func getSearchMovies(completion: @escaping (Result<[Content], APIError>) -> Void) {
        getMovies(path: .discoverMovie, params: "&language=en-US&sort_by=popularity.desc&page=1", completion: completion)
    }
    
    func getSearchMovies(searchQuery: String, completion: @escaping (Result<[Content], APIError>) -> Void) {
        guard let searchQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        getMovies(path: .searchMovie, params: "&query=\(searchQuery)", completion: completion)
    }
    
    func getYoutubeMovies(searchQuery: String, completion: @escaping (Result<VideoObject?, APIError>) -> Void) {
        guard let searchQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.youtubeBaseURL)q=\(searchQuery)&key=\(Constants.youtubeAPI_KEY)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data, error == nil else {
                return completion(.failure(.failedToGetData))
            }
            
            do {
                let result = try JSONDecoder().decode(YoutubeSearchResult.self, from: data)
                completion(.success(result.items.first))
            } catch {
                completion(.failure(.failedToGetData))
            }
        }
        task.resume()
    }
    
    
    private func getMovies(path: ContentPath, params: String, completion: @escaping (Result<[Content], APIError>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/\(path.rawValue)?api_key=\(Constants.API_KEY)\(params)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data, error == nil else { return completion(.failure(.failedToGetData)) }
            
            do {
                let result = try JSONDecoder().decode(TrendingContentResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(.failedToGetData))
            }
        }
        task.resume()
    }
}
