//
//  ToDoEditViewModel.swift
//  ToDo
//
//  Created by PinkXaciD on 2024/11/19.
//

import Foundation

final class ToDoEditViewModel: ObservableObject {
    @Published var name: String
    @Published var description: String
    let entity: ToDoEntity?
    
    init(name: String = "", description: String = "", entity: ToDoEntity? = nil) {
        self.name = name
        self.description = description
        self.entity = entity
    }
    
    func save() {
        DataManager.shared.context.perform { [weak self] in
            guard let self else { return }
            
            let entity = self.entity ?? ToDoEntity(context: DataManager.shared.context)
            
            entity.name = name
            entity.userDescription = description
            DataManager.shared.save()
            return
        }
    }
}
