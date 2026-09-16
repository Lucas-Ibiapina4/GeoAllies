//
//  CounsilView.swift
//  GeoAllies
//

import SwiftUI
import UIKit

struct ChatMessage: Identifiable {

    let id = UUID()
    let text: String
    let isUser: Bool
}

struct CounsilView: View {

    @Binding var isPresent: Bool

    @State private var viewModel =
        FoundationModelGeoServices()

    @State private var messages: [ChatMessage] = [

        ChatMessage(
            text:
                "Olá! Sou o seu conselheiro Cleiton e estou aqui para lhe orientar em cada passo dessa jornada!",
            isUser: false
        )
    ]

    @FocusState
    private var keyboardIsActive: Bool

    // MARK: - Acessibilidade

    @Environment(\.accessibilityVoiceOverEnabled)
    private var voiceOverEnabled

    @Environment(\.accessibilityReduceMotion)
    private var reduceMotion

    var body: some View {

        GeometryReader { geometry in

            let popupWidth =
                geometry.size.width * 0.82

            let normalHeight =
                geometry.size.height * 0.80

            let activeHeight =
                geometry.size.height * 0.50

            let popupHeight =
                keyboardIsActive
                ? activeHeight
                : normalHeight

            let yOffset =
                keyboardIsActive
                ? -(geometry.size.height * 0.25)
                : 0.0

            ZStack {

                // MARK: - Fundo

                Color.black
                    .opacity(0.30)
                    .ignoresSafeArea()
                    .onTapGesture {
                        keyboardIsActive = false
                    }
                    .accessibilityHidden(true)

                // MARK: - Popup

                ZStack {

                    RoundedRectangle(
                        cornerRadius: 35
                    )
                    .fill(
                        Color(
                            red: 245 / 255,
                            green: 245 / 255,
                            blue: 245 / 255
                        )
                    )
                    .accessibilityHidden(true)

                    HStack(spacing: 25) {

                        counselorSection
                            .frame(
                                width:
                                    popupWidth * 0.38
                            )

                        chatSection
                            .frame(
                                width:
                                    popupWidth * 0.52
                            )
                    }
                    .padding(
                        .horizontal,
                        30
                    )
                    .padding(
                        .vertical,
                        24
                    )
                }
                .frame(
                    width: popupWidth,
                    height: popupHeight
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 35
                    )
                )
                .overlay(
                    alignment: .topTrailing
                ) {

                    closeButton
                        .offset(
                            x: 10,
                            y: -10
                        )
                }
                .offset(y: yOffset)
                .animation(
                    reduceMotion
                        ? nil
                        : .easeOut(
                            duration: 0.25
                        ),
                    value: keyboardIsActive
                )
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
        }
        .ignoresSafeArea(edges: .all)
        .ignoresSafeArea(.keyboard)
        .accessibilityAddTraits(.isModal)

        // MARK: - Abertura

        .onAppear {

            announceOpeningScreen()
        }
    }

    // MARK: - Conselheiro

