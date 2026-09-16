//
//  MapView.swift
//  GeoAllies
//
//  Created by Agnes Pontes Ristau on 31/08/26.
//

import SwiftUI
import SwiftData
import UIKit

struct EstiloIlha3D: ButtonStyle {

    @Environment(\.accessibilityReduceMotion)
    private var reduceMotion

    func makeBody(
        configuration: Configuration
    ) -> some View {

        ZStack {

            configuration.label
                .overlay(
                    Color(
                        red: 0.6,
                        green: 0.35,
                        blue: 0.1
                    )
                )
                .mask(configuration.label)
                .offset(
                    x: 4,
                    y: 7
                )

            configuration.label
                .offset(
                    x: configuration.isPressed ? 4 : 0,
                    y: configuration.isPressed ? 7 : 0
                )
        }
        .animation(
            reduceMotion
                ? nil
                : .spring(
                    response: 0.3,
                    dampingFraction: 0.6
                ),
            value: configuration.isPressed
        )
    }
}

struct MapView: View {

    @Environment(\.modelContext)
    private var context

    @Query
    private var savedCountries: [Country]

    @State
    private var gameManager = GameManager()

    // MARK: - Acessibilidade

    @Environment(\.accessibilityVoiceOverEnabled)
    private var voiceOverEnabled

    // MARK: - Popups dos países

    @State
    private var isPresentedSeuPais = false

    @State
    private var isPresentedAgnolia = false

    @State
    private var isPresentedCaustria = false

    @State
    private var isPresentedLucasia = false

    // MARK: - Conselheiro

    @State
    private var showingCounsil = false

    // MARK: - Popup final

    @State
    private var showingFinalGame = false

    // MARK: - Verifica popup

    private var hasCountryPopupOpen: Bool {

        isPresentedSeuPais ||
        isPresentedAgnolia ||
        isPresentedCaustria ||
        isPresentedLucasia ||
        showingCounsil ||
        showingFinalGame
    }

    // MARK: - Verifica alianças

    private var lucaciaAliada: Bool {

        gameManager.aliados.contains {
            $0.id == gameManager.lucacia.id
        }
    }

    private var agnoliaAliada: Bool {

        gameManager.aliados.contains {
            $0.id == gameManager.agnolia.id
        }
    }

    private var caustriaAliada: Bool {

        gameManager.aliados.contains {
            $0.id == gameManager.cuastria.id
        }
    }

    // MARK: - Body

    var body: some View {

        NavigationStack {

            ZStack {

                // MARK: - Conteúdo do mapa

                ZStack {

                    // MARK: - Fundo

                    ZStack {

                        Color.blueSea

                        Image("fundo")
                            .resizable()
                    }
                    .ignoresSafeArea()
                    .accessibilityHidden(true)

                    // MARK: - Agnólia

                    Button {

                        isPresentedAgnolia = true

                    } label: {

                        Image(
                            agnoliaAliada
                                ? "AgnoliaGreen"
                                : "AgnoliaImage"
                        )
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220)
                        .contentShape(Circle())
                        .accessibilityHidden(true)
                    }
                    .buttonStyle(
                        EstiloIlha3D()
                    )
                    .offset(
                        x: -180,
                        y: -80
                    )
                    .accessibilityElement(
                        children: .ignore
                    )
                    .accessibilityLabel(
                        "Agnólia"
                    )
                    .accessibilityValue(
                        agnoliaAliada
                            ? "País aliado"
                            : "País ainda não aliado"
                    )
                    .accessibilityHint(
                        "Toque duas vezes para abrir as informações de Agnólia"
                    )
                    .accessibilitySortPriority(90)

                    // MARK: - Seu país

                    Button {

                        isPresentedSeuPais = true

                    } label: {

                        Image("PaísSeu")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 190)
                            .contentShape(Circle())
                            .accessibilityHidden(true)
                    }
                    .buttonStyle(
                        EstiloIlha3D()
                    )
                    .offset(
                        x: -180,
                        y: 100
                    )
                    .accessibilityElement(
                        children: .ignore
                    )
                    .accessibilityLabel(
                        "Seu país"
                    )
                    .accessibilityHint(
                        "Toque duas vezes para abrir as informações do seu país"
                    )
                    .accessibilitySortPriority(100)

                    // MARK: - Cáustria

                    Button {

                        isPresentedCaustria = true

                    } label: {

                        Image(
                            caustriaAliada
                                ? "CaustriaGreen"
                                : "CaustriaImage"
                        )
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 210)
                        .contentShape(Circle())
                        .accessibilityHidden(true)
                    }
                    .buttonStyle(
                        EstiloIlha3D()
                    )
                    .offset(
                        x: 20,
                        y: 30
                    )
                    .accessibilityElement(
                        children: .ignore
                    )
                    .accessibilityLabel(
                        "Cáustria"
                    )
                    .accessibilityValue(
                        caustriaAliada
                            ? "País aliado"
                            : "País ainda não aliado"
                    )
                    .accessibilityHint(
                        "Toque duas vezes para abrir as informações de Cáustria"
                    )
                    .accessibilitySortPriority(80)

                    // MARK: - Lucácia

                    Button {

                        isPresentedLucasia = true

                    } label: {

                        Image(
                            lucaciaAliada
                                ? "País3"
                                : "LucaciaImage"
                        )
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width:
                                lucaciaAliada
                                ? 210
                                : 190
                        )
                        .contentShape(Capsule())
                        .accessibilityHidden(true)
                    }
                    .buttonStyle(
                        EstiloIlha3D()
                    )
                    .offset(
                        x: 230,
                        y: 0
                    )
                    .accessibilityElement(
                        children: .ignore
                    )
                    .accessibilityLabel(
                        "Lucácia"
                    )
                    .accessibilityValue(
                        lucaciaAliada
                            ? "País aliado"
                            : "País ainda não aliado"
                    )
                    .accessibilityHint(
                        "Toque duas vezes para abrir as informações de Lucácia"
                    )
                    .accessibilitySortPriority(70)

