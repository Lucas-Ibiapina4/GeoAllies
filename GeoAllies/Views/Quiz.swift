//
//  Quiz.swift
//  GeoAllies
//
//  Created by Lucas Ibiapina on 31/08/26.
//

import SwiftUI
import UIKit

struct Quiz: View {

    let pilar: QuizPilar

    @Environment(GameManager.self)
    private var gameManager

    @Environment(\.dynamicTypeSize)
    private var dynamicTypeSize

    @Environment(\.accessibilityVoiceOverEnabled)
    private var voiceOverEnabled

    @Binding var isPresent: Bool

    @State private var questions: [QuestionsModel] = []
    @State private var correctOption: Int? = nil
    @State private var currentQuestionIndex = 0
    @State private var quizFinished = false
    @State private var points = 0
    @State private var questionIsAnswered = false
    @State private var selectedOption: Int? = nil
    @State private var showingGeoCounsil = false

    init(
        pilar: QuizPilar,
        isPresent: Binding<Bool>
    ) {
        self.pilar = pilar
        self._isPresent = isPresent
    }

    // MARK: - Pergunta atual

    private var currentQuestion: QuestionsModel? {

        guard currentQuestionIndex < questions.count else {
            return nil
        }

        return questions[currentQuestionIndex]
    }

    // MARK: - Body

    var body: some View {

        GeometryReader { geometry in

            ZStack {

                // MARK: - Quiz

                quizContent(
                    geometry: geometry
                )
                .accessibilityHidden(showingGeoCounsil)
                .allowsHitTesting(!showingGeoCounsil)

                // MARK: - Conselheiro

                if showingGeoCounsil {

                    ZStack {

                        Color.black
                            .opacity(0.35)
                            .ignoresSafeArea()
                            .accessibilityHidden(true)

                        CounsilView(
                            isPresent: $showingGeoCounsil
                        )
                        .accessibilityAddTraits(.isModal)
                    }
                    .zIndex(1000)
                }
            }
        }
        .onAppear {
            setupQuiz()
        }
    }

    // MARK: - Quiz

    private func quizContent(
        geometry: GeometryProxy
    ) -> some View {

        ZStack {

            // MARK: - Fundo

            Color.black
                .opacity(0.4)
                .ignoresSafeArea()
                .accessibilityHidden(true)

            // MARK: - Card

            ZStack(
                alignment: .topTrailing
            ) {

                RoundedRectangle(
                    cornerRadius: 30
                )
                .fill(
                    Color(
                        red: 0.95,
                        green: 0.95,
                        blue: 0.95
                    )
                )
                .accessibilityHidden(true)

                VStack(spacing: 12) {

                    // MARK: - Cabeçalho

                    topHeaderSection

                    // MARK: - Conteúdo

                    ScrollView {

                        if quizFinished {

                            endQuizScreen

                        } else if let question = currentQuestion {

                            questionScreen(
                                question: question
                            )

                        } else {

                            Text(
                                "Você já respondeu todas as perguntas disponíveis!"
                            )
                            .foregroundColor(.gray)
                            .font(.headline)
                            .padding(30)
                            .accessibilityElement(
                                children: .ignore
                            )
                            .accessibilityLabel(
                                "Você já respondeu todas as perguntas disponíveis"
                            )
                            .accessibilitySortPriority(80)
                        }
                    }
                    .scrollIndicators(.hidden)
                    .accessibilityElement(
                        children: .contain
                    )
                    .accessibilitySortPriority(80)
                }
                .padding(.bottom, 10)

                // MARK: - Fechar

                closeButton
            }
            .frame(
                maxWidth: min(
                    geometry.size.width - 32,
                    750
                )
            )
            .frame(
                maxHeight:
                    geometry.size.height * 0.85
            )
            .padding(24)
            .accessibilityElement(
                children: .contain
            )
            .accessibilityAddTraits(.isModal)
        }
    }

    // MARK: - Cabeçalho

    private var topHeaderSection: some View {

        HStack(spacing: 12) {

            // A ordem no código também acompanha
            // a ordem desejada do VoiceOver.

            geoQuizBadge

            counselorButton

            Spacer()

            if !quizFinished &&
                !questions.isEmpty {

                scoreBadge
            }
        }
        .padding(
            .horizontal,
            24
        )
        .padding(
            .top,
            20
        )
        .padding(
            .trailing,
            28
        )
        .accessibilityElement(
            children: .contain
        )
        .accessibilitySortPriority(100)
    }

