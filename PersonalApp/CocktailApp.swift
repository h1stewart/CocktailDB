//
//  CocktailApp.swift
//  CocktailApp
//
//  Created by Hailey Stewart on 4/23/23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct CocktailApp: App {
    @StateObject var cocktailVM = PersonalCocktailViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(cocktailVM)
        }
    }
}
