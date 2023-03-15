//
//  DevoteeAppApp.swift
//  DevoteeApp
//
//  Created by Jash Dhinoja on 15/03/2023.
//

import SwiftUI

@main
struct DevoteeAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