    // MARK: - GeoQuiz

    private var geoQuizBadge: some View {

        Text("GeoQuiz")
            .font(
                .custom(
                    "Fredoka",
                    size: 20
                )
            )
            .bold()
            .foregroundColor(.white)
            .padding(
                .horizontal,
                16
            )
            .padding(
                .vertical,
                8
            )
            .background(
                Color(
                    red: 0.53,
                    green: 0.72,
                    blue: 0.49
                )
            )
            .clipShape(Capsule())
            .accessibilityElement(
                children: .ignore
            )
            .accessibilityLabel("GeoQuiz")
            .accessibilityAddTraits(.isHeader)
            .accessibilitySortPriority(100)
    }

    // MARK: - Conselheiro

    private var counselorButton: some View {

        Button {

            showingGeoCounsil = true

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
                        width: 44,
                        height: 44
                    )
                    .shadow(radius: 3)
                    .accessibilityHidden(true)

                Image(
                    systemName:
                        "questionmark.bubble.fill"
                )
                .resizable()
                .scaledToFit()
                .frame(height: 18)
                .foregroundColor(.white)
                .accessibilityHidden(true)
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement(
            children: .ignore
        )
        .accessibilityLabel("Conselheiro")
        .accessibilityHint(
            "Toque duas vezes para pedir ajuda ao conselheiro"
        )
        .accessibilitySortPriority(90)
    }

    // MARK: - Pontuação

    // MARK: - Pontuação

    private var scoreBadge: some View {

        Text("\(totalPoints)/10")
            .font(
                .custom(
                    "Fredoka-Bold",
                    size: 20
                )
            )
            .foregroundColor(.white)
            .padding(
                .horizontal,
                20
            )
            .padding(
                .vertical,
                8
            )
            .background(
                Color(
                    red: 0.53,
                    green: 0.72,
                    blue: 0.49
                )
            )
            .clipShape(Capsule())

            // O próprio 7/10 vira
            // o elemento selecionável.

            .accessibilityElement(
                children: .ignore
            )
            .accessibilityLabel(
                "Progresso"
            )
            .accessibilityValue(
                "\(totalPoints) de 10 pontos"
            )

            // Depois do conselheiro
            // e antes da pergunta.

            .accessibilitySortPriority(85)
    }
    // MARK: - Tela final

    private var endQuizScreen: some View {

        VStack(spacing: 20) {

            Text("Quiz Concluído!")
                .font(
                    .custom(
                        "Fredoka",
                        size: 20
                    )
                )
                .bold()
                .foregroundColor(.black)

            Text(
                "Você respondeu todas as perguntas e ganhou \(points) pontos de \(pilar.rawValue)."
            )
            .font(
                .custom(
                    "Fredoka",
                    size: 20
                )
            )
            .bold()
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
        }
        .padding(30)
        .accessibilityElement(
            children: .ignore
        )
        .accessibilityLabel(
            "Quiz concluído"
        )
        .accessibilityValue(
            "Você ganhou \(points) pontos de \(pilar.rawValue)"
        )
        .accessibilitySortPriority(80)
    }

    // MARK: - Pergunta

    private func questionScreen(
        question: QuestionsModel
    ) -> some View {

        Group {

            if dynamicTypeSize
                .isAccessibilitySize {

                VStack(spacing: 20) {

                    leftSideQuestion(
                        question: question
                    )

                    rightSideOptions(
                        question: question
                    )
                }

            } else {

                HStack(
                    alignment: .top,
                    spacing: 20
                ) {

                    leftSideQuestion(
                        question: question
                    )

                    rightSideOptions(
                        question: question
                    )
                }
            }
        }
        .padding(
            .horizontal,
            24
        )
        .padding(
            .vertical,
            12
        )
        .accessibilityElement(
            children: .contain
        )
    }

    // MARK: - Texto da pergunta

