//
//  Persistence.swift
//  DevoteeApp
//
//  Created by Jash Dhinoja on 15/03/2023.
//

import CoreData

struct PersistenceController {
    //MARK: Persistent Controller
    static let shared = PersistenceController()
    
    //MARK: Persistent Container
    let container: NSPersistentContainer

    //MARK: Init - load persistent store
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "DevoteeApp")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    //MARK: Preview
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