                    // MARK: - Conselheiro

                    VStack {

                        HStack {

                            Spacer()

                            counselorButton
                                .padding(
                                    .top,
                                    32
                                )
                                .padding(
                                    .trailing,
                                    48
                                )
                        }

                        Spacer()
                    }
                }

                // Quando qualquer popup estiver aberto,
                // o VoiceOver não acessa o mapa atrás.

                .accessibilityHidden(
                    hasCountryPopupOpen
                )
                .allowsHitTesting(
                    !hasCountryPopupOpen
                )

                // MARK: - Popup Seu País

                if isPresentedSeuPais {

                    PlayerCountryView(
                        isPresent:
                            $isPresentedSeuPais
                    )
                    .accessibilityAddTraits(
                        .isModal
                    )
                    .zIndex(100)
                }

                // MARK: - Popup Agnólia

                if isPresentedAgnolia {

                    AgnoliaView(
                        isPresent:
                            $isPresentedAgnolia
                    )
                    .accessibilityAddTraits(
                        .isModal
                    )
                    .zIndex(100)
                }

                // MARK: - Popup Cáustria

                if isPresentedCaustria {

                    CaustriaView(
                        isPresent:
                            $isPresentedCaustria
                    )
                    .accessibilityAddTraits(
                        .isModal
                    )
                    .zIndex(100)
                }

                // MARK: - Popup Lucácia

                if isPresentedLucasia {

                    LucaciaView(
                        isPresent:
                            $isPresentedLucasia
                    )
                    .accessibilityAddTraits(
                        .isModal
                    )
                    .zIndex(100)
                }

                // MARK: - Popup Conselheiro

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

                // MARK: - Popup final

                if showingFinalGame {

                    FinalGameView(
                        isPresent:
                            $showingFinalGame
                    )
                    .accessibilityAddTraits(
                        .isModal
                    )
                    .zIndex(2000)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(
            .hidden,
            for: .navigationBar
        )
        .environment(gameManager)

        // MARK: - Carregar dados

        .onAppear {

            if let savedData =
                savedCountries.first {

                gameManager.yourCountry =
                    savedData

                gameManager.aliados
                    .removeAll()

                if savedData.aliouAgnolia {

                    gameManager.aliados.append(
                        gameManager.agnolia
                    )
                }

                if savedData.aliouCaustria {

                    gameManager.aliados.append(
                        gameManager.cuastria
                    )
                }

                if savedData.aliouLucacia {

                    gameManager.aliados.append(
                        gameManager.lucacia
                    )
                }

            } else {

                let newData = Country(
                    economia: 0,
                    militarismo: 0,
                    tecnologia: 0
                )

                context.insert(newData)

                gameManager.yourCountry =
                    newData
            }

            announceMap()
        }

        // MARK: - Verifica os 3 aliados

        .onChange(
            of: gameManager.aliados.count
        ) {

            if gameManager.aliados.count == 3 {

                isPresentedSeuPais = false
                isPresentedAgnolia = false
                isPresentedCaustria = false
                isPresentedLucasia = false

                showingCounsil = false

                showingFinalGame = true
            }
        }
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
        .accessibilityElement(
            children: .ignore
        )
        .accessibilityLabel(
            "Conselheiro"
        )
        .accessibilityHint(
            "Toque duas vezes para conversar com o conselheiro do jogo"
        )
        .accessibilitySortPriority(60)
    }

    // MARK: - Anúncio do mapa

    private func announceMap() {

        guard voiceOverEnabled else {
            return
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.8
        ) {

            guard !hasCountryPopupOpen else {
                return
            }

            UIAccessibility.post(
                notification: .announcement,
                argument:
                    """
                    Tela do mapa do GeoAllies.
                    Neste mapa estão o seu país, Agnólia, Cáustria e Lucácia.
                    Seu objetivo é melhorar seus indicadores e formar uma aliança com os três países.
                    Você também pode acessar o conselheiro para receber ajuda durante o jogo.
                    """
            )
        }
    }
}

// MARK: - Preview

#Preview {
    MapView()
}
