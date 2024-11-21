//
//  DataManager.swift
//  ToDo
//
//  Created by PinkXaciD on 2024/11/18.
//

import Foundation
import CoreData

final class DataManager: ObservableObject {
    static let shared: DataManager = DataManager()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        let container = NSPersistentContainer(name: "DataContainer")
        
        container.loadPersistentStores { description, error in
            if let error {
                print(error)
            }
        }
        
        self.container = container
        self.context = container.viewContext
    }
    
    func save() {
        context.perform { [weak context] in
            if (context?.hasChanges ?? false) {
                do {
                    try context?.save()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func fetch<Entity>(
        fetchRequest: NSFetchRequest<Entity>
    ) throws -> [Entity] where Entity: NSManagedObject {
        try self.context.performAndWait { [weak context] in
            return try context?.fetch(fetchRequest) ?? []
        }
    }
    
    func newToDo(name: String, description: String) {
        context.perform { [weak self] in
            guard let self else { return }
            
            let newEntity = ToDoEntity(entity: ToDoEntity.entity(), insertInto: context)
            newEntity.name = name
            newEntity.userDescription = description
            newEntity.creationDate = Date()
            newEntity.completed = false
            newEntity.id = UUID()
            
            try? context.save()
        }
    }
    
    func clearAll() {
        context.perform { [self] in
            for entity in ((try? self.context.fetch(ToDoEntity.fetchRequest())) ?? []) {
                self.context.delete(entity)
            }
            
            try? self.context.save()
            
            UserDefaults.standard.set(nil, forKey: UDKey.defaultDataDownoaded.rawValue)
        }
    }
}
