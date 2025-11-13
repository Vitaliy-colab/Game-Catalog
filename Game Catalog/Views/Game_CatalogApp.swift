//
//  Game_CatalogApp.swift
//  Game Catalog
//
//  Created by mac on 05.11.2025.
//

import SwiftUI

@main
struct Game_CatalogApp: App {
    @StateObject private var favorites = FavoritesStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(favorites)
                .preferredColorScheme(.dark)
        }
    }
}
