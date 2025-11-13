//
//   GameCardView.swift
//  Game Catalog
//
//  Created by mac on 05.11.2025.
//

import SwiftUI

struct GameCardView: View {
    let game: Game
    @EnvironmentObject var favorites: FavoritesStore

    private var isFav: Bool { favorites.isFavorite(game.id) }

    var body: some View {
        VStack(spacing: 8) {
            // Постер 16:9 з легким заокругленням
            ZStack(alignment: .bottomLeading) {
                RemoteImage(url: game.background_image)
                    .scaledToFill()
                    .frame(height: 160)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .overlay(
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.6)],
                            startPoint: .center,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(14)

                HStack(spacing: 8) {
                    if let mc = game.metacritic {
                        Text("MC \(mc)")
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.green.opacity(0.85), in: Capsule())
                    }
                    Spacer()
                    Button {
                        withAnimation(
                            .spring(response: 0.35, dampingFraction: 0.6)
                        ) {
                            favorites.toggle(game.id)
                        }
                    } label: {
                        Image(systemName: isFav ? "star.fill" : "star")
                            .foregroundStyle(
                                isFav ? .yellow : .white.opacity(0.9)
                            )
                            .imageScale(.large)
                            .shadow(radius: 3)
                    }
                    .buttonStyle(.plain)
                }
                .padding(10)
            }

            // Назва та рейтинг під постером
            VStack(alignment: .leading, spacing: 4) {
                Text(game.name)
                    .font(.headline)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 10) {
                    if let r = game.rating {
                        Label(
                            String(format: "%.1f", r),
                            systemImage: "star.fill"
                        )
                        .foregroundStyle(.yellow)
                        .font(.subheadline)
                    }
                    if let date = game.released {
                        Text(date)
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    }
                }
            }
            .padding(.horizontal, 4)
        }
        .contentShape(Rectangle())
    }
}
