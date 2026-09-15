//
//  CaustriaView.swift
//  GeoAllies
//
//  Created by Agnes Pontes Ristau on 02/09/26.
//

import SwiftUI
import UIKit

struct CaustriaView: View {

    @Environment(GameManager.self) private var gameManager
    @Environment(\.accessibilityVoiceOverEnabled) private var voiceOverEnabled

    @Binding var isPresent: Bool

    @State private var showingCounsil = false

    private var canAlly: Bool {
        gameManager.yourCountry.militarismo >= 8
    }

    private var caustriaAliada: Bool {
        gameManager.aliados.contains {
            $0.id == gameManager.cuastria.id
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {

                // MARK: - Conteúdo de Cáustria

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
                            .fill(Color(.systemGray6))
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

            Text("CÁUSTRIA")
                .font(
                    .system(
                        size: 20,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 6)
                .background(
                    Color.green.opacity(0.65)
                )
                .clipShape(Capsule())
                .accessibilityAddTraits(.isHeader)
                .accessibilitySortPriority(100)

            if caustriaAliada {
                Image("CaustriaGreen")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: 210,
                        height: 170
                    )
                    .accessibilityHidden(true)
            } else {
                Image("CaustriaImage")
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
                    "Você precisa de 8 pontos de Militarismo para se aliar com esse país"
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
                .padding(.vertical, 10)
                .background(.white)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 16
                    )
                )
                .accessibilityLabel(
                    "Você precisa de 8 pontos de Militarismo para se aliar com Cáustria"
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
        VStack(spacing: -5) {

            ProgressBar(
                name: "Economia",
                icon: "dollarsign.circle.fill",
                value: gameManager.cuastria.economia,
                maximumValue: 10,
                type: .economia,
                showImproveButton: false
            ) {
            }
            .accessibilitySortPriority(60)

            ProgressBar(
                name: "Militarismo",
                icon: "shield.fill",
                value: gameManager.cuastria.militarismo,
                maximumValue: 10,
                type: .militarismo,
                showImproveButton: false
            ) {
            }
            .accessibilitySortPriority(50)

            ProgressBar(
                name: "Tecnologia",
                icon: "desktopcomputer",
                value: gameManager.cuastria.tecnologia,
                maximumValue: 10,
                type: .tecnologia,
                showImproveButton: false
            ) {
            }
            .accessibilitySortPriority(40)

            Spacer()

            if caustriaAliada {
                Text(
                    "Você já é aliado desse país"
                )
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
                    "Você já é aliado de Cáustria"
                )
                .accessibilitySortPriority(30)

            } else {
                Button {
                    allyWithCaustria()
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
                    "Aliar-se a Cáustria"
                )
                .accessibilityValue(
                    canAlly
                    ? "Disponível"
                    : "Indisponível"
                )
                .accessibilityHint(
                    canAlly
                    ? "Forma uma aliança com Cáustria"
                    : "Você precisa de 8 pontos de Militarismo para formar esta aliança"
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
            Image(
                systemName: "xmark"
            )
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
            "Fecha as informações de Cáustria"
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

            if caustriaAliada {
                situacao =
                    "Cáustria já é sua aliada."
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
                    Tela de Cáustria.
                    Você precisa de 8 pontos de Militarismo para se aliar com este país.
                    Economia \(gameManager.cuastria.economia) de 10 pontos.
                    Militarismo \(gameManager.cuastria.militarismo) de 10 pontos.
                    Tecnologia \(gameManager.cuastria.tecnologia) de 10 pontos.
                    \(situacao)
                    """
            )
        }
    }

    // MARK: - Fazer aliança

    private func allyWithCaustria() {
        guard canAlly else {
            return
        }

        gameManager.aliar(
            gameManager.cuastria
        )

        isPresent = false
    }
}

#Preview {
    CaustriaViewPreview()
}

private struct CaustriaViewPreview: View {

    @State private var gameManager =
        GameManager()

    var body: some View {
        ZStack {
            Color.blueSea
                .ignoresSafeArea()

            CaustriaView(
                isPresent: .constant(true)
            )
        }
        .environment(gameManager)
    }
}
