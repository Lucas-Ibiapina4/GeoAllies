//
//  AgnoliaView.swift
//  GeoAllies
//
//  Created by Lucas Ibiapina on 31/08/26.
//

import SwiftUI
import SwiftData
import UIKit

struct AgnoliaView: View {

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
        gameManager.yourCountry.economia >= 7
    }

    // MARK: - Já é aliado?

    private var agnoliaAliada: Bool {

        gameManager.aliados.contains {
            $0.id == gameManager.agnolia.id
        }
    }

    var body: some View {

        GeometryReader { geometry in

            ZStack {

                // MARK: - Conteúdo de Agnólia

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

                    // MARK: - Popup

                    ZStack(
                        alignment: .topTrailing
                    ) {

                        RoundedRectangle(
                            cornerRadius: 35
                        )
                        .fill(
                            Color(.systemGray6)
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

                // Quando o Conselheiro estiver
                // aberto, Agnólia não fica
                // acessível por trás.

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
            announceAgnolia()
        }
    }

    // MARK: - Lado esquerdo

    private var countrySection: some View {

        VStack(spacing: 7) {

            // MARK: - Nome

            Text("AGNÓLIA")
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
                .padding(10)
                .accessibilityElement(
                    children: .ignore
                )
                .accessibilityLabel("Agnólia")
                .accessibilityAddTraits(.isHeader)
                .accessibilitySortPriority(100)

            // MARK: - Imagem

            if agnoliaAliada {

                Image("AgnoliaGreen")
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

                Image("AgnoliaImage")
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

            // MARK: - Conselheiro + requisito

            HStack(
                alignment: .bottom,
                spacing: 11
            ) {

                counselorButton

                Text(
                    "Você precisa de 7 pontos de Economia para se aliar com esse país"
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
                    "Você precisa de 7 pontos de Economia para se aliar com Agnólia"
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
                        .agnolia
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
                        .agnolia
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
                        .agnolia
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

            // MARK: - Estado da aliança

            if agnoliaAliada {

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
                .padding(.bottom, 15)
                .accessibilityElement(
                    children: .ignore
                )
                .accessibilityLabel(
                    "Aliança concluída"
                )
                .accessibilityValue(
                    "Você já é aliado de Agnólia"
                )
                .accessibilitySortPriority(40)

            } else {

                Button {

                    allyWithAgnolia()

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
                        .padding(.vertical, 15)
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
                    "Aliar-se com Agnólia"
                )
                .accessibilityValue(
                    canAlly
                        ? "Disponível"
                        : "Indisponível. Você precisa de 7 pontos de Economia"
                )
                .accessibilityHint(
                    canAlly
                        ? "Toque duas vezes para formar uma aliança com Agnólia"
                        : "Melhore a Economia do seu país para liberar esta aliança"
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
        .accessibilityLabel(
            "Conselheiro"
        )
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
            "Fecha as informações de Agnólia e volta para o mapa"
        )
        .accessibilitySortPriority(0)
    }

    // MARK: - Fazer aliança

    private func allyWithAgnolia() {

        guard canAlly else {
            return
        }

        gameManager.aliar(
            gameManager.agnolia
        )

        isPresent = false
    }

    // MARK: - Anúncio da tela

    private func announceAgnolia() {

        guard voiceOverEnabled else {
            return
        }

        let economia =
            gameManager
                .agnolia
                .economia

        let militarismo =
            gameManager
                .agnolia
                .militarismo

        let tecnologia =
            gameManager
                .agnolia
                .tecnologia

        let situation: String

        if agnoliaAliada {

            situation =
                "Você já é aliado de Agnólia."

        } else if canAlly {

            situation =
                "Você possui os 7 pontos de Economia necessários e já pode formar uma aliança com Agnólia."

        } else {

            situation =
                "Você ainda não possui os 7 pontos de Economia necessários para formar uma aliança com Agnólia."
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
                    Tela de Agnólia.
                    Você precisa de 7 pontos de Economia para se aliar com este país.
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

    AgnoliaPreview()
}

private struct AgnoliaPreview: View {

    @State
    private var gameManager =
        GameManager()

    var body: some View {

        ZStack {

            Color.blueSea
                .ignoresSafeArea()

            AgnoliaView(
                isPresent:
                    .constant(true)
            )
        }
        .environment(gameManager)
    }
}
