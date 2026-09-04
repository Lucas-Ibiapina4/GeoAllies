//
//  FoundationModelServices.swift
//  GeoAllies
//

import Foundation
import FoundationModels
import Observation


@MainActor
@Observable
class FoundationModelServices {

    var answerUser: String = ""
    var responseModel: String = ""
    var messageError: String = ""
    var isLoading: Bool = false
    
    func loadModel(question: String) async -> String? {
        // Limpa qualquer erro anterior
        messageError = ""
        
        let userQuestion = question
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        // Impede pergunta vazia
        guard !userQuestion.isEmpty else {
            messageError = "Digite uma pergunta."
            return nil
        }
        
        // Impede vários envios simultâneos
        guard !isLoading else {
            return nil
        }
        
        isLoading = true
        // Carrega o Questions.json
        let questionsGame = loadThemes()
        
        // MARK: - Cria a sessão
        
        let session = LanguageModelSession(
            
            instructions: """
            Você é Cleiton, o conselheiro educacional de um jogo de geopolítica.

            Sua função é ajudar o jogador a entender as perguntas,
            os países e as regras do jogo.

            BASE DE CONHECIMENTO:

            \(questionsGame)

            REGRAS:

            1. Leia a pergunta do jogador.
            2. Procure informações relacionadas dentro da base de conhecimento.
            3. Explique de forma simples, curta e didática.
            4. Não invente regras ou informações sobre o jogo.
            5. Caso não exista informação suficiente na base,
            responda exatamente:
            "Não estou apto a responder."
            6. Sua resposta deve ser adequada para aparecer
            dentro de um chat de jogo.
            """
        )
        
        do {
            let response = try await session.respond {
                userQuestion
            }
            responseModel = response.content
            isLoading = false
            return response.content
            
        }
        
        catch LanguageModelSession.GenerationError.exceededContextWindowSize {
            messageError = "A base de perguntas está grande demais para o modelo."
            isLoading = false
            return nil
        }
        
        catch {
            messageError = "Erro: \(error.localizedDescription)"
            isLoading = false
            return nil
        }
    }
    
    // MARK: - Buscar perguntas no JSON
    
    private func getThemesFromJson() -> [QuestionsModel] {
        return Bundle.main.decode(
            file: "Questions.json"
        )
    }
    
    // MARK: - Transformar JSON em texto
    func loadThemes() -> String {
        let questions = getThemesFromJson()
        
        var contextString = """
        Gabarito do jogo:
        """
        for item in questions {
            contextString += """
            Pergunta: \(item.question)
            Resposta: \(item.answer)
            """
        }
        
        return contextString
    }
}
