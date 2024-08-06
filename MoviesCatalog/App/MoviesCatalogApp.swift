//
//  MoviesCatalogApp.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 01/08/2024.
//

import SwiftUI

@main
struct MoviesCatalogApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ScreenFactory.shared.makeHomeView()
            }
        }
    }
}
