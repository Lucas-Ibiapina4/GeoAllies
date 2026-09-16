//
//  LucaciaView.swift
//  GeoAllies
//
//  Created by Agnes Pontes Ristau on 02/09/26.
//

import SwiftUI
import UIKit

struct LucaciaView: View {

    @Environment(GameManager.self)
    private var gameManager

    @Environment(\.dynamicTypeSize)
    var dynamicTypeSize

    @Environment(\.accessibilityVoiceOverEnabled)
    private var voiceOverEnabled

    @Binding var isPresent: Bool

    @State private var showingCounsil = false

    // MARK: - Pode se aliar?

    private var canAlly: Bool {
        gameManager.yourCountry.tecnologia >= 10
    }

    // MARK: - Já é aliada?

    private var lucaciaAliada: Bool {

        gameManager.aliados.contains {
            $0.id == gameManager.lucacia.id
        }
    }

    var body: some View {

        GeometryReader { geometry in

            ZStack {

                // MARK: - Conteúdo da Lucácia

                ZStack {

                    // Fundo

                    Color.black
                        .opacity(0.30)
                        .ignoresSafeArea()
                        .onTapGesture {

                            if !showingCounsil {
                                isPresent = false
                            }
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
                                .padding(.horizontal, 24)
                                .padding(.vertical, 16)

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
                                .padding(.horizontal, 32)
                                .padding(.vertical, 16)
                            }
                        }
                        .scrollIndicators(.hidden)

                        // MARK: - Fechar

                        closeButton
                    }
                    .padding(8)
                    .frame(
                        maxHeight:
                            geometry.size.height * 0.95
                    )
                    .offset(y: 15)
                    .accessibilityAddTraits(.isModal)
                }

                // Quando Cleiton estiver aberto,
                // Lucácia desaparece do VoiceOver.

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

        // MARK: - Abertura

        .onAppear {
            announceLucacia()
        }
    }

    // MARK: - Lado esquerdo

