//
//  GameRowView.swift
//  Game Catalog
//
//  Created by mac on 05.11.2025.
//

import SwiftUI

struct GameRowView: View {
    let game: Game
    @EnvironmentObject var favorites: FavoritesStore

    var body: some View {
        HStack(spacing: 12) {
            RemoteImage(url: game.background_image)
                .frame(width: 100, height: 100)
                .clipped()
                .overlay(alignment: .bottomLeading) {
                    if let mc = game.metacritic {
                        Text("MC \(mc)").font(.caption2).padding(4).background(
                            .green.opacity(0.8),
                            in: Capsule()
                        ).padding(6)
                    }
                }
                .cornerRadius(14)

            VStack(alignment: .leading, spacing: 6) {
                Text(game.name).font(.headline)
                if let r = game.rating {
                    Label(String(format: "%.1f", r), systemImage: "star.fill")
                        .foregroundStyle(.yellow)
                }
                if let date = game.released {
                    Text(date).font(.caption).foregroundStyle(.secondary)
                }
            }

            Spacer()

            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                    favorites.toggle(game.id)
                }
            } label: {
                Image(
                    systemName: favorites.isFavorite(game.id)
                        ? "star.fill" : "star"
                )
                .foregroundStyle(
                    favorites.isFavorite(game.id) ? .yellow : .secondary
                )
                .imageScale(.large)
                .scaleEffect(favorites.isFavorite(game.id) ? 1.2 : 1.0)
            }
            .buttonStyle(.plain)
        }
        .padding(8)
    }
}

