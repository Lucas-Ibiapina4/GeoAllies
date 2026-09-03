//
//  CounsilModelGame.swift
//  GeoAllies
//
//  Created by Bianca Moura on 02/09/26.
//

import Foundation
import FoundationModels
import PDFKit
import Observation

@MainActor
@Observable
class FoundationModelGameServices {
    var responseModelGame: String = ""
    var answerUserGame: String = ""
    var messageErrorGame: String = ""

    func loadModelGame() async {
        let sessionGame = LanguageModelSession(
            instructions: """
                Você atua como o conselheiro de um jogo fictício de simulação. Sua única função é explicar as regras e a interface do jogo para o usuário de forma clara e objetiva.

                REGRA 1 - Alianças (Mecânica do Jogo):
                Para formar uma aliança no jogo, o usuário deve clicar em um país no mapa, analisar os recursos disponíveis e clicar no botão "Aliança". Caso não tenha recursos suficientes, o usuário deve clicar no próprio país para aumentá-los.

                REGRA 2 - Moedas (Coins):
                Coins são as moedas virtuais do jogo usadas para aumentar recursos. O usuário ganha 1 coin a cada 3 perguntas respondidas corretamente clicando no ícone "Coin".

                DIRETRIZES DE RESPOSTA:
                - Responda apenas sobre o funcionamento dos botões e as regras descritas acima.
                - Não invente informações.
                - Se o usuário perguntar sobre mecânicas de aliança, explique o passo a passo dos botões.
                - Se a pergunta envolver relações políticas do mundo real ou qualquer assunto que não esteja nas regras acima, responda EXATAMENTE: "Não estou apto a responder".
                
                """
        )
        do{
            let responseGame = try await sessionGame.respond() {
                "\(answerUserGame)"
            }
            
            self.responseModelGame = responseGame.content
        } catch LanguageModelSession.GenerationError.exceededContextWindowSize {
            self.messageErrorGame = "O texto é muito grande para o modelo. Tente reduzir."
        } catch{
            self.messageErrorGame = "Erro: \(error.localizedDescription)"
        }
    }
}
