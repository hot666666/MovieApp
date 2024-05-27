//
//  CoreDataStorage.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/10/24.
//

import CoreData

enum CoreDataStorageError: Error {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
    case removeError(Error)
}

final class CoreDataStorage {

    static let shared = CoreDataStorage()
    
    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataStorage1")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // TODO: - Log to Crashlytics
                assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext() async throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            return try await withCheckedThrowingContinuation { continuation in
                context.perform {
                    do {
                        try context.save()
                        continuation.resume(returning: ())
                    } catch {
                        continuation.resume(throwing: CoreDataStorageError.saveError(error))
                    }
                }
            }
        }
    }
    
    // MARK: - Core Data Async Operations
    func performBackgroundTask<T>(_ block: @escaping (NSManagedObjectContext) throws -> T) async throws -> T {
        let context = persistentContainer.viewContext
        return try await withCheckedThrowingContinuation { continuation in
            context.perform {
                do {
                    let result = try block(context)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
