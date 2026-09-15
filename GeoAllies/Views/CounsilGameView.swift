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

    @State private var viewModelGame = FoundationModelGameServices()

    @FocusState private var isKeyboard: Bool

    @Environment(\.accessibilityVoiceOverEnabled)
    private var voiceOverEnabled

    var body: some View {

        HStack {

            // MARK: - Imagem do Conselheiro

            Image("counsil")
                .resizable()
                .scaledToFit()
                .accessibilityLabel("Conselheiro do jogo")
                .accessibilityHint(
                    "O conselheiro ajuda a responder dúvidas sobre o funcionamento do jogo"
                )


            Spacer()

            Spacer()


            VStack(alignment: .leading, spacing: 12) {

                // MARK: - Título

                Text("Qual a sua dúvida?")
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)


                // MARK: - Campo de pergunta

                TextField(
                    "Digite aqui",
                    text: $viewModelGame.answerUserGame,
                    axis: .vertical
                )
                .frame(maxWidth: 250)
                .border(Color.black)
                .focused($isKeyboard)
                .accessibilityLabel(
                    "Digite sua dúvida sobre o jogo"
                )
                .accessibilityHint(
                    "Escreva uma pergunta para o conselheiro"
                )


                // MARK: - Mensagem de erro

                if !viewModelGame.messageErrorGame.isEmpty {

                    Text(
                        viewModelGame.messageErrorGame
                    )
                    .font(.caption)
                    .foregroundStyle(.red)
                    .accessibilityLabel(
                        "Erro. \(viewModelGame.messageErrorGame)"
                    )
                }


                // MARK: - Botão gerar resposta

                Button {

                    Task {

                        await viewModelGame.loadModelGame()

                        announceResponse()
                    }

                    isKeyboard = false

                } label: {

                    Text("Gerar Resposta")
                        .bold()
                }
                .buttonStyle(.borderedProminent)
                .accessibilityLabel(
                    "Gerar resposta"
                )
                .accessibilityHint(
                    "Envia sua dúvida para o conselheiro do jogo"
                )


                // MARK: - Resposta do Conselheiro

                ScrollView {

                    Text(
                        viewModelGame.responseModelGame
                    )
                    .padding()
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .accessibilityLabel(
                        "Resposta do conselheiro"
                    )
                    .accessibilityValue(
                        viewModelGame.responseModelGame
                    )
                }
                .background(
                    Color(.systemGray6)
                )
                .cornerRadius(12)
                .padding()
            }
        }

        // MARK: - Leitura automática da tela

        .onAppear {

            if voiceOverEnabled {

                DispatchQueue.main.asyncAfter(
                    deadline: .now() + 0.5
                ) {

                    UIAccessibility.post(
                        notification: .announcement,
                        argument:
                            """
                            Conselheiro do jogo.
                            Digite uma dúvida sobre o funcionamento do GeoAllies e selecione Gerar Resposta.
                            """
                    )
                }
            }
        }
    }


    // MARK: - Anunciar resposta

    private func announceResponse() {

        guard voiceOverEnabled else {
            return
        }


        if !viewModelGame.messageErrorGame.isEmpty {

            UIAccessibility.post(
                notification: .announcement,
                argument:
                    "Erro. \(viewModelGame.messageErrorGame)"
            )

            return
        }


        guard !viewModelGame.responseModelGame.isEmpty else {
            return
        }


        UIAccessibility.post(
            notification: .announcement,
            argument:
                """
                Resposta do conselheiro.
                \(viewModelGame.responseModelGame)
                """
        )
    }
}


#Preview {

    CounsilGameView()
}
