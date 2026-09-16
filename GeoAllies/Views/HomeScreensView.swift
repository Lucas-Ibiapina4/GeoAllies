//
//  HomeScreensView.swift
//  GeoAllies
//
//  Created by Agnes Pontes Ristau on 31/08/26.
//

import SwiftUI

struct HomeScreensView: View {

    var body: some View {

        NavigationStack {

            ZStack {

                // MARK: - Fundo

                ZStack {

                    Color.blueSea

                    Image("fundo")
                        .resizable()
                }
                .ignoresSafeArea()
                .accessibilityHidden(true)

                // MARK: - Play

                NavigationLink {

                    MapView()

                } label: {

                    ZStack {

                        // Sombra

                        RoundedRectangle(
                            cornerRadius: 50
                        )
                        .fill(
                            Color(
                                red: 77 / 255,
                                green: 45 / 255,
                                blue: 12 / 255
                            )
                        )
                        .frame(
                            width: 285,
                            height: 108
                        )
                        .offset(y: 6)
                        .accessibilityHidden(true)

                        // Botão

                        RoundedRectangle(
                            cornerRadius: 50
                        )
                        .fill(
                            Color(
                                red: 254 / 255,
                                green: 148 / 255,
                                blue: 39 / 255
                            )
                        )
                        .frame(
                            width: 285,
                            height: 102
                        )
                        .accessibilityHidden(true)

                        // Conteúdo

                        HStack(spacing: 14) {

                            Image(
                                systemName: "play.fill"
                            )
                            .font(
                                .system(size: 48)
                            )
                            .foregroundStyle(.white)
                            .accessibilityHidden(true)

                            Text("Play")
                                .font(
                                    .custom(
                                        "Fredoka",
                                        size: 55
                                    )
                                )
                                .bold()
                                .foregroundStyle(.white)
                                .accessibilityHidden(true)
                        }
                    }
                    .dynamicTypeSize(.large)
                }

                // O NavigationLink inteiro vira
                // um único elemento acessível.

                .accessibilityElement(
                    children: .ignore
                )
                .accessibilityLabel("Play")
                .accessibilityHint(
                    "Toque duas vezes para iniciar o jogo"
                )
            }

            // MARK: - Navegação

            .toolbar(
                .hidden,
                for: .navigationBar
            )
        }
    }
}

// MARK: - Preview

#Preview {
    HomeScreensView()
}
