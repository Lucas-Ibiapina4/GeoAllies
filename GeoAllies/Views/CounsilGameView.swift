//
//  CounsilGameView.swift
//  GeoAllies
//
//  Created by Bianca Moura on 02/09/26.
//

import SwiftUI
import UniformTypeIdentifiers
import Foundation
import UIKit

struct CounsilGameView: View {

    @State var isCorrectGame: Bool = false
    @State var showResultGame: Bool = false

    @State private var viewModelGame =
        FoundationModelGameServices()

    @FocusState
    private var isKeyboard: Bool

    // MARK: - Acessibilidade

    @Environment(\.accessibilityVoiceOverEnabled)
    private var voiceOverEnabled

    var body: some View {

        HStack {

            // MARK: - Conselheiro

            Image("counsil")
                .resizable()
                .scaledToFit()
                .accessibilityHidden(true)

            Spacer()
            Spacer()

            VStack(
                alignment: .leading
            ) {

                // MARK: - Título

                Text("Qual a sua dúvida?")
                    .font(
                        .custom(
                            "Fredoka-Bold",
                            size: 17
                        )
                    )
                    .accessibilityAddTraits(
                        .isHeader
                    )
                    .accessibilitySortPriority(100)

                // MARK: - Campo

                TextField(
                    "Digite aqui",
                    text:
                        $viewModelGame
                            .answerUserGame,
                    axis: .vertical
                )
                .font(
                    .custom(
                        "Fredoka-Bold",
                        size: 17
                    )
                )
                .frame(
                    maxWidth: 250
                )
                .border(
                    Color.black
                )
                .focused(
                    $isKeyboard
                )
                .accessibilityLabel(
                    "Digite sua dúvida"
                )
                .accessibilityHint(
                    "Digite uma pergunta sobre o funcionamento do jogo"
                )
                .accessibilitySortPriority(90)

                // MARK: - Erro

                if !viewModelGame
                    .messageErrorGame
                    .isEmpty {

                    Text(
                        viewModelGame
                            .messageErrorGame
                    )
                    .font(.caption)
                    .foregroundStyle(.red)
                    .accessibilityElement(
                        children: .ignore
                    )
                    .accessibilityLabel(
                        "Erro"
                    )
                    .accessibilityValue(
                        viewModelGame
                            .messageErrorGame
                    )
                    .accessibilitySortPriority(80)
                }

                // MARK: - Gerar resposta

                Button {

                    generateResponse()

                } label: {

                    Text(
                        "Gerar Resposta"
                    )
                    .font(
                        .custom(
                            "Fredoka-Bold",
                            size: 17
                        )
                    )
                    .bold()
                }
                .buttonStyle(
                    .borderedProminent
                )
                .accessibilityLabel(
                    "Gerar resposta"
                )
                .accessibilityHint(
                    "Envia sua pergunta para o conselheiro do jogo"
                )
                .accessibilitySortPriority(70)

                // MARK: - Resposta

                ScrollView {

                    if !viewModelGame
                        .responseModelGame
                        .isEmpty {

                        Text(
                            viewModelGame
                                .responseModelGame
                        )
                        .padding()
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .accessibilityElement(
                            children: .ignore
                        )
                        .accessibilityLabel(
                            "Resposta do conselheiro"
                        )
                        .accessibilityValue(
                            viewModelGame
                                .responseModelGame
                        )
                    }
                }
                .scrollIndicators(.hidden)
                .background(
                    Color(.systemGray6)
                )
                .cornerRadius(12)
                .padding()
                .accessibilitySortPriority(60)
            }
        }

        // MARK: - Abertura

        .onAppear {

            announceOpeningScreen()
        }

        // MARK: - Erro

        .onChange(
            of:
                viewModelGame
                    .messageErrorGame
        ) {

            let error =
                viewModelGame
                    .messageErrorGame

            guard !error.isEmpty else {
                return
            }

            announceError(error)
        }
    }

    // MARK: - Gerar resposta

    private func generateResponse() {

        isKeyboard = false

        if voiceOverEnabled {

            UIAccessibility.post(
                notification:
                    .announcement,
                argument:
                    "Pergunta enviada. O conselheiro está preparando a resposta."
            )
        }

        Task {

            await viewModelGame
                .loadModelGame()

            let response =
                viewModelGame
                    .responseModelGame

            if !response.isEmpty {

                announceResponse(
                    response
                )
            }
        }
    }

    // MARK: - Anúncio inicial

    private func announceOpeningScreen() {

        guard voiceOverEnabled else {
            return
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.5
        ) {

            UIAccessibility.post(
                notification:
                    .announcement,
                argument:
                    """
                    Conselheiro do jogo.
                    Aqui você pode tirar dúvidas sobre como o GeoAllies funciona.
                    Digite sua dúvida e selecione Gerar resposta.
                    """
            )
        }
    }

    // MARK: - Anunciar resposta

    private func announceResponse(
        _ response: String
    ) {

        guard voiceOverEnabled else {
            return
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.3
        ) {

            UIAccessibility.post(
                notification:
                    .announcement,
                argument:
                    "Resposta do conselheiro. \(response)"
            )
        }
    }

    // MARK: - Anunciar erro

    private func announceError(
        _ error: String
    ) {

        guard voiceOverEnabled else {
            return
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.2
        ) {

            UIAccessibility.post(
                notification:
                    .announcement,
                argument:
                    "Erro. \(error)"
            )
        }
    }
}

#Preview {
    // ContentView(text: "")
}
