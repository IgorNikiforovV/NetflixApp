//
//  DataPersistenceManager.swift
//  NetflixCopy
//
//  Created by Игорь Никифоров on 13.07.2023.
//

import UIKit
import CoreData

final class DataPersistenceManager {
    
    enum DatabaseError: Error {
        case faildToSaveData
        case faildToFetchData
        case faildToDeleteData
    }
    static let shared = DataPersistenceManager()
    private init(){}
    
    func downloadVideoContent(with model: Content, complition: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let item = ContentItem(context: context)
        
        item.id = Int64(model.id)
        item.mediaType = model.mediaType
        item.originalName = model.originalName
        item.originalTitle = model.originalTitle
        item.overview = model.overview
        item.posterPath = model.posterPath
        item.releaseDate = model.releaseDate
        item.voteCount = Int64(model.voteCount)
        item.voteAverage = model.voteAverage
        
        do {
            try context.save()
            complition(.success(()))
        } catch {
            print(error.localizedDescription)
            complition(.failure(DatabaseError.faildToSaveData))
        }
    }
    
    func fetchingVideoContentFromDatabase(completion: @escaping (Result<[ContentItem],Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<ContentItem>
        
        request = ContentItem.fetchRequest()
        
        do {
            let contentItems = try context.fetch(request)
            completion(.success(contentItems))
        } catch {
            completion(.failure(DatabaseError.faildToFetchData))
            print(error.localizedDescription)
        }
    }
    
    func deleteVideoContent(with model: ContentItem,
                            complition: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext

        context.delete(model)

        do {
            try context.save()
            complition(.success(()))
        } catch {
            print(error.localizedDescription)
            complition(.failure(DatabaseError.faildToSaveData))
        }
    }
}