    private var counselorSection: some View {

        VStack {

            Spacer()

            Image("counsil")
                .resizable()
                .scaledToFit()
                .frame(
                    maxWidth: 340,
                    maxHeight: 430
                )
                .accessibilityHidden(true)

            Spacer(minLength: 0)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .accessibilityHidden(true)
    }

    // MARK: - Chat

    private var chatSection: some View {

        VStack(spacing: 0) {

            messageScrollView
                .font(
                    .custom(
                        "Fredoka-Bold",
                        size: 17
                    )
                )

            inputSection
                .padding(
                    .horizontal,
                    20
                )
                .padding(
                    .bottom,
                    18
                )
                .padding(
                    .top,
                    12
                )
        }
        .background(
            Color(
                red: 218 / 255,
                green: 218 / 255,
                blue: 218 / 255
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 28
            )
        )
    }

    // MARK: - Mensagens

    private var messageScrollView: some View {

        ScrollViewReader { proxy in

            ScrollView {

                LazyVStack(spacing: 16) {

                    ForEach(messages) { message in

                        messageBubble(message)
                            .id(message.id)
                    }

                    if viewModel.isLoading {

                        HStack(spacing: 10) {

                            ProgressView()
                                .accessibilityHidden(true)

                            Text(
                                "Cleiton está pensando..."
                            )
                            .font(
                                .custom(
                                    "Fredoka-Bold",
                                    size: 17
                                )
                            )
                            .foregroundStyle(.black)

                            Spacer()
                        }
                        .padding(
                            .horizontal,
                            20
                        )
                        .accessibilityElement(
                            children: .ignore
                        )
                        .accessibilityLabel(
                            "Cleiton está pensando na resposta"
                        )
                    }
                }
                .padding(
                    .horizontal,
                    20
                )
                .padding(
                    .vertical,
                    22
                )
            }

            // Não mostra o indicador visual
            // de rolagem.
            .scrollIndicators(.hidden)

            /*
             A ScrollView continua funcionando
             normalmente, mas as mensagens são
             os elementos importantes para o
             VoiceOver.
             */

            .onChange(
                of: messages.count
            ) {

                guard let lastMessage =
                        messages.last
                else {
                    return
                }

                if reduceMotion {

                    proxy.scrollTo(
                        lastMessage.id,
                        anchor: .bottom
                    )

                } else {

                    withAnimation {

                        proxy.scrollTo(
                            lastMessage.id,
                            anchor: .bottom
                        )
                    }
                }
            }

            .onChange(
                of: keyboardIsActive
            ) {

                guard let lastMessage =
                        messages.last
                else {
                    return
                }

                if reduceMotion {

                    proxy.scrollTo(
                        lastMessage.id,
                        anchor: .bottom
                    )

                } else {

                    withAnimation {

                        proxy.scrollTo(
                            lastMessage.id,
                            anchor: .bottom
                        )
                    }
                }
            }
        }
    }

    // MARK: - Balão

    private func messageBubble(
        _ message: ChatMessage
    ) -> some View {

        HStack {

            if !message.isUser {

                messageContent(message)

                Spacer(
                    minLength: 60
                )

            } else {

                Spacer(
                    minLength: 60
                )

                messageContent(message)
            }
        }
    }

    // MARK: - Conteúdo da mensagem

    private func messageContent(
        _ message: ChatMessage
    ) -> some View {

        Text(message.text)
            .font(
                .custom(
                    "Fredoka-SemiBold",
                    size: 16
                )
            )
            .foregroundStyle(.black)
            .multilineTextAlignment(
                .leading
            )
            .padding(
                .horizontal,
                20
            )
            .padding(
                .vertical,
                14
            )
            .background(
                message.isUser
                    ? Color(
                        red: 231 / 255,
                        green: 244 / 255,
                        blue: 223 / 255
                    )
                    : Color.white
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 22
                )
            )
            .overlay {

                if message.isUser {

                    RoundedRectangle(
                        cornerRadius: 22
                    )
                    .stroke(
                        Color(
                            red: 140 / 255,
                            green: 180 / 255,
                            blue: 115 / 255
                        ),
                        lineWidth: 1.5
                    )
                    .accessibilityHidden(true)
                }
            }

            // Cada mensagem vira um único
            // elemento do VoiceOver.

            .accessibilityElement(
                children: .ignore
            )
            .accessibilityLabel(
                message.isUser
                    ? "Sua mensagem"
                    : "Mensagem do conselheiro Cleiton"
            )
            .accessibilityValue(
                message.text
            )
    }

    // MARK: - Campo de entrada

