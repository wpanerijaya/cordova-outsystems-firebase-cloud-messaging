import CoreData
import Foundation

@objc
open class CoreDataManager: NSObject {
    
    public static let modelName = "NotificationsModel"
    
    public static let model: NSManagedObjectModel = {
        let customBundle = Bundle.main
        guard let modelURL = customBundle.url(forResource: CoreDataManager.modelName, withExtension: "momd") else {
            fatalError("Error initializing mom")
        }
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    public lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataManager.modelName, managedObjectModel: CoreDataManager.model)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    public func context() -> NSManagedObjectContext {
        return self.storeContainer.viewContext
    }

    public func fetch<T>(_ request: NSFetchRequest<T>) throws -> [T] where T: NSFetchRequestResult {
        return try self.storeContainer.viewContext.fetch(request)
    }
    
    public func saveContext () throws {
        let context = self.storeContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                throw error
            }
        }
    }
    
}
