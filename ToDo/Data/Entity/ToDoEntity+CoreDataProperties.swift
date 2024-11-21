//
//  ToDoEntity+CoreDataProperties.swift
//  ToDo
//
//  Created by PinkXaciD on 2024/11/18.
//
//

import Foundation
import CoreData


extension ToDoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoEntity> {
        return NSFetchRequest<ToDoEntity>(entityName: "ToDoEntity")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var creationDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var userDescription: String?

}

extension ToDoEntity : Identifiable {

}

extension ToDoEntity {
    var wrappedDate: Date {
        self.creationDate ?? Date()
    }
    
    var wrappedName: String {
        self.name ?? ""
    }
    
    var wrappedDescription: String {
        self.userDescription ?? ""
    }
}
