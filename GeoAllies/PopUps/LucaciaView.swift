//
//  LucaciaView.swift
//  GeoAllies
//
//  Created by Agnes Pontes Ristau on 02/09/26.
//

import SwiftUI
import UIKit

struct LucaciaView: View {

    @Environment(GameManager.self) private var gameManager
    @Environment(\.accessibilityVoiceOverEnabled) private var voiceOverEnabled

    @Binding var isPresent: Bool

    @State private var showingCounsil = false

    private var canAlly: Bool {
        gameManager.yourCountry.tecnologia >= 10
    }

    private var lucaciaAliada: Bool {
        gameManager.aliados.contains {
            $0.id == gameManager.lucacia.id
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {

                // MARK: - Conteúdo de Lucácia

                ZStack {
                    Color.black
                        .opacity(0.30)
                        .ignoresSafeArea()
                        .onTapGesture {
                            if !showingCounsil {
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
                    .padding(.vertical, 30)
                    .offset(y: 15)
                }
                .accessibilityHidden(showingCounsil)
                .allowsHitTesting(!showingCounsil)

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
        .onAppear {
            announceScreen()
        }
    }

    // MARK: - Lado esquerdo

    private var countrySection: some View {
        VStack(spacing: 8) {

            Text("LUCÁCIA")
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

            if lucaciaAliada {
                Image("País3")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: 210,
                        height: 170
                    )
                    .accessibilityHidden(true)
            } else {
                Image("LucaciaImage")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: 210,
                        height: 170
                    )
                    .accessibilityHidden(true)
            }

            Ellipse()
                .fill(
                    Color.gray.opacity(0.20)
                )
                .frame(
                    width: 170,
                    height: 22
                )
                .accessibilityHidden(true)

            HStack(
                alignment: .bottom,
                spacing: 12
            ) {
                counselorButton
                    .accessibilitySortPriority(80)

                Text(
                    "Você precisa de 10 pontos de Tecnologia para se aliar com esse país"
                )
                .font(
                    .system(
                        size: 12,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .multilineTextAlignment(.center)
                .foregroundStyle(.black)
                .padding(.horizontal, 12)
                .padding(.vertical, 1)
                .background(.white)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 16
                    )
                )
                .accessibilityLabel(
                    "Você precisa de 10 pontos de Tecnologia para se aliar com Lucácia"
                )
                .accessibilitySortPriority(90)
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
    }

    // MARK: - Lado direito

    private var statisticSection: some View {
        VStack(spacing: -10) {

            ProgressBar(
                name: "Economia",
                icon: "dollarsign.circle.fill",
                value: gameManager.lucacia.economia,
                maximumValue: 10,
                type: .economia,
                showImproveButton: false
            ) {
            }
            .accessibilitySortPriority(60)

            ProgressBar(
                name: "Militarismo",
                icon: "shield.fill",
                value: gameManager.lucacia.militarismo,
                maximumValue: 10,
                type: .militarismo,
                showImproveButton: false
            ) {
            }
            .accessibilitySortPriority(50)

            ProgressBar(
                name: "Tecnologia",
                icon: "desktopcomputer",
                value: gameManager.lucacia.tecnologia,
                maximumValue: 10,
                type: .tecnologia,
                showImproveButton: false
            ) {
            }
            .accessibilitySortPriority(40)

            Spacer()

            if lucaciaAliada {
                Text("Você já é aliado desse país")
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(
                        Color(
                            red: 0.4,
                            green: 0.4,
                            blue: 0.4
                        )
                    )
                    .padding(.bottom, 10)
                    .accessibilityLabel(
                        "Você já é aliado de Lucácia"
                    )
                    .accessibilitySortPriority(30)

            } else {
                Button {
                    allyWithLucacia()
                } label: {
                    Text("Aliar-se")
                        .font(
                            .system(
                                size: 22,
                                weight: .bold,
                                design: .rounded
                            )
                        )
                        .foregroundStyle(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .background(
                            canAlly
                            ? Color.green
                            : Color.gray
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 20
                            )
                        )
                }
                .buttonStyle(.plain)
                .disabled(!canAlly)
                .accessibilityLabel(
                    "Aliar-se a Lucácia"
                )
                .accessibilityValue(
                    canAlly
                    ? "Disponível"
                    : "Indisponível"
                )
                .accessibilityHint(
                    canAlly
                    ? "Forma uma aliança com Lucácia"
                    : "Você precisa de 10 pontos de Tecnologia para formar esta aliança"
                )
                .accessibilitySortPriority(30)
            }
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 16)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .background(.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 22
            )
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
            x: 12,
            y: -12
        )
        .accessibilityLabel("Fechar")
        .accessibilityHint(
            "Fecha as informações de Lucácia"
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
            let situacao: String

            if lucaciaAliada {
                situacao =
                    "Lucácia já é sua aliada."
            } else if canAlly {
                situacao =
                    "Você já possui pontos suficientes para formar uma aliança."
            } else {
                situacao =
                    "Você ainda não possui pontos suficientes para formar uma aliança."
            }

            UIAccessibility.post(
                notification: .announcement,
                argument:
                    """
                    Tela de Lucácia.
                    Você precisa de 10 pontos de Tecnologia para se aliar com este país.
                    Economia \(gameManager.lucacia.economia) de 10 pontos.
                    Militarismo \(gameManager.lucacia.militarismo) de 10 pontos.
                    Tecnologia \(gameManager.lucacia.tecnologia) de 10 pontos.
                    \(situacao)
                    """
            )
        }
    }

    // MARK: - Fazer aliança

    private func allyWithLucacia() {
        guard canAlly else {
            return
        }

        gameManager.aliar(
            gameManager.lucacia
        )

        print(
            "Aliança realizada com Lucácia"
        )

        isPresent = false
    }
}

#Preview {
    LucaciaPreview()
}

private struct LucaciaPreview: View {

    @State private var gameManager =
        GameManager()

    var body: some View {
        ZStack {
            Color.blueSea
                .ignoresSafeArea()

            LucaciaView(
                isPresent: .constant(true)
            )
        }
        .environment(gameManager)
    }
}
