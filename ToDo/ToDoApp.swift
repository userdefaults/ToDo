//
//  ToDoApp.swift
//  ToDo
//
//  Created by PinkXaciD on 2024/11/17.
//

import SwiftUI

@main
struct ToDoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, DataManager.shared.context)
                .tint(.yellow)
                .accentColor(.yellow)
        }
    }
}
