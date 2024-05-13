//
//  MoviesQueriesStorage.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/12/24.
//

import Foundation
import CoreData

final class CoreDataMoviesQueriesStorage {

    private let maxStorageLimit: Int
    private let coreDataStorage: CoreDataStorage

    init(
        maxStorageLimit: Int,
        coreDataStorage: CoreDataStorage = CoreDataStorage.shared
    ) {
        self.maxStorageLimit = maxStorageLimit
        self.coreDataStorage = coreDataStorage
    }
}

extension CoreDataMoviesQueriesStorage: MoviesQueriesStorage {
    
    func fetchRecentsQueries(maxCount: Int) async throws -> [MovieQuery] {
        return try await coreDataStorage.performBackgroundTask { context in
            let request: NSFetchRequest = MovieQueryEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: #keyPath(MovieQueryEntity.createdAt),
                                                        ascending: false)]
            request.fetchLimit = maxCount
            let result = try context.fetch(request).map { $0.toDomain() }
            return result
        }
    }
    
    func saveRecentQuery(query: MovieQuery) async throws -> MovieQuery {
        return try await coreDataStorage.performBackgroundTask { context in
            try self.cleanUpQueries(for: query, inContext: context)
            let entity = MovieQueryEntity(movieQuery: query, insertInto: context)
            try context.save()
            return entity.toDomain()
        }
    }
}

// MARK: - Private
extension CoreDataMoviesQueriesStorage {

    private func cleanUpQueries(for query: MovieQuery, inContext context: NSManagedObjectContext) throws {
        let request: NSFetchRequest = MovieQueryEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(MovieQueryEntity.createdAt),
                                                    ascending: false)]
        var result = try context.fetch(request)

        removeDuplicates(for: query, in: &result, inContext: context)
        removeQueries(limit: maxStorageLimit - 1, in: result, inContext: context)
    }

    private func removeDuplicates(for query: MovieQuery, in queries: inout [MovieQueryEntity], inContext context: NSManagedObjectContext) {
        queries
            .filter { $0.query == query.query }
            .forEach { context.delete($0) }
        queries.removeAll { $0.query == query.query }
    }

    private func removeQueries(limit: Int, in queries: [MovieQueryEntity], inContext context: NSManagedObjectContext) {
        guard queries.count > limit else { return }

        queries.suffix(queries.count - limit)
            .forEach { context.delete($0) }
    }
}

