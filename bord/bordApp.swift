//
//  bordApp.swift
//  bord
//
//  Created by Aditya Patel on 12/15/24.
//

import SwiftUI

@main
struct bordApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
