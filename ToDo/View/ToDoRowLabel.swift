//
//  ToDoRowLabel.swift
//  ToDo
//
//  Created by PinkXaciD on 2024/11/19.
//

import SwiftUI

struct ToDoRowLabel: View {
    @Environment(\.managedObjectContext)
    private var viewContext
    @ObservedObject
    var toDo: ToDoEntity
    
    var body: some View {
        HStack(alignment: .top) {
            Button {
                toDo.completed.toggle()
                DataManager.shared.save()
            } label: {
                CheckMarkView(isActive: toDo.completed)
                    .frame(width: 25, height: 25)
                    .padding(.trailing, 5)
            }
            .foregroundStyle(toDo.completed ? .yellow : .secondary)
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(toDo.wrappedName)
                    .fontWeight(.semibold)
                    .font(.title3)
                    .customStrikethrough(toDo.completed, color: .secondary)
                    .foregroundStyle(toDo.completed ? .secondary : .primary)
                    .lineLimit(1)
                
                if !toDo.wrappedDescription.isEmpty {
                    Text(toDo.wrappedDescription)
                        .foregroundStyle(toDo.completed ? .secondary : .primary)
                        .lineLimit(2)
                }
                
                Text(toDo.wrappedDate.formatted(date: .numeric, time: .omitted))
                    .foregroundStyle(.secondary)
            }
            .animation(.smooth, value: toDo.completed)
        }
    }
}
