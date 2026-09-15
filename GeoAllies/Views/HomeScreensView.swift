//
//  HomeScreensView.swift
//  GeoAllies
//
//  Created by Agnes Pontes Ristau on 31/08/26.
//

import SwiftUI

struct HomeScreensView: View {

    @State private var showingMap = false

    var body: some View {
        NavigationStack {
            ZStack {

                // MARK: - Fundo

                ZStack {
                    Color.blueSea
                        .ignoresSafeArea()

                    Image("fundo")
                        .resizable()
                        .ignoresSafeArea()
                }
                .accessibilityHidden(true)

                // MARK: - Play

                Button {
                    showingMap = true
                } label: {
                    ZStack {

                        RoundedRectangle(cornerRadius: 50)
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

                        RoundedRectangle(cornerRadius: 50)
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

                        HStack(spacing: 14) {

                            Image(systemName: "play.fill")
                                .font(.system(size: 48))
                                .foregroundStyle(.white)
                                .accessibilityHidden(true)

                            Text("Play")
                                .font(
                                    .system(
                                        size: 56,
                                        weight: .bold,
                                        design: .rounded
                                    )
                                )
                                .foregroundStyle(.white)
                                .accessibilityHidden(true)
                        }
                    }
                }
                .buttonStyle(.plain)

                // VoiceOver enxerga somente este elemento.
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Play")
                .accessibilityHint(
                    "Toque duas vezes para iniciar o jogo"
                )
            }
            .navigationDestination(
                isPresented: $showingMap
            ) {
                MapView()
            }
            .toolbar(
                .hidden,
                for: .navigationBar
            )
        }
    }
}

#Preview {
    HomeScreensView()
}
