//
//  TodoEditView.swift
//  ToDo
//
//  Created by PinkXaciD on 2024/11/19.
//

import SwiftUI

struct ToDoEditView: View {
    enum Field: Hashable {
        case title, description
    }
    
    @Environment(\.dismiss)
    private var dismiss
    @Environment(\.managedObjectContext)
    private var viewContext
    
    @StateObject
    var vm: ToDoEditViewModel
    
    @FocusState
    private var focusState: Field?
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                MultilineTextFieldView(titleKey: "Title", text: $vm.name) {
                    focusState = .title
                }
                .font(.largeTitle.bold())
                .focused($focusState, equals: .title)
                
                Text((vm.entity?.wrappedDate ?? Date()).formatted(date: .numeric, time: .omitted))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                
                ZStack {
                    Text(vm.description)
                        .padding(.vertical, 30)
                        .opacity(0)
                    
                    TextEditor(text: $vm.description)
                        .padding(.horizontal, -5)
                        .overlay(alignment: .topLeading) {
                            if vm.description.isEmpty {
                                Text("Description")
                                    .foregroundStyle(.tertiary)
                                    .padding(.top, 8)
                                    .onTapGesture {
                                        focusState = .description
                                    }
                            }
                        }
                        .focused($focusState, equals: .description)
                }
                
                Spacer()
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    vm.save()
                    dismiss()
                }
                .font(.body.bold())
                .disabled(vm.name.isEmpty)
            }
            
            ToolbarItem(placement: .topBarLeading) {
                if vm.entity == nil {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview("Edit") {
    NavigationView {
        ToDoEditView(
            vm: ToDoEditViewModel(
                name: ToDoEntity.mockData.first?.wrappedName ?? "",
                description: ToDoEntity.mockData.first?.wrappedDescription ?? "",
                entity: ToDoEntity.mockData.first
            )
        )
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Label("Back", systemImage: "chevron.backward")
                    .labelStyle(.titleAndIcon)
                    .foregroundStyle(.orange)
            }
        }
    }
}
