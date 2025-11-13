//
//  RootView.swift
//  Game Catalog
//
//  Created by mac on 05.11.2025.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            GameListView()
                .tabItem { Label("Каталог", systemImage: "rectangle.grid.2x2") }

            MyCollectionView()
                .tabItem { Label("Моя колекція", systemImage: "star.fill") }
        }
    }
}
