//
//  Quiz.swift
//  GeoAllies
//
//  Created by Lucas Ibiapina on 31/08/26.
//

import SwiftUI

struct Quiz: View {
    let pilar: QuizPilar
    let questions: [QuestionsModel]
    
    @Environment(GameManager.self) private var gameManager
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var correctOption: Int? = nil
    @State private var currentQuestionIndex = 0
    @State private var wrongOptions: Set<Int> = []
    @State private var quizFinished = false
    @State private var points: Int = 0
        
    init(pilar: QuizPilar) {
        self.pilar = pilar
        
        let allQuestions: [QuestionsModel] =
        Bundle.main.decode(file: "Questions.json")
        
        self.questions = allQuestions
            .filter { $0.pilar == pilar.rawValue}
    }
    var currentQuestion: QuestionsModel? {
        guard currentQuestionIndex < questions.count else { return nil }
        
        return questions[currentQuestionIndex]
    }
    
    var body: some View {
        if quizFinished {
            VStack(spacing: 20) {
                
                Text ("Quiz concluido")
                    .font(.largeTitle)
                    .bold()
                
                Text("Você respondeu todas as perguntas")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        } else if let question = currentQuestion {
            HStack(spacing: 10) {
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("QuizTextBox"))
                    Text(question.question)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .frame(width: 300, height: 300)
                
                VStack(spacing: 15) {
                    ForEach(question.options.indices, id: \.self) { index in
                        Button {
                            checkAnswer(
                                option: question.options[index],
                                index: index
                            )
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(
                                        correctOption == index
                                        ? Color.green
                                        : wrongOptions.contains(index)
                                            ? Color.red
                                            : Color("QuizTextBox")
                                    )
                                
                                Text(question.options[index])
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 10)
                            }
                            .frame(width: 300, height: 65)
                        }
                        .disabled(wrongOptions.contains(index) || correctOption != nil)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            Text("Nenhuma pergunta encontrada para este quiz")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    func checkAnswer(option: String, index: Int) {
        guard let question = currentQuestion else {
            return
        }
        if option == question.answer {
            correctOption = index
            points = points + 1
            print("pontos: \(points)")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                nextQuestion()
            }
        } else {
            wrongOptions.insert(index)
        }
    }
    
    func nextQuestion() {
        if currentQuestionIndex + 1 < questions.count {
            currentQuestionIndex += 1
            wrongOptions.removeAll()
            correctOption = nil
        } else {
            quizFinished = true
            addPointInpilar()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                dismiss()
            }
        }
    }
    
    func addPointInpilar(){
        switch pilar {
        case .economia:
            gameManager.yourCountry.economia = min(gameManager.yourCountry.economia + points, 10)
        case .militarismo:
            gameManager.yourCountry.militarismo = min(gameManager.yourCountry.militarismo + points, 10)
        case .tecnologia:
            gameManager.yourCountry.tecnologia = min(gameManager.yourCountry.tecnologia + points, 10)
        }
    }
}


#Preview {
    Quiz(pilar: .economia)
        .environment(GameManager())
}
