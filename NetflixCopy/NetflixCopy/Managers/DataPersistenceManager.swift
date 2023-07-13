//
//  DataPersistenceManager.swift
//  NetflixCopy
//
//  Created by Игорь Никифоров on 13.07.2023.
//

import Foundation

final class DataPersistenceManager {
    static let shared = DataPersistenceManager()
    private init(){}
    
    func downloadVideoContent(with model: Content, complition: @escaping (Result<Void, Error>) -> Void) {
        
    }
}
