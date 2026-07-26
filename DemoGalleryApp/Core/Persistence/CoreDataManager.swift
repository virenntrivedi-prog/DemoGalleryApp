//
//  CoreDataManager.swift
//  DemoGalleryApp
//
//  Created by Viren Trivedi on 25/07/26.
//

// save fetch delete update


import UIKit
import CoreData

final class CoreDataManager {

    static let shared = CoreDataManager()

    private init() {}

    lazy var context: NSManagedObjectContext = {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    func saveContext() {
        let context = self.context
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("CoreData Save Error:", error)

            }
        }
    }
    
    func printDatabaseLocation() {

        guard let url = (UIApplication.shared.delegate as? AppDelegate)?
            .persistentContainer
            .persistentStoreCoordinator
            .persistentStores
            .first?
            .url else {
            return
        }

        print("Core Data SQLite Path:")
        print(url)
    }

}
