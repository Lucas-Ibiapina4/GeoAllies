//
//  PlayerCountryView.swift
//  GeoAllies
//
//  Created by Agnes Pontes Ristau on 02/09/26.
//

import SwiftUI
import UIKit

struct PlayerCountryView: View {

    @Environment(GameManager.self) private var gameManager
    @Environment(\.accessibilityVoiceOverEnabled) private var voiceOverEnabled

    @Binding var isPresent: Bool

    @State private var showingCounsil = false
    @State private var pilarQuizselected: QuizPilar?
    @State private var isQuizOpen = false

    private var hasInnerPopupOpen: Bool {
        isQuizOpen || showingCounsil
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {

                    // MARK: - Conteúdo do país

                    ZStack {
                        Color.black
                            .opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture {
                                if !hasInnerPopupOpen {
                                    isPresent = false
                                }
                            }
                            .accessibilityHidden(true)

                        ZStack(alignment: .topTrailing) {
                            RoundedRectangle(cornerRadius: 35)
                                .fill(
                                    Color(
                                        red: 245 / 255,
                                        green: 245 / 255,
                                        blue: 245 / 255
                                    )
                                )
                                .accessibilityHidden(true)

                            HStack(spacing: 30) {
                                countrySection
                                    .accessibilitySortPriority(100)

                                statisticSection
                                    .accessibilitySortPriority(50)
                            }
                            .padding(.horizontal, 32)
                            .padding(.vertical, 18)

                            closeButton
                                .accessibilitySortPriority(10)
                        }
                        .padding(.horizontal, 65)
                        .padding(.vertical, 25)
                    }
                    .accessibilityHidden(hasInnerPopupOpen)
                    .allowsHitTesting(!hasInnerPopupOpen)

                    // MARK: - Quiz

                    if isQuizOpen,
                       let pilar = pilarQuizselected {

                        Quiz(
                            pilar: pilar,
                            isPresent: $isQuizOpen
                        )
                        .accessibilityAddTraits(.isModal)
                        .zIndex(1000)
                    }

                    // MARK: - Conselheiro

                    if showingCounsil {
                        CounsilView(
                            isPresent: $showingCounsil
                        )
                        .accessibilityAddTraits(.isModal)
                        .zIndex(1000)
                    }
                }
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            announceScreen()
        }
    }

    // MARK: - Lado esquerdo

    private var countrySection: some View {
        VStack(spacing: 10) {

            Text("SEU PAÍS")
                .font(
                    .system(
                        size: 22,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 6)
                .background(
                    Color(
                        red: 140 / 255,
                        green: 180 / 255,
                        blue: 115 / 255
                    )
                )
                .clipShape(Capsule())
                .accessibilityAddTraits(.isHeader)
                .accessibilitySortPriority(100)

            Image(decorative: "PaísSeu")
                .resizable()
                .scaledToFit()
                .frame(
                    width: 210,
                    height: 180
                )
                .accessibilityHidden(true)

            Ellipse()
                .fill(
                    Color.gray.opacity(0.20)
                )
                .frame(
                    width: 170,
                    height: 22
                )
                .accessibilityHidden(true)
            

            HStack {
                counselorButton
                    .accessibilitySortPriority(90)

                Spacer()
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
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

                Image(
                    systemName: "person.wave.2.fill"
                )
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .foregroundStyle(.white)
                .accessibilityHidden(true)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Conselheiro")
        .accessibilityHint(
            "Toque duas vezes para conversar com o conselheiro"
        )
    }

    // MARK: - Lado direito

    private var statisticSection: some View {
        VStack(spacing: 12) {

            ProgressBar(
                name: "Economia",
                icon: "dollarsign.circle.fill",
                value: gameManager.yourCountry.economia,
                maximumValue: 10,
                type: .economia
            ) {
                openEconomyQuiz()
            }
            .accessibilitySortPriority(60)
            .accessibilityElement(children: .combine)
            
            ProgressBar(
                name: "Militarismo",
                icon: "shield.fill",
                value: gameManager.yourCountry.militarismo,
                maximumValue: 10,
                type: .militarismo
            ) {
                openMilitarismQuiz()
            }
            .accessibilitySortPriority(50)
            .accessibilityElement(children: .combine)
            
            ProgressBar(
                name: "Tecnologia",
                icon: "desktopcomputer",
                value: gameManager.yourCountry.tecnologia,
                maximumValue: 10,
                type: .tecnologia
            ) {
                openTechnologyQuiz()
            }
            .accessibilitySortPriority(40)
            .accessibilityElement(children: .combine)
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 16)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .background(.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 22)
        )
    }

    // MARK: - Fechar

    private var closeButton: some View {
        Button {
            isPresent = false
        } label: {
            Image(systemName: "xmark")
                .font(
                    .system(
                        size: 22,
                        weight: .heavy
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
        .contentShape(Circle())
        .offset(
            x: 15,
            y: -15
        )
        .accessibilityLabel("Fechar")
        .accessibilityHint(
            "Fecha as informações do seu país"
        )
    }

    // MARK: - Leitura automática

    private func announceScreen() {
        guard voiceOverEnabled else {
            return
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.5
        ) {
            guard !hasInnerPopupOpen else {
                return
            }

            UIAccessibility.post(
                notification: .announcement,
                argument:
                    """
                    Tela do seu país.
                    Você pode conversar com o conselheiro para receber ajuda.
                    Economia \(gameManager.yourCountry.economia) de 10 pontos.
                    Militarismo \(gameManager.yourCountry.militarismo) de 10 pontos.
                    Tecnologia \(gameManager.yourCountry.tecnologia) de 10 pontos.
                    Você pode melhorar seus indicadores respondendo perguntas.
                    """
            )
        }
    }

    // MARK: - Abrir Quiz

    private func openEconomyQuiz() {
        pilarQuizselected = .economia
        isQuizOpen = true
    }

    private func openMilitarismQuiz() {
        pilarQuizselected = .militarismo
        isQuizOpen = true
    }

    private func openTechnologyQuiz() {
        pilarQuizselected = .tecnologia
        isQuizOpen = true
    }
}

#Preview {
    PlayerCountryPreview()
}

private struct PlayerCountryPreview: View {

    @State private var gameManager = GameManager()

    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()

            PlayerCountryView(
                isPresent: .constant(true)
            )
        }
        .environment(gameManager)
    }
}
