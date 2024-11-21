//
//  ContentViewModel.swift
//  ToDo
//
//  Created by PinkXaciD on 2024/11/18.
//

import Foundation
import Combine

final class ContentViewModel: ObservableObject {
    @Published var savedToDos: [ToDoEntity] = []
    private var fullToDos: [ToDoEntity] = []
    @Published var state: LoadingState = .loading
    @Published var search: String = ""
    var searchPublisher: AnyCancellable? = nil
    
    init(fetchOnStart: Bool = true) {
        if fetchOnStart {
            fetchToDos()
        }
        observeContextChanges()
        observeSearch()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: .NSManagedObjectContextDidSave,
            object: DataManager.shared.context
        )
        
        searchPublisher?.cancel()
    }
    
    func fetchToDos() {
        if UserDefaults.standard.bool(forKey: UDKey.defaultDataDownoaded.rawValue) || ProcessInfo.processInfo.environment["ShouldDownloadDataFromNetwork"] == "0" {
            fetchFromCD()
            return
        }
        
        fetchFromNetwork()
    }
    
    func fetchFromNetwork(_ saveToPersistantStore: Bool = true) {
        Task {
            let manager = NetworkManager()
            await manager.getData { toDos in
                await MainActor.run { [weak self] in
                    self?.savedToDos = toDos
                    self?.fullToDos = toDos
                    self?.state = .loaded
                    
                    if saveToPersistantStore {
                        DataManager.shared.save()
                        UserDefaults.standard.set(true, forKey: UDKey.defaultDataDownoaded.rawValue)
                    }
                }
            }
        }
    }
    
    @objc
    func fetchFromCD() {
        DataManager.shared.context.perform {
            let request = ToDoEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \ToDoEntity.creationDate, ascending: true)]
            
            do {
                let toDos = try DataManager.shared.context.fetch(request)
                DispatchQueue.main.async {
                    self.savedToDos = toDos
                    self.fullToDos = toDos
                    self.state = .loaded
                }
            } catch {
                print(error)
            }
        }
    }
    
    func observeContextChanges() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchFromCD),
            name: .NSManagedObjectContextDidSave,
            object: DataManager.shared.context
        )
    }
    
    func observeSearch() {
        searchPublisher = self.$search
            .debounce(for: 0.3, scheduler: DispatchQueue.global())
            .sink { [weak self] value in
                let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
                
                guard !trimmedValue.isEmpty else {
                    DispatchQueue.main.async {
                        self?.savedToDos = self?.fullToDos ?? []
                    }
                    return
                }
                
                guard let fullToDos = self?.fullToDos else { return }
                
                let filteredToDos = fullToDos.filter { entity in
                    entity.wrappedName.localizedCaseInsensitiveContains(trimmedValue) || entity.wrappedDescription.localizedCaseInsensitiveContains(trimmedValue)
                }
                
                DispatchQueue.main.async {
                    self?.savedToDos = filteredToDos
                }
            }
    }
}

extension ContentViewModel {
    enum LoadingState {
        case loading, loaded
    }
}
