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
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
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
        GeometryReader { geometry in
            ZStack {
                // MARK: - Fundo escurecido
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                // MARK: - Card do Quiz
                ZStack(alignment: .topTrailing) {
                    
                    // Fundo
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(red: 0.95, green: 0.95, blue: 0.95))
                    
                    VStack(spacing: 12) {
                        // MARK: - Cabeçalho Fixo
                        topHeaderSection
                        
                        // MARK: - Conteúdo com Rolagem
                        ScrollView {
                            if quizFinished {
                                endQuizScreen
                            } else if let question = currentQuestion {
                                questionScreen(question: question)
                            } else {
                                Text("Você já respondeu todas as perguntas disponíveis!")
                                    .foregroundColor(.gray)
                                    .font(.headline)
                                    .padding(30)
                            }
                        }
                        .scrollIndicators(.hidden)
                    }
                    .padding(.bottom, 10)
                    
                    // Botão Fechar
                    closeButton
                }
                .frame(maxWidth: min(geometry.size.width - 32, 750))
                .frame(maxHeight: geometry.size.height * 0.85)
                .padding(24)
                
                // MARK: - Popup do Conselheiro
                if showingGeoCounsil {
                    ZStack {
                        Color.black.opacity(0.35)
                            .ignoresSafeArea()
                        CounsilView(isPresent: $showingGeoCounsil)
                    }
                    .zIndex(1000)
                }
            }
        }
        .onAppear {
            setupQuiz()
        }
    }
    
    // MARK: - Cabeçalho Fixo Topo
    private var topHeaderSection: some View {
        HStack(spacing: 12) {
            counselorButton
            
            geoQuizBadge
            
            Spacer()
            
            if !quizFinished && !questions.isEmpty {
                scoreBadge
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.trailing, 28)
    }
    
    // MARK: - Badge GeoQuiz
    private var geoQuizBadge: some View {
        Text("GeoQuiz")
            .font(.custom("Fredoka", size: 20))
            .bold()
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(red: 0.53, green: 0.72, blue: 0.49))
            .clipShape(Capsule())
    }
    
    // MARK: - Tela de Fim do Quiz
    private var endQuizScreen: some View {
        VStack(spacing: 20) {
            Text("Quiz Concluído!")
                .font(.custom("Fredoka", size: 20))
                .bold()
                .foregroundColor(.black)
            
            Text("Você respondeu todas as perguntas e ganhou \(points) pontos de \(pilar.rawValue).")
                .font(.custom("Fredoka", size: 20))
                .bold()
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(30)
    }
    
    // MARK: - Conteúdo da Pergunta (Adaptativo)
    private func questionScreen(question: QuestionsModel) -> some View {
        Group {
            if dynamicTypeSize.isAccessibilitySize {
                VStack(spacing: 20) {
                    leftSideQuestion(question: question)
                    rightSideOptions(question: question)
                }
            } else {
                HStack(alignment: .top, spacing: 20) {
                    leftSideQuestion(question: question)
                    rightSideOptions(question: question)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
    }
    
    // MARK: - Pergunta (Expande na vertical)
    private func leftSideQuestion(question: QuestionsModel) -> some View {
        Text(question.question)
            .font(.custom("Fredoka-Bold", size: 19))
            .foregroundColor(.black)
            .multilineTextAlignment(.leading)
            .padding(20)
            .frame(
                maxWidth: .infinity,
                maxHeight: dynamicTypeSize.isAccessibilitySize ? nil : .infinity,
                alignment: .topLeading
            )
            .background(Color(red: 0.85, green: 0.85, blue: 0.85))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .frame(maxWidth: dynamicTypeSize.isAccessibilitySize ? .infinity : 250)
    }
    
    // MARK: - Opções / Lado Direito
    private func rightSideOptions(question: QuestionsModel) -> some View {
        VStack(spacing: 12) {
            ForEach(question.options.indices, id: \.self) { index in
                Button {
                    checkAnswer(option: question.options[index], index: index)
                } label: {
                    Text(question.options[index])
                        .font(.custom("Fredoka-SemiBold", size: 17))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(getButtonColor(for: index))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .buttonStyle(.plain)
                .disabled(questionIsAnswered)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Botão Fechar
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
        .buttonStyle(.plain)
        .offset(x: 12, y: -12)
    }
    
    // MARK: - Botão Conselheiro
    private var counselorButton: some View {
        Button(action: {
            showingGeoCounsil = true
        }) {
            ZStack {
                Circle()
                    .fill(Color(red: 241/255, green: 157/255, blue: 59/255))
                    .frame(width: 44, height: 44)
                    .shadow(radius: 3)
                
                Image(systemName: "questionmark.bubble.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 18)
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Badge de Pontos
    private var scoreBadge: some View {
        Text("\(totalPoints)/10")
            .font(.custom("Fredoka-Bold", size: 20))
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(Color(red: 0.53, green: 0.72, blue: 0.49))
            .clipShape(Capsule())
    }
    
    private var totalPoints: Int {
        let savedPoints: Int
        
        switch pilar {
        case .economia:
            savedPoints = gameManager.yourCountry.economia
        case .militarismo:
            savedPoints = gameManager.yourCountry.militarismo
        case .tecnologia:
            savedPoints = gameManager.yourCountry.tecnologia
        }
        
        return min(savedPoints + points, 10)
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
        questionIsAnswered = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            nextQuestion()
        }
    }
    
    func nextQuestion() {
        if totalPoints >= 10 {
            addPointInpilar()
            isPresent = false
            return
        }
        
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
