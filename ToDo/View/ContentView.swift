//
//  ContentView.swift
//  ToDo
//
//  Created by PinkXaciD on 2024/11/17.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext)
    private var viewContext
    @StateObject
    private var vm = ContentViewModel()
    @State
    private var presentSheet: Bool = false
    @State
    private var selectedToDo: ToDoEntity? = nil
    @State
    private var navigationLinkIsActive: Bool = false
    
    var body: some View {
        NavigationView {
            List(vm.savedToDos) { toDo in
                NavigationLink {
                    ToDoEditView(vm: ToDoEditViewModel(name: toDo.wrappedName, description: toDo.wrappedDescription, entity: toDo))
                } label: {
                    ToDoRowLabel(toDo: toDo)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    deleteButton(toDo)
                }
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    editButton(toDo)
                    
                    shareButton
                }
                .contextMenu {
                    editButton(toDo)
                    
                    shareButton
                    
                    deleteButton(toDo)
                }
            }
            .listStyle(.inset)
            .searchable(text: $vm.search)
            .navigationTitle("To Do")
            .toolbar {
                bottomBarContent
            }
            .overlay {
                if vm.state == .loading {
                    loadingOverlay
                }
            }
            .background {
                NavigationLink(isActive: $navigationLinkIsActive) {
                    if let toDo = selectedToDo {
                        ToDoEditView(vm: ToDoEditViewModel(name: toDo.wrappedName, description: toDo.wrappedDescription, entity: toDo))
                    }
                } label: {
                    EmptyView()
                }
            }
            .animation(.default, value: vm.state)
            .animation(.default, value: vm.savedToDos)
        }
        .sheet(isPresented: $presentSheet) {
            NavigationView {
                ToDoEditView(vm: ToDoEditViewModel())
            }
            .accentColor(.yellow)
        }
    }
    
    private func editButton(_ toDo: ToDoEntity) -> some View {
        Button {
            selectedToDo = toDo
            navigationLinkIsActive.toggle()
        } label: {
            Label("Edit", systemImage: "square.and.pencil")
        }
        .tint(.orange)
    }
    
    private var shareButton: some View {
        Button {} label: {
            Label("Share", systemImage: "square.and.arrow.up")
        }
        .tint(.accentColor)
    }
    
    private func deleteButton(_ toDo: ToDoEntity) -> some View {
        Button(role: .destructive) {
            viewContext.delete(toDo)
            try? viewContext.save()
        } label: {
            Label("Delete", systemImage: "trash")
        }
        .tint(.red)
    }
    
    private var bottomBarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            Spacer()
            
            Text("\(vm.savedToDos.count) Tasks")
                .font(.footnote)
            
            Spacer()
            
            Button {
                presentSheet.toggle()
            } label: {
                Label("Add new", systemImage: "square.and.pencil")
            }
        }
    }
    
    private var loadingOverlay: some View {
        Group {
            Rectangle()
                .fill(.background)
            
            VStack(spacing: 15) {
                ProgressView()
                
                Text("Loading...")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
        }
        .transition(.opacity)
    }
}

#Preview("ContentView") {
    ContentView()
}
