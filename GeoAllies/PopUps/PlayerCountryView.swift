//
//  PlayerCountryView.swift
//  GeoAllies
//
//  Created by Agnes Pontes Ristau on 02/09/26.
//

import SwiftUI
import UIKit

struct PlayerCountryView: View {

    @Environment(GameManager.self)
    private var gameManager

    @Environment(\.dynamicTypeSize)
    var dynamicTypeSize

    @Environment(\.accessibilityVoiceOverEnabled)
    private var voiceOverEnabled

    @Binding var isPresent: Bool

    @State private var showingCounsil = false
    @State private var pilarQuizselected: QuizPilar?
    @State private var isQuizOpen = false

    // MARK: - Popup sobreposto

    private var hasOverlayOpen: Bool {
        isQuizOpen || showingCounsil
    }

    var body: some View {

        NavigationStack {

            GeometryReader { geometry in

                ZStack {

                    // MARK: - Conteúdo principal

                    ZStack {

                        // MARK: - Fundo

                        Color.black
                            .opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture {

                                isPresent = false
                            }
                            .accessibilityHidden(true)

                        // MARK: - Popup

                        ZStack(
                            alignment: .topTrailing
                        ) {

                            RoundedRectangle(
                                cornerRadius: 35
                            )
                            .fill(
                                Color(
                                    red: 245 / 255,
                                    green: 245 / 255,
                                    blue: 245 / 255
                                )
                            )
                            .accessibilityHidden(true)

                            ScrollView {

                                if dynamicTypeSize
                                    .isAccessibilitySize {

                                    VStack(spacing: 30) {

                                        countrySection
                                            .accessibilityElement(
                                                children: .contain
                                            )
                                            .accessibilitySortPriority(2)

                                        statisticSection
                                            .accessibilityElement(
                                                children: .contain
                                            )
                                            .accessibilitySortPriority(1)
                                    }
                                    .padding(
                                        .horizontal,
                                        24
                                    )
                                    .padding(
                                        .vertical,
                                        32
                                    )

                                } else {

                                    HStack(spacing: 30) {

                                        countrySection
                                            .accessibilityElement(
                                                children: .contain
                                            )
                                            .accessibilitySortPriority(2)

                                        statisticSection
                                            .accessibilityElement(
                                                children: .contain
                                            )
                                            .accessibilitySortPriority(1)
                                    }
                                    .padding(
                                        .horizontal,
                                        32
                                    )
                                    .padding(
                                        .vertical,
                                        18
                                    )
                                }
                            }
                            .scrollIndicators(.hidden)

                            // MARK: - Fechar

                            Button {

                                isPresent = false

                            } label: {

                                Image(
                                    systemName: "xmark"
                                )
                                .font(
                                    .custom(
                                        "Fredoka-Bold",
                                        size: 23
                                    )
                                )
                                .foregroundStyle(.white)
                                .frame(
                                    width: 50,
                                    height: 50
                                )
                                .background(.red)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                                .accessibilityHidden(true)
                            }
                            .buttonStyle(.plain)
                            .offset(
                                x: 12,
                                y: -12
                            )
                            .accessibilityElement(
                                children: .ignore
                            )
                            .accessibilityLabel(
                                "Fechar"
                            )
                            .accessibilityHint(
                                "Fecha as informações do seu país e volta para o mapa"
                            )
                            .accessibilitySortPriority(0)
                        }
                        .padding(8)
                        .frame(
                            maxHeight:
                                geometry.size.height * 0.95
                        )
                        .accessibilityAddTraits(.isModal)
                    }

                    // Não deixa o VoiceOver
                    // acessar o país por trás do Quiz.

                    .accessibilityHidden(
                        hasOverlayOpen
                    )
                    .allowsHitTesting(
                        !hasOverlayOpen
                    )

                    // MARK: - Quiz

                    if isQuizOpen,
                       let pilar =
                        pilarQuizselected {

                        Quiz(
                            pilar: pilar,
                            isPresent: $isQuizOpen
                        )
                        .accessibilityAddTraits(
                            .isModal
                        )
                        .zIndex(1000)
                    }

                    // MARK: - Conselheiro

                    if showingCounsil {

                        CounsilView(
                            isPresent:
                                $showingCounsil
                        )
                        .accessibilityAddTraits(
                            .isModal
                        )
                        .zIndex(1000)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)

        // MARK: - Abertura

        .onAppear {

            announcePlayerCountry()
        }
    }

    // MARK: - Lado esquerdo

    private var countrySection: some View {

        VStack(spacing: 10) {

            // MARK: - Título

            Text("SEU PAÍS")
                .font(
                    .custom(
                        "Fredoka",
                        size: 23
                    )
                )
                .bold()
                .foregroundStyle(.white)
                .padding(
                    .horizontal,
                    24
                )
                .padding(
                    .vertical,
                    6
                )
                .background(
                    Color(
                        red: 140 / 255,
                        green: 180 / 255,
                        blue: 115 / 255
                    )
                )
                .clipShape(Capsule())
                .accessibilityElement(
                    children: .ignore
                )
                .accessibilityLabel(
                    "Seu país"
                )
                .accessibilityAddTraits(
                    .isHeader
                )
                .accessibilitySortPriority(100)

            // MARK: - Imagem

            Image("PaísSeu")
                .resizable()
                .scaledToFit()
                .frame(
                    maxHeight:
                        dynamicTypeSize
                            .isAccessibilitySize
                        ? 100
                        : 170
                )
                .accessibilityHidden(true)

            // MARK: - Sombra

            Ellipse()
                .fill(
                    Color.gray
                        .opacity(0.20)
                )
                .frame(
                    width: 170,
                    height: 22
                )
                .accessibilityHidden(true)

            HStack {

                counselorButton

                Spacer()
            }
        }
        .frame(
            maxWidth: .infinity
        )
    }

    // MARK: - Conselheiro

    private var counselorButton: some View {

        Button {

            showingCounsil = true

        } label: {

            ZStack {

                Circle()
                    .fill(
                        Color(
                            red: 241 / 255,
                            green: 157 / 255,
                            blue: 59 / 255
                        )
                    )
                    .frame(
                        width: 50,
                        height: 50
                    )
                    .shadow(radius: 3)
                    .accessibilityHidden(true)

                Image(
                    systemName:
                        "questionmark.bubble.fill"
                )
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .foregroundColor(.white)
                .accessibilityHidden(true)
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement(
            children: .ignore
        )
        .accessibilityLabel(
            "Conselheiro"
        )
        .accessibilityHint(
            "Toque duas vezes para pedir ajuda ao conselheiro"
        )
        .accessibilitySortPriority(90)
    }

    // MARK: - Estatísticas

    private var statisticSection: some View {

        VStack(spacing: 12) {

            // MARK: - Economia

            ProgressBar(
                name: "Economia",
                icon:
                    "dollarsign.circle.fill",
                value:
                    gameManager
                        .yourCountry
                        .economia,
                maximumValue: 10,
                type: .economia
            ) {

                openEconomyQuiz()
            }
            .font(.caption2)
            .accessibilitySortPriority(80)

            // MARK: - Militarismo

            ProgressBar(
                name: "Militarismo",
                icon: "shield.fill",
                value:
                    gameManager
                        .yourCountry
                        .militarismo,
                maximumValue: 10,
                type: .militarismo
            ) {

                openMilitarismQuiz()
            }
            .font(.caption2)
            .accessibilitySortPriority(70)

            // MARK: - Tecnologia

            ProgressBar(
                name: "Tecnologia",
                icon:
                    "desktopcomputer",
                value:
                    gameManager
                        .yourCountry
                        .tecnologia,
                maximumValue: 10,
                type: .tecnologia
            ) {

                openTechnologyQuiz()
            }
            .font(.caption2)
            .accessibilitySortPriority(60)
        }
        .padding(
            .horizontal,
            22
        )
        .padding(
            .vertical,
            16
        )
        .frame(
            maxWidth: .infinity
        )
        .background(.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 22
            )
        )
    }

    // MARK: - Abrir Quiz

    private func openEconomyQuiz() {

        pilarQuizselected =
            .economia

        isQuizOpen = true
    }

    private func openMilitarismQuiz() {

        pilarQuizselected =
            .militarismo

        isQuizOpen = true
    }

    private func openTechnologyQuiz() {

        pilarQuizselected =
            .tecnologia

        isQuizOpen = true
    }

    // MARK: - Anúncio da tela

    private func announcePlayerCountry() {

        guard voiceOverEnabled else {
            return
        }

        let economia =
            gameManager
                .yourCountry
                .economia

        let militarismo =
            gameManager
                .yourCountry
                .militarismo

        let tecnologia =
            gameManager
                .yourCountry
                .tecnologia

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.6
        ) {

            guard !hasOverlayOpen else {
                return
            }

            UIAccessibility.post(
                notification:
                    .announcement,
                argument:
                    """
                    Tela do seu país.
                    Economia, \(economia) de 10 pontos.
                    Militarismo, \(militarismo) de 10 pontos.
                    Tecnologia, \(tecnologia) de 10 pontos.
                    Você pode melhorar seus indicadores respondendo aos quizzes.
                    Você também pode acessar o conselheiro para receber ajuda.
                    """
            )
        }
    }
}

// MARK: - Preview

#Preview {

    PlayerCountryPreview()
}

private struct PlayerCountryPreview: View {

    @State
    private var gameManager =
        GameManager()

    var body: some View {

        ZStack {

            Color.blue
                .ignoresSafeArea()

            PlayerCountryView(
                isPresent:
                    .constant(true)
            )
        }
        .environment(gameManager)
    }
}
