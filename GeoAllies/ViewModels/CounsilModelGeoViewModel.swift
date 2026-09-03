//
//  CounsilViewModel.swift
//  GeoAllies
//
//  Created by Bianca Moura on 01/09/26.
//

import Foundation
import FoundationModels
import PDFKit
import Observation

// Limite do Foundation Models
// Limite do Cloud

@MainActor
@Observable
class FoundationModelServices {
    var responseModel: String = ""
    var answerUser: String = ""
    var messageError: String = ""

    func loadModel() async {
        let questionsGame = loadThemes()
        
        let session = LanguageModelSession(
            instructions: """
                Você é um tutor educacional acadêmico de um jogo de geopolítica. Seu objetivo é explicar conceitos de economia e geografia de forma segura, didática e construtiva.
                
                BASE DE CONHECIMENTO DO JOGO:
                \(questionsGame)
                
                INSTRUÇÕES OBRIGATÓRIAS:
                1. O usuário enviará uma pergunta. Procure essa pergunta na BASE DE CONHECIMENTO DO JOGO acima.
                2. Escreva um parágrafo curto (máximo 15 linhas) explicando o contexto histórico ou econômico ou político do tema.
                3. Você DEVE incluir a exata frase da resposta correta da BASE DE CONHECIMENTO dentro do seu texto explicativo de preferência no meio do texto ou para o final.
                4. Se a pergunta do usuário NÃO estiver na BASE DE CONHECIMENTO, ignore as regras anteriores e responda EXATAMENTE com a frase: "Não estou apto a responder."
                """
        )
        do{
            let response = try await session.respond() {
                "\(answerUser)"
            }
            
            self.responseModel = response.content
        } catch LanguageModelSession.GenerationError.exceededContextWindowSize {
            self.messageError = "O texto é muito grande para o modelo. Tente reduzir."
        } catch{
            self.messageError = "Erro: \(error.localizedDescription)"
        }
    }
    
    private func getThemesFromJson() -> [QuestionsModel] {
        return Bundle.main.decode(file: "Questions.json")
    }
    
    func loadThemes() -> String {
        let questions = getThemesFromJson()
        var contextString: String = "Gabarito:\n"
        
        for item in questions {
            contextString += "Pergunta: \(item.question) - Resposta: \(item.answer)\n"
        }
        
        return contextString
    }
}


