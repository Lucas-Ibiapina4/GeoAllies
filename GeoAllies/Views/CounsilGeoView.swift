//
//  CounsilView.swift
//  GeoAllies
//

import SwiftUI


// MARK: - Modelo das mensagens do chat

struct ChatMessage: Identifiable {
    
    let id = UUID()
    
    let text: String
    
    let isUser: Bool
}


// MARK: - Conselheiro

struct CounsilView: View {
    
    // Controla se o popup está aberto
    @Binding var isPresent: Bool
    
    
    // Foundation Model
    @State private var viewModel = FoundationModelServices()
    
    
    // Histórico do chat
    @State private var messages: [ChatMessage] = [
        
        ChatMessage(
            text: "Olá! Sou o seu conselheiro Cleiton e estou aqui para lhe orientar em cada passo dessa jornada!",
            isUser: false
        )
    ]
    
    
    // Controla o teclado
    @FocusState private var keyboardIsActive: Bool
    
    
    var body: some View {
        
        GeometryReader { geometry in
            
            let popupWidth = geometry.size.width * 0.90
            let popupHeight = geometry.size.height * 0.78
            
            
            ZStack {
                
                // MARK: - Fundo escurecido
                
                Color.black
                    .opacity(0.30)
                    .ignoresSafeArea()
                    .onTapGesture {
                        keyboardIsActive = false
                    }
                
                
                // MARK: - Popup
                
                ZStack {
                    
                    // Fundo principal
                    RoundedRectangle(
                        cornerRadius: 40
                    )
                    .fill(
                        Color(
                            red: 245 / 255,
                            green: 245 / 255,
                            blue: 245 / 255
                        )
                    )
                    
                    
                    HStack(spacing: 25) {
                        
                        // MARK: Cleiton
                        
                        counselorSection
                            .frame(
                                width: popupWidth * 0.38
                            )
                        
                        
                        // MARK: Chat
                        
                        chatSection
                            .frame(
                                width: popupWidth * 0.52
                            )
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 24)
                }
                .frame(
                    width: popupWidth,
                    height: popupHeight
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 40
                    )
                )
                .overlay(
                    alignment: .topTrailing
                ) {
                    
                    closeButton
                        .offset(
                            x: 16,
                            y: -16
                        )
                }
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
        }
    }
    
    
    // MARK: - Cleiton
    
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
            
            
            Spacer(minLength: 0)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
    }
    
    
    // MARK: - Área do chat
    
    private var chatSection: some View {
        
        VStack(spacing: 0) {
            
            // Parte que faz scroll
            messageScrollView
            
            
            // Parte fixa
            inputSection
                .padding(.horizontal, 20)
                .padding(.bottom, 18)
                .padding(.top, 12)
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
    
    
    // MARK: - Scroll das mensagens
    
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
                            
                            
                            Text("Cleiton está pensando...")
                                .font(
                                    .system(
                                        size: 14,
                                        weight: .medium,
                                        design: .rounded
                                    )
                                )
                                .foregroundStyle(.black)
                            
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 22)
            }
            .scrollIndicators(.visible)
            
            
            // Sempre que entrar uma mensagem nova,
            // desce automaticamente
            .onChange(of: messages.count) {
                
                guard let lastMessage = messages.last else {
                    return
                }
                
                
                withAnimation {
                    
                    proxy.scrollTo(
                        lastMessage.id,
                        anchor: .bottom
                    )
                }
            }
        }
    }
    
    
    // MARK: - Bolha da mensagem
    
    private func messageBubble(
        _ message: ChatMessage
    ) -> some View {
        
        HStack {
            
            // Mensagem do Cleiton fica à esquerda
            if !message.isUser {
                
                messageContent(message)
                
                
                Spacer(minLength: 60)
            }
            
            
            // Mensagem do jogador fica à direita
            else {
                
                Spacer(minLength: 60)
                
                
                messageContent(message)
            }
        }
    }
    
    
    // MARK: - Visual da mensagem
    
    private func messageContent(
        _ message: ChatMessage
    ) -> some View {
        
        Text(message.text)
            .font(
                .system(
                    size: 16,
                    weight: .bold,
                    design: .rounded
                )
            )
            .foregroundStyle(.black)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
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
                }
            }
    }
    
    
    // MARK: - Campo de texto + botão
    
    private var inputSection: some View {
        
        HStack(spacing: 14) {
            
            // MARK: Campo de texto
            
            TextField(
                "Digite sua dúvida...",
                text: $viewModel.answerUser,
                axis: .vertical
            )
            .font(
                .system(
                    size: 16,
                    weight: .bold,
                    design: .rounded
                )
            )
            .foregroundStyle(.black)
            .lineLimit(1...3)
            .padding(.horizontal, 22)
            .padding(.vertical, 14)
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
            }
            .focused($keyboardIsActive)
            
            
            // MARK: Botão enviar
            
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
                            color: .black.opacity(0.30),
                            radius: 0,
                            x: 0,
                            y: 5
                        )
                    
                    
                    if viewModel.isLoading {
                        
                        ProgressView()
                            .tint(.white)
                        
                    } else {
                        
                        Image(
                            systemName: "paperplane.fill"
                        )
                        .font(
                            .system(
                                size: 27,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.white)
                    }
                }
            }
            .buttonStyle(.plain)
            .disabled(
                viewModel.isLoading ||
                viewModel.answerUser
                    .trimmingCharacters(
                        in: .whitespacesAndNewlines
                    )
                    .isEmpty
            )
        }
    }
    
    
    // MARK: - Enviar mensagem
    
    private func sendMessage() {
        
        let question = viewModel.answerUser
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
        
        
        guard !question.isEmpty else {
            return
        }
        
        
        // 1. Adiciona a pergunta no chat
        messages.append(
            ChatMessage(
                text: question,
                isUser: true
            )
        )
        
        
        // 2. Limpa o campo
        viewModel.answerUser = ""
        
        
        // 3. Fecha o teclado
        keyboardIsActive = false
        
        
        // 4. Chama o Foundation Model
        Task {
            
            let response = await viewModel.loadModel(
                question: question
            )
            
            
            // 5. Adiciona a resposta no chat
            if let response {
                
                messages.append(
                    ChatMessage(
                        text: response,
                        isUser: false
                    )
                )
            }
            
            
            // Se acontecer algum erro
            else if !viewModel.messageError.isEmpty {
                
                messages.append(
                    ChatMessage(
                        text: viewModel.messageError,
                        isUser: false
                    )
                )
            }
        }
    }
    
    
    // MARK: - Botão fechar
    
    private var closeButton: some View {
        
        Button {
            
            isPresent = false
            
        } label: {
            
            Image(systemName: "xmark")
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
                    color: .black.opacity(0.30),
                    radius: 0,
                    x: 0,
                    y: 5
                )
        }
        .buttonStyle(.plain)
    }
}


// MARK: - Preview

#Preview {
    
    CounsilPreview()
}


private struct CounsilPreview: View {
    
    @State private var showingCounsil = true
    
    
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
                    isPresent: $showingCounsil
                )
            }
        }
    }
}
