//
//  Quiz.swift
//  GeoAllies
//
//  Created by Lucas Ibiapina on 31/08/26.
//

import SwiftUI

struct Quiz: View {
    let pilar: QuizPilar
    
    @Environment(GameManager.self) private var gameManager
    @Binding var isPresent: Bool
    
    @State private var questions: [QuestionsModel] = []
    
    @State private var correctOption: Int? = nil
    @State private var currentQuestionIndex = 0
    @State private var quizFinished = false
    @State private var points: Int = 0
    @State private var questionIsAnswered: Bool = false
    @State private var selectedOption: Int? = nil
    
    @State private var showingGeoCounsil = false
        
    init(pilar: QuizPilar, isPresent: Binding<Bool>) {
        self.pilar = pilar
        self._isPresent = isPresent
    }
    
    var currentQuestion: QuestionsModel? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color(red: 0.95, green: 0.95, blue: 0.95))
                
                if quizFinished {
                    endQuizScreen
                } else if let question = currentQuestion {
                    questionScreen(question: question)
                } else {
                    Text("Você já respondeu todas as perguntas disponíveis!")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
            }
            .frame(width: 700, height: 350)
            .overlay(alignment: .topTrailing) {
                closeButton
            }
            .overlay(alignment: .bottomLeading) {
                counselorButton
                    .offset(x: 600, y: -280)
            }
            
            if showingGeoCounsil {
                ZStack {
                    Color.black.opacity(0.35)
                        .ignoresSafeArea()
                    
                    CounsilView(isPresent: $showingGeoCounsil)
                }
                .zIndex(1000)
            }
        }
        .onAppear {
            setupQuiz()
        }
    }
    
    private var endQuizScreen: some View {
        VStack(spacing: 20) {
            Text("Quiz Concluído!")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.black)
            
            Text("Você respondeu todas as perguntas e ganhou \(points) pontos de \(pilar.rawValue).")
                .font(.title3)
                .foregroundColor(.gray)
        }
        .padding()
    }
    
    private func questionScreen(question: QuestionsModel) -> some View {
        HStack(spacing: 20) {
            leftSideQuestion(question: question)
            rightSideOptions(question: question)
        }
        .padding(30)
    }
    
    private func leftSideQuestion(question: QuestionsModel) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("GeoQuiz")
                .font(.headline)
                .bold()
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color(red: 0.53, green: 0.72, blue: 0.49))
                .clipShape(Capsule())
            
            Text(question.question)
                .font(.body)
                .bold()
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .padding(20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .frame(width: 320)
    }
    
    private func rightSideOptions(question: QuestionsModel) -> some View {
        VStack(spacing: 12) {
            ForEach(question.options.indices, id: \.self) { index in
                Button {
                    checkAnswer(option: question.options[index], index: index)
                } label: {
                    Text(question.options[index])
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 6)
                        .background(getButtonColor(for: index))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .disabled(questionIsAnswered)
            }
        }
        .padding(.top, 45)
    }
    
    private var closeButton: some View {
        Button {
            if !quizFinished {
                addPointInpilar()
            }
            isPresent = false
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(Color(red: 0.89, green: 0.31, blue: 0.27))
                .clipShape(Circle())
                .shadow(radius: 3, x: 0, y: 2)
        }
        .offset(x: 15, y: -15)
    }
    
    private var counselorButton: some View {
        Button(action: {
            showingGeoCounsil = true
        }) {
            ZStack {
                Circle()
                    .fill(Color(red: 241/255, green: 157/255, blue: 59/255))
                    .frame(width: 50, height: 50)
                    .shadow(radius: 3)
                
                HStack(spacing: 2) {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .foregroundColor(.white)
                    
                    Image(systemName: "waveform")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 14)
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    private func getButtonColor(for index: Int) -> Color {
        if (index == correctOption && correctOption == selectedOption) {
            return Color.green
        } else if index == selectedOption {
            return Color.red
        }
        return Color(red: 0.85, green: 0.85, blue: 0.85)
    }
    
    private func setupQuiz() {
        let allQuestions: [QuestionsModel] = Bundle.main.decode(file: "Questions.json")
        
        self.questions = allQuestions.filter { question in
            question.pilar == pilar.rawValue
        }.shuffled()
        
        if self.questions.isEmpty {
            quizFinished = true
        }
    }
    
    func checkAnswer(option: String, index: Int) {
        guard let question = currentQuestion else { return }
        
        correctOption = question.options.firstIndex(of: question.answer)
        
        if option == question.answer {
            points += 1
        }
        selectedOption = index
        
        //gameManager.answeredQuestions.insert(question.question)
        
        questionIsAnswered = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            nextQuestion()
        }
    }
    
    func nextQuestion() {
        if currentQuestionIndex + 1 < questions.count {
            currentQuestionIndex += 1
            correctOption = nil
            questionIsAnswered = false
            selectedOption = nil
        } else {
            quizFinished = true
            addPointInpilar()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isPresent = false
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
    Quiz(pilar: .economia, isPresent: .constant(true))
        .environment(GameManager())
}
