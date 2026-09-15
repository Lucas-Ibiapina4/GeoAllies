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

    @Environment(GameManager.self) private var gameManager

    @Environment(\.accessibilityVoiceOverEnabled)
    private var voiceOverEnabled

    @Binding var isPresent: Bool

    @State private var questions: [QuestionsModel] = []
    @State private var correctOption: Int? = nil
    @State private var currentQuestionIndex = 0
    @State private var quizFinished = false
    @State private var points: Int = 0
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

    var currentQuestion: QuestionsModel? {

        guard currentQuestionIndex < questions.count else {
            return nil
        }

        return questions[currentQuestionIndex]
    }

    // MARK: - Body

    var body: some View {

        ZStack {

            // MARK: - Conteúdo do Quiz

            ZStack {

                Color.black
                    .opacity(0.4)
                    .ignoresSafeArea()
                    .accessibilityHidden(true)

                ZStack {

                    RoundedRectangle(cornerRadius: 30)
                        .fill(
                            Color(
                                red: 0.95,
                                green: 0.95,
                                blue: 0.95
                            )
                        )
                        .accessibilityHidden(true)

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
                        .accessibilityLabel(
                            "Você já respondeu todas as perguntas disponíveis"
                        )
                    }
                }
                .frame(
                    width: 700,
                    height: 350
                )

                // MARK: - Fechar

                .overlay(
                    alignment: .topTrailing
                ) {
                    closeButton
                }

                // MARK: - Conselheiro

                .overlay(
                    alignment: .bottomLeading
                ) {
                    counselorButton
                        .offset(
                            x: 600,
                            y: -280
                        )
                }
            }
            .accessibilityHidden(showingGeoCounsil)
            .allowsHitTesting(!showingGeoCounsil)

            // MARK: - Popup Conselheiro

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
        .accessibilityAddTraits(.isModal)
        .onAppear {

            // Apenas configura o Quiz.
            // Não existe anúncio automático aqui.

            setupQuiz()
        }
    }

    // MARK: - Tela final

    private var endQuizScreen: some View {

        VStack(spacing: 20) {

            Text("Quiz Concluído!")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.black)
                .accessibilityAddTraits(
                    .isHeader
                )

            Text(
                "Você respondeu todas as perguntas e ganhou \(points) pontos de \(pilar.rawValue)."
            )
            .font(.title3)
            .foregroundColor(.gray)
        }
        .padding()
        .accessibilityElement(
            children: .combine
        )
        .accessibilitySortPriority(100)
    }

    // MARK: - Tela da pergunta

    private func questionScreen(
        question: QuestionsModel
    ) -> some View {

        HStack(spacing: 20) {

            leftSideQuestion(
                question: question
            )

            rightSideOptions(
                question: question
            )
        }
        .padding(30)
    }

    // MARK: - Lado esquerdo

    private func leftSideQuestion(
        question: QuestionsModel
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 15
        ) {

            // 1º - Título

            Text("GeoQuiz")
                .font(.headline)
                .bold()
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
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
                .accessibilityLabel(
                    "GeoQuiz"
                )
                .accessibilityAddTraits(
                    .isHeader
                )
                .accessibilitySortPriority(100)

            // 3º - Pergunta

            Text(question.question)
                .font(.body)
                .bold()
                .foregroundColor(.black)
                .multilineTextAlignment(
                    .leading
                )
                .padding(20)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
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
        .frame(width: 320)
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
                        option: question.options[index],
                        index: index
                    )

                } label: {

                    Text(
                        question.options[index]
                    )
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.black)
                    .multilineTextAlignment(
                        .leading
                    )
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .padding(.horizontal, 5)
                    .padding(.vertical, 6)
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
                    .accessibilityHidden(true)
                }

                // Não usamos .disabled aqui.
                // Isso evita que a mudança de estado
                // interfira no anúncio do VoiceOver.

                .allowsHitTesting(
                    !questionIsAnswered
                )

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

                // 4º - Alternativas
                // 70, 69, 68, 67...

                .accessibilitySortPriority(
                    Double(70 - index)
                )
            }
        }
        .padding(.top, 45)
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
                        width: 50,
                        height: 50
                    )
                    .shadow(radius: 3)
                    .accessibilityHidden(true)

                Image(
                    systemName: "person.wave.2.fill"
                )
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .foregroundColor(.white)
                .accessibilityHidden(true)
            }
        }
        .accessibilityElement(
            children: .ignore
        )
        .accessibilityLabel(
            "Conselheiro"
        )
        .accessibilityHint(
            "Toque duas vezes para pedir ajuda ao conselheiro"
        )

        // 2º - Conselheiro

        .accessibilitySortPriority(90)
    }

    // MARK: - Botão fechar

    private var closeButton: some View {

        Button {

            if !quizFinished {
                addPointInpilar()
            }

            isPresent = false

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
        .offset(
            x: 15,
            y: -15
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

        // 5º - Fechar

        .accessibilitySortPriority(10)
    }

    // MARK: - Cor das alternativas

    private func getButtonColor(
        for index: Int
    ) -> Color {

        if index == correctOption &&
            correctOption == selectedOption {

            return Color.green

        } else if index == selectedOption {

            return Color.red
        }

        return Color(
            red: 0.85,
            green: 0.85,
            blue: 0.85
        )
    }

    // MARK: - Texto acessível das alternativas

    private func accessibilityValueForOption(
        question: QuestionsModel,
        index: Int
    ) -> String {

        let option =
            question.options[index]

        guard questionIsAnswered else {
            return option
        }

        if selectedOption != index {
            return option
        }

        if option == question.answer {

            return "\(option). Resposta correta"
        }

        return "\(option). Resposta incorreta"
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

        // Impede responder duas vezes

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

        selectedOption = index
        questionIsAnswered = true

        if acertou {

            points += 1
        }

        // MARK: - Feedback VoiceOver

        if voiceOverEnabled {

            let mensagem: String

            if acertou {

                mensagem =
                    "Você acertou."

            } else {

                mensagem =
                    """
                    Você errou.
                    A resposta correta é \(question.answer).
                    """
            }

            // Pequeno atraso para permitir que
            // o estado da interface seja atualizado.

            DispatchQueue.main.asyncAfter(
                deadline: .now() + 0.2
            ) {

                UIAccessibility.post(
                    notification: .announcement,
                    argument: mensagem
                )
            }
        }

        // Aguarda o VoiceOver falar
        // antes de trocar a pergunta.

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 3.5
        ) {

            nextQuestion()
        }
    }

    // MARK: - Próxima pergunta

    func nextQuestion() {

        if currentQuestionIndex + 1 <
            questions.count {

            currentQuestionIndex += 1

            correctOption = nil
            questionIsAnswered = false
            selectedOption = nil

            // Não existe anúncio automático aqui.
            // O usuário continua navegando
            // com o seletor do VoiceOver.

        } else {

            quizFinished = true

            addPointInpilar()

            // MARK: - Quiz concluído

            if voiceOverEnabled {

                DispatchQueue.main.asyncAfter(
                    deadline: .now() + 0.2
                ) {

                    UIAccessibility.post(
                        notification: .announcement,
                        argument:
                            """
                            Quiz concluído.
                            Você ganhou \(points) pontos de \(pilar.rawValue).
                            """
                    )
                }
            }

            DispatchQueue.main.asyncAfter(
                deadline: .now() + 2
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
                        .economia
                    + points,
                    10
                )

        case .militarismo:

            gameManager
                .yourCountry
                .militarismo =
                min(
                    gameManager
                        .yourCountry
                        .militarismo
                    + points,
                    10
                )

        case .tecnologia:

            gameManager
                .yourCountry
                .tecnologia =
                min(
                    gameManager
                        .yourCountry
                        .tecnologia
                    + points,
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
