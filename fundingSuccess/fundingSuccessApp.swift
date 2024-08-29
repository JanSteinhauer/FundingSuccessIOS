//
//  fundingSuccessApp.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 8/27/24.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {

  func application(_ application: UIApplication,

                   didFinishLaunchingWithOptions launchOptions:
[UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    FirebaseApp.configure()

    return true

  }

}


@main
struct fundingSuccessApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            SignupInformationView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