    private var countrySection: some View {

        VStack(spacing: 8) {

            // MARK: - Nome

            Text("LUCÁCIA")
                .font(
                    .custom(
                        "Fredoka-Bold",
                        size: 23
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
                .accessibilityElement(
                    children: .ignore
                )
                .accessibilityLabel("Lucácia")
                .accessibilityAddTraits(.isHeader)
                .accessibilitySortPriority(100)

            // MARK: - Imagem

            if lucaciaAliada {

                Image("País3")
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

                Ellipse()
                    .fill(
                        Color.gray.opacity(0.20)
                    )
                    .frame(
                        width: 170,
                        height: 22
                    )
                    .accessibilityHidden(true)

            } else {

                Image("LucaciaImage")
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

                Ellipse()
                    .fill(
                        Color.gray.opacity(0.20)
                    )
                    .frame(
                        width: 170,
                        height: 22
                    )
                    .accessibilityHidden(true)
            }

            // MARK: - Parte inferior

            HStack(
                alignment: .bottom,
                spacing: 12
            ) {

                counselorButton

                Text(
                    "Você precisa de 10 pontos de Tecnologia para se aliar com esse país"
                )
                .font(
                    .custom(
                        "Fredoka-Bold",
                        size: 13
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
                .accessibilityElement(
                    children: .ignore
                )
                .accessibilityLabel(
                    "Requisito para aliança"
                )
                .accessibilityValue(
                    "Você precisa de 10 pontos de Tecnologia para se aliar com Lucácia"
                )
                .accessibilitySortPriority(80)
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
    }

    // MARK: - Lado direito

    private var statisticSection: some View {

        VStack(spacing: -10) {

            // MARK: - Economia

            ProgressBar(
                name: "Economia",
                icon: "dollarsign.circle.fill",
                value:
                    gameManager
                        .lucacia
                        .economia,
                maximumValue: 10,
                type: .economia,
                showImproveButton: false
            ) {
                // Sem ação
            }
            .font(.caption2)
            .accessibilitySortPriority(70)
            .accessibilityElement(children: .combine)

            // MARK: - Militarismo

            ProgressBar(
                name: "Militarismo",
                icon: "shield.fill",
                value:
                    gameManager
                        .lucacia
                        .militarismo,
                maximumValue: 10,
                type: .militarismo,
                showImproveButton: false
            ) {
                // Sem ação
            }
            .font(.caption2)
            .accessibilitySortPriority(60)
            .accessibilityElement(children: .combine)

            // MARK: - Tecnologia

            ProgressBar(
                name: "Tecnologia",
                icon: "desktopcomputer",
                value:
                    gameManager
                        .lucacia
                        .tecnologia,
                maximumValue: 10,
                type: .tecnologia,
                showImproveButton: false
            ) {
                // Sem ação
            }
            .font(.caption2)
            .accessibilitySortPriority(50)
            .accessibilityElement(children: .combine)

            Spacer()

            // MARK: - Aliança

            if lucaciaAliada {

                Text(
                    "Você já é aliado desse país"
                )
                .font(
                    .custom(
                        "Fredoka-Bold",
                        size: 17
                    )
                )
                .foregroundStyle(
                    Color(
                        red: 0.4,
                        green: 0.4,
                        blue: 0.4
                    )
                )
                .padding(.vertical, 10)
                .accessibilityElement(
                    children: .ignore
                )
                .accessibilityLabel(
                    "Aliança concluída"
                )
                .accessibilityValue(
                    "Você já é aliado de Lucácia"
                )
                .accessibilitySortPriority(40)

            } else {

                Button {

                    allyWithLucacia()

                } label: {

                    Text("Aliar-se")
                        .font(
                            .custom(
                                "Fredoka-Bold",
                                size: 23
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
                .accessibilityElement(
                    children: .ignore
                )
                .accessibilityLabel(
                    "Aliar-se com Lucácia"
                )
                .accessibilityValue(
                    canAlly
                        ? "Disponível"
                        : "Indisponível. Você precisa de 10 pontos de Tecnologia"
                )
                .accessibilityHint(
                    canAlly
                        ? "Toque duas vezes para formar uma aliança com Lucácia"
                        : "Melhore a Tecnologia do seu país para liberar esta aliança"
                )
                .accessibilitySortPriority(40)
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
                    .accessibilityHidden(true)

                Image(
                    systemName:
                        "questionmark.bubble.fill"
                )
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .foregroundStyle(.white)
                .accessibilityHidden(true)
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement(
            children: .ignore
        )
        .accessibilityLabel("Conselheiro")
        .accessibilityHint(
            "Toque duas vezes para pedir ajuda ao conselheiro"
        )
        .accessibilitySortPriority(90)
    }

    // MARK: - Fechar

    private var closeButton: some View {

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
        .contentShape(Circle())
        .offset(
            x: 12,
            y: -12
        )
        .accessibilityElement(
            children: .ignore
        )
        .accessibilityLabel("Fechar")
        .accessibilityHint(
            "Fecha as informações de Lucácia e volta para o mapa"
        )
        .accessibilitySortPriority(0)
    }

    // MARK: - Fazer aliança

    private func allyWithLucacia() {

        guard canAlly else {
            return
        }

        gameManager.aliar(
            gameManager.lucacia
        )

        isPresent = false
    }

    // MARK: - Anúncio da tela

    private func announceLucacia() {

        guard voiceOverEnabled else {
            return
        }

        let economia =
            gameManager
                .lucacia
                .economia

        let militarismo =
            gameManager
                .lucacia
                .militarismo

        let tecnologia =
            gameManager
                .lucacia
                .tecnologia

        let situation: String

        if lucaciaAliada {

            situation =
                "Você já é aliado de Lucácia."

        } else if canAlly {

            situation =
                "Você possui os 10 pontos de Tecnologia necessários e já pode formar uma aliança com Lucácia."

        } else {

            situation =
                "Você ainda não possui os 10 pontos de Tecnologia necessários para formar uma aliança com Lucácia."
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.6
        ) {

            guard !showingCounsil else {
                return
            }

            UIAccessibility.post(
                notification: .announcement,
                argument:
                    """
                    Tela de Lucácia.
                    Você precisa de 10 pontos de Tecnologia para se aliar com este país.
                    Economia, \(economia) de 10 pontos.
                    Militarismo, \(militarismo) de 10 pontos.
                    Tecnologia, \(tecnologia) de 10 pontos.
                    \(situation)
                    """
            )
        }
    }
}

// MARK: - Preview

#Preview {

    LucaciaPreview()
}

private struct LucaciaPreview: View {

    @State
    private var gameManager =
        GameManager()

    var body: some View {

        ZStack {

            Color.blueSea
                .ignoresSafeArea()

            LucaciaView(
                isPresent:
                    .constant(true)
            )
        }
        .environment(gameManager)
    }
}
