//
//  fundingSuccessApp.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 8/27/24.
//

import SwiftUI

@main
struct fundingSuccessApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
