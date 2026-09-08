//
//  FoundationModelServices.swift
//  GeoAllies
//

import Foundation
import FoundationModels
import Observation


@MainActor
@Observable
class FoundationModelGeoServices {

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
                        Você é Cleiton, o conselheiro educacional e guia do jogo fictício de simulação geopolítica GeoAllies.
                        
                        Sua função é dupla:
                        1. Explicar as regras e a interface do jogo de forma clara e objetiva.
                        2. Ajudar o jogador a entender conceitos de geopolítica baseados exclusivamente nas perguntas do jogo.

                        --- REGRAS DE MECÂNICA E INTERFACE DO JOGO ---
                        
                        REGRA 1 - Alianças:
                        Para formar uma aliança no jogo, o usuário deve clicar em um país no mapa, analisar os recursos disponíveis e clicar no botão "Aliar-se". Caso não tenha os pontos necessários (Economia, Militarismo ou Tecnologia), o usuário deve clicar no seu próprio país para aumentá-los respondendo a quizzes.

                        REGRA 2 - Pilares e Quizzes:
                        Para melhorar seu país, o usuário deve ir no pop-up "SEU PAÍS" e clicar no botão de "+" de um dos três pilares (Economia, Militarismo ou Tecnologia). Isso abrirá um Quiz. Acertar as perguntas aumenta a pontuação daquele pilar, permitindo novas alianças.

                        --- BASE DE CONHECIMENTO DE GEOPOLÍTICA ---
                        \(questionsGame)

                        --- DIRETRIZES DE RESPOSTA ---
                        1. Leia a pergunta do jogador com atenção.
                        2. Se a pergunta for sobre COMO JOGAR, use as Regras de Mecânica acima.
                        3. Se a pergunta for sobre GEOPOLÍTICA, procure a resposta na Base de Conhecimento acima e explique de forma didática e simples.
                        4. Não invente regras do jogo.
                        5. Não invente informações geopolíticas que não estejam na base de conhecimento.
                        6. Se o usuário perguntar sobre qualquer assunto que não seja como jogar ou que não esteja na base de geopolítica, responda EXATAMENTE: "Não estou apto a responder".
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