    private var inputSection: some View {

        HStack(spacing: 14) {

            TextField(
                "Digite sua dúvida...",
                text:
                    $viewModel.answerUser,
                axis: .vertical
            )
            .font(
                .custom(
                    "Fredoka-SemiBold",
                    size: 16
                )
            )
            .foregroundStyle(.black)
            .lineLimit(1...3)
            .padding(
                .horizontal,
                22
            )
            .padding(
                .vertical,
                14
            )
            .background(
                Color(
                    red: 231 / 255,
                    green: 244 / 255,
                    blue: 223 / 255
                )
            )
            .clipShape(Capsule())
            .overlay {

                Capsule()
                    .stroke(
                        Color(
                            red: 140 / 255,
                            green: 180 / 255,
                            blue: 115 / 255
                        ),
                        lineWidth: 1.5
                    )
                    .accessibilityHidden(true)
            }
            .focused(
                $keyboardIsActive
            )
            .accessibilityLabel(
                "Digite sua dúvida"
            )
            .accessibilityHint(
                "Digite uma pergunta para o conselheiro Cleiton"
            )

            // MARK: - Enviar

            Button {

                sendMessage()

            } label: {

                ZStack {

                    Circle()
                        .fill(.orange)
                        .frame(
                            width: 62,
                            height: 62
                        )
                        .shadow(
                            color:
                                .black.opacity(0.30),
                            radius: 0,
                            x: 0,
                            y: 5
                        )
                        .accessibilityHidden(true)

                    if viewModel.isLoading {

                        ProgressView()
                            .tint(.white)
                            .accessibilityHidden(true)

                    } else {

                        Image(
                            systemName:
                                "paperplane.fill"
                        )
                        .font(
                            .system(
                                size: 27,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.white)
                        .accessibilityHidden(true)
                    }
                }
            }
            .buttonStyle(.plain)
            .disabled(
                viewModel.isLoading ||
                viewModel.answerUser
                    .trimmingCharacters(
                        in:
                            .whitespacesAndNewlines
                    )
                    .isEmpty
            )
            .accessibilityElement(
                children: .ignore
            )
            .accessibilityLabel(
                viewModel.isLoading
                    ? "Gerando resposta"
                    : "Enviar pergunta"
            )
            .accessibilityHint(
                viewModel.isLoading
                    ? "Aguarde a resposta do conselheiro"
                    : "Envia sua pergunta para o conselheiro Cleiton"
            )
        }
    }

    // MARK: - Enviar mensagem

    private func sendMessage() {

        let question =
            viewModel.answerUser
                .trimmingCharacters(
                    in:
                        .whitespacesAndNewlines
                )

        guard !question.isEmpty else {
            return
        }

        messages.append(
            ChatMessage(
                text: question,
                isUser: true
            )
        )

        viewModel.answerUser = ""
        keyboardIsActive = false

        // MARK: - Aviso de envio

        if voiceOverEnabled {

            UIAccessibility.post(
                notification: .announcement,
                argument:
                    "Pergunta enviada. Cleiton está pensando."
            )
        }

        Task {

            let response =
                await viewModel.loadModel(
                    question: question
                )

            if let response {

                messages.append(
                    ChatMessage(
                        text: response,
                        isUser: false
                    )
                )

                announceResponse(
                    response
                )

            } else if !viewModel
                .messageError.isEmpty {

                let errorMessage =
                    viewModel.messageError

                messages.append(
                    ChatMessage(
                        text: errorMessage,
                        isUser: false
                    )
                )

                announceError(
                    errorMessage
                )
            }
        }
    }

    // MARK: - Fechar

    private var closeButton: some View {

        Button {

            isPresent = false

        } label: {

            Image(
                systemName: "xmark"
            )
            .font(
                .system(
                    size: 30,
                    weight: .heavy
                )
            )
            .foregroundStyle(.white)
            .frame(
                width: 64,
                height: 64
            )
            .background(.red)
            .clipShape(Circle())
            .shadow(
                color:
                    .black.opacity(0.30),
                radius: 0,
                x: 0,
                y: 5
            )
            .accessibilityHidden(true)
        }
        .buttonStyle(.plain)
        .accessibilityElement(
            children: .ignore
        )
        .accessibilityLabel(
            "Fechar conselheiro"
        )
        .accessibilityHint(
            "Fecha o conselheiro e volta para a tela anterior"
        )
    }

    // MARK: - Anúncio inicial

    private func announceOpeningScreen() {

        guard voiceOverEnabled else {
            return
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.5
        ) {

            UIAccessibility.post(
                notification:
                    .announcement,
                argument:
                    """
                    Conselheiro Cleiton.
                    Olá! Sou o seu conselheiro Cleiton e estou aqui para lhe orientar em cada passo dessa jornada.
                    Digite sua dúvida para conversar comigo.
                    """
            )
        }
    }

    // MARK: - Anunciar resposta

    private func announceResponse(
        _ response: String
    ) {

        guard voiceOverEnabled else {
            return
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.3
        ) {

            UIAccessibility.post(
                notification:
                    .announcement,
                argument:
                    "Resposta do conselheiro Cleiton. \(response)"
            )
        }
    }

    // MARK: - Anunciar erro

    private func announceError(
        _ error: String
    ) {

        guard voiceOverEnabled else {
            return
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.3
        ) {

            UIAccessibility.post(
                notification:
                    .announcement,
                argument:
                    "Não foi possível gerar a resposta. \(error)"
            )
        }
    }
}

// MARK: - Preview

#Preview {
    CounsilPreview()
}

private struct CounsilPreview: View {

    @State
    private var showingCounsil = true

    var body: some View {

        ZStack {

            Color(
                red: 30 / 255,
                green: 42 / 255,
                blue: 130 / 255
            )
            .ignoresSafeArea()

            if showingCounsil {

                CounsilView(
                    isPresent:
                        $showingCounsil
                )
            }
        }
    }
}