    private func leftSideQuestion(
        question: QuestionsModel
    ) -> some View {

        Text(question.question)
            .font(
                .custom(
                    "Fredoka-Bold",
                    size: 19
                )
            )
            .foregroundColor(.black)
            .multilineTextAlignment(.leading)
            .padding(20)
            .frame(
                maxWidth: .infinity,
                maxHeight:
                    dynamicTypeSize
                        .isAccessibilitySize
                    ? nil
                    : .infinity,
                alignment: .topLeading
            )
            .background(
                Color(
                    red: 0.85,
                    green: 0.85,
                    blue: 0.85
                )
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 20
                )
            )
            .frame(
                maxWidth:
                    dynamicTypeSize
                        .isAccessibilitySize
                    ? .infinity
                    : 250
            )

            // Elemento REAL da pergunta.

            .accessibilityElement(
                children: .ignore
            )
            .accessibilityLabel(
                "Pergunta \(currentQuestionIndex + 1) de \(questions.count)"
            )
            .accessibilityValue(
                question.question
            )
            .accessibilitySortPriority(80)
    }

    // MARK: - Alternativas

    private func rightSideOptions(
        question: QuestionsModel
    ) -> some View {

        VStack(spacing: 12) {

            ForEach(
                question.options.indices,
                id: \.self
            ) { index in

                Button {

                    checkAnswer(
                        option:
                            question.options[index],
                        index: index
                    )

                } label: {

                    Text(
                        question.options[index]
                    )
                    .font(
                        .custom(
                            "Fredoka-SemiBold",
                            size: 17
                        )
                    )
                    .foregroundColor(.black)
                    .multilineTextAlignment(
                        .leading
                    )
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .padding(
                        .horizontal,
                        12
                    )
                    .padding(
                        .vertical,
                        10
                    )
                    .background(
                        getButtonColor(
                            for: index
                        )
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 15
                        )
                    )

                    // Texto não vira outro
                    // elemento separado.

                    .accessibilityHidden(true)
                }
                .buttonStyle(.plain)

                // Não deixa responder duas vezes,
                // mas mantém o botão na árvore acessível.

                .allowsHitTesting(
                    !questionIsAnswered
                )

                // Elemento REAL da alternativa.

                .accessibilityElement(
                    children: .ignore
                )
                .accessibilityLabel(
                    "Alternativa \(index + 1)"
                )
                .accessibilityValue(
                    accessibilityValueForOption(
                        question: question,
                        index: index
                    )
                )
                .accessibilityHint(
                    questionIsAnswered
                        ? ""
                        : "Toque duas vezes para escolher esta alternativa"
                )
                .accessibilitySortPriority(
                    Double(70 - index)
                )
            }
        }
        .frame(
            maxWidth: .infinity
        )
        .accessibilityElement(
            children: .contain
        )
    }

    // MARK: - Fechar

    private var closeButton: some View {

        Button {

            closeQuiz()

        } label: {

            Image(
                systemName: "xmark"
            )
            .font(
                .system(
                    size: 20,
                    weight: .bold
                )
            )
            .foregroundColor(.white)
            .frame(
                width: 44,
                height: 44
            )
            .background(
                Color(
                    red: 0.89,
                    green: 0.31,
                    blue: 0.27
                )
            )
            .clipShape(Circle())
            .shadow(
                radius: 3,
                x: 0,
                y: 2
            )
            .accessibilityHidden(true)
        }
        .buttonStyle(.plain)
        .offset(
            x: 12,
            y: -12
        )
        .accessibilityElement(
            children: .ignore
        )
        .accessibilityLabel(
            "Fechar Quiz"
        )
        .accessibilityHint(
            "Fecha o Quiz e volta para as informações do seu país"
        )

        // Menor prioridade:
        // deve ficar depois das alternativas.

        .accessibilitySortPriority(1)
    }

    // MARK: - Fechar Quiz

    private func closeQuiz() {

        if !quizFinished {
            addPointInpilar()
        }

        isPresent = false
    }

    // MARK: - Total de pontos

    private var totalPoints: Int {

        let savedPoints: Int

        switch pilar {

        case .economia:

            savedPoints =
                gameManager
                    .yourCountry
                    .economia

        case .militarismo:

            savedPoints =
                gameManager
                    .yourCountry
                    .militarismo

        case .tecnologia:

            savedPoints =
                gameManager
                    .yourCountry
                    .tecnologia
        }

        return min(
            savedPoints + points,
            10
        )
    }

    // MARK: - Cor da alternativa

    private func getButtonColor(
        for index: Int
    ) -> Color {

        if index == correctOption &&
            correctOption == selectedOption {

            return .green

        } else if index == selectedOption {

            return .red
        }

        return Color(
            red: 0.85,
            green: 0.85,
            blue: 0.85
        )
    }

    // MARK: - Valor acessível

    private func accessibilityValueForOption(
        question: QuestionsModel,
        index: Int
    ) -> String {

        let option =
            question.options[index]

        guard questionIsAnswered else {
            return option
        }

        guard selectedOption == index else {
            return option
        }

        if option == question.answer {

            return
                "\(option). Resposta correta"
        }

        return
            "\(option). Resposta incorreta"
    }

    // MARK: - Configurar Quiz

    private func setupQuiz() {

        let allQuestions:
            [QuestionsModel] =
            Bundle.main.decode(
                file: "Questions.json"
            )

        self.questions =
            allQuestions
                .filter { question in

                    question.pilar ==
                        pilar.rawValue
                }
                .shuffled()

        if self.questions.isEmpty {
            quizFinished = true
        }
    }

    // MARK: - Conferir resposta

    func checkAnswer(
        option: String,
        index: Int
    ) {

        guard !questionIsAnswered else {
            return
        }

        guard let question =
                currentQuestion
        else {
            return
        }

        correctOption =
            question.options
                .firstIndex(
                    of: question.answer
                )

        let acertou =
            option == question.answer

        if acertou {
            points += 1
        }

        selectedOption = index
        questionIsAnswered = true

        // MARK: - Feedback VoiceOver

        if voiceOverEnabled {

            let mensagem: String

            if acertou {

                mensagem =
                    "Você acertou."

            } else {

                mensagem =
                    "Você errou. A resposta correta é \(question.answer)."
            }

            DispatchQueue.main.asyncAfter(
                deadline: .now() + 0.2
            ) {

                UIAccessibility.post(
                    notification: .announcement,
                    argument: mensagem
                )
            }
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 3.5
        ) {

            nextQuestion()
        }
    }

    // MARK: - Próxima pergunta

    func nextQuestion() {

        if totalPoints >= 10 {

            addPointInpilar()

            if voiceOverEnabled {

                UIAccessibility.post(
                    notification: .announcement,
                    argument:
                        "Você alcançou 10 pontos de \(pilar.rawValue)."
                )
            }

            DispatchQueue.main.asyncAfter(
                deadline: .now() + 1.5
            ) {

                isPresent = false
            }

            return
        }

        if currentQuestionIndex + 1 <
            questions.count {

            currentQuestionIndex += 1
            correctOption = nil
            questionIsAnswered = false
            selectedOption = nil

        } else {

            quizFinished = true

            addPointInpilar()

            if voiceOverEnabled {

                DispatchQueue.main.asyncAfter(
                    deadline: .now() + 0.2
                ) {

                    UIAccessibility.post(
                        notification: .announcement,
                        argument:
                            "Quiz concluído. Você ganhou \(points) pontos de \(pilar.rawValue)."
                    )
                }
            }

            DispatchQueue.main.asyncAfter(
                deadline: .now() + 2.5
            ) {

                isPresent = false
            }
        }
    }

    // MARK: - Adicionar pontos

    func addPointInpilar() {

        switch pilar {

        case .economia:

            gameManager
                .yourCountry
                .economia =
                min(
                    gameManager
                        .yourCountry
                        .economia + points,
                    10
                )

        case .militarismo:

            gameManager
                .yourCountry
                .militarismo =
                min(
                    gameManager
                        .yourCountry
                        .militarismo + points,
                    10
                )

        case .tecnologia:

            gameManager
                .yourCountry
                .tecnologia =
                min(
                    gameManager
                        .yourCountry
                        .tecnologia + points,
                    10
                )
        }
    }
}

// MARK: - Preview

#Preview {

    Quiz(
        pilar: .economia,
        isPresent: .constant(true)
    )
    .environment(
        GameManager()
    )
}
