//
//  PlayerCountryView.swift
//  GeoAllies
//
//  Created by Agnes Pontes Ristau on 02/09/26.
//

import SwiftUI

struct PlayerCountryView: View {
    
    @Environment(GameManager.self) private var gameManager
    
    @Binding var isPresent: Bool
    
    // MARK: - Controla o popup do conselheiro
    @State private var showingCounsil = false
    
    // MARK: - Controla qual quiz será aberto
    @State private var pilarQuizselected: QuizPilar?
    
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                
                // MARK: - Fundo escurecido
                
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        
                        // Só fecha a tela do país
                        // quando o conselheiro NÃO estiver aberto
                        if !showingCounsil {
                            isPresent = false
                        }
                    }
                
                
                // MARK: - Popup do país
                
                ZStack(alignment: .topTrailing) {
                    
                    // MARK: Fundo do popup
                    
                    RoundedRectangle(cornerRadius: 35)
                        .fill(
                            Color(
                                red: 245 / 255,
                                green: 245 / 255,
                                blue: 245 / 255
                            )
                        )
                    
                    
                    // MARK: Conteúdo
                    
                    HStack(spacing: 30) {
                        
                        countrySection
                        
                        statisticSection
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 18)
                    
                    
                    // MARK: Botão fechar
                    
                    Button {
                        
                        isPresent = false
                        
                    } label: {
                        
                        Image(systemName: "xmark")
                            .font(
                                .system(
                                    size: 22,
                                    weight: .heavy
                                )
                            )
                            .foregroundStyle(.white)
                            .frame(
                                width: 50,
                                height: 50
                            )
                            .background(.red)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    }
                    .buttonStyle(.plain)
                    .offset(
                        x: 15,
                        y: -15
                    )
                }
                .padding(.horizontal, 65)
                .padding(.vertical, 25)
                
                // Enquanto o conselheiro estiver aberto,
                // o popup do país não recebe toque.
                .allowsHitTesting(!showingCounsil)
                
                
                // MARK: - Popup do Conselheiro
                
                if showingCounsil {
                    
                    CounsilView(
                        isPresent: $showingCounsil
                    )
                    .zIndex(1000)
                }
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
        }
        
        // MARK: - Quiz
        
        .fullScreenCover(
            item: $pilarQuizselected
        ) { pilar in
            
            Quiz(
                pilar: pilar
            )
        }
    }
    
    
    // MARK: - Lado esquerdo
    
    private var countrySection: some View {
        
        VStack(spacing: 10) {
            
            // MARK: Nome
            
            Text("SEU PAÍS")
                .font(
                    .system(
                        size: 22,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 6)
                .background(
                    Color(
                        red: 140 / 255,
                        green: 180 / 255,
                        blue: 115 / 255
                    )
                )
                .clipShape(Capsule())
            
            
            // MARK: Imagem
            
            Image("PaísSeu")
                .resizable()
                .scaledToFit()
                .frame(
                    width: 210,
                    height: 180
                )
            
            
            // MARK: Sombra
            
            Ellipse()
                .fill(
                    Color.gray.opacity(0.20)
                )
                .frame(
                    width: 170,
                    height: 22
                )
            
            
            // MARK: Conselheiro
            
            HStack {
                
                counselorButton
                
                Spacer()
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
    }
    
    
    // MARK: - Botão do Conselheiro
    
    private var counselorButton: some View {
        
        Button {
            
            // Abre o popup do conselheiro
            showingCounsil = true
            
        } label: {
            
            Image(systemName: "person.fill")
                .font(
                    .system(
                        size: 22,
                        weight: .bold
                    )
                )
                .foregroundStyle(.white)
                .frame(
                    width: 52,
                    height: 52
                )
                .background(.orange)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .contentShape(Circle())
    }
    
    
    // MARK: - Lado direito
    
    private var statisticSection: some View {
        
        VStack(spacing: 12) {
            
            // MARK: Economia
            
            ProgressBar(
                name: "Economia",
                icon: "dollarsign.circle.fill",
                value: gameManager.yourCountry.economia,
                maximumValue: 10,
                type: .economia
            ) {
                
                openEconomyQuiz()
            }
            
            
            // MARK: Militarismo
            
            ProgressBar(
                name: "Militarismo",
                icon: "shield.fill",
                value: gameManager.yourCountry.militarismo,
                maximumValue: 10,
                type: .militarismo
            ) {
                
                openMilitarismQuiz()
            }
            
            
            // MARK: Tecnologia
            
            ProgressBar(
                name: "Tecnologia",
                icon: "desktopcomputer",
                value: gameManager.yourCountry.tecnologia,
                maximumValue: 10,
                type: .tecnologia
            ) {
                
                openTechnologyQuiz()
            }
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 16)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .background(.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 22
            )
        )
    }
    
    
    // MARK: - Funções dos quizzes
    
    private func openEconomyQuiz() {
        
        pilarQuizselected = .economia
        
        print("Abrir quiz de Economia")
    }
    
    
    private func openMilitarismQuiz() {
        
        pilarQuizselected = .militarismo
        
        print("Abrir quiz de Militarismo")
    }
    
    
    private func openTechnologyQuiz() {
        
        pilarQuizselected = .tecnologia
        
        print("Abrir quiz de Tecnologia")
    }
}


// MARK: - Preview

#Preview {
    
    PlayerCountryPreview()
}


// MARK: - Preview auxiliar

private struct PlayerCountryPreview: View {
    
    @State private var gameManager = GameManager()
    
    
    var body: some View {
        
        ZStack {
            
            Color(
                red: 30 / 255,
                green: 42 / 255,
                blue: 130 / 255
            )
            .ignoresSafeArea()
            
            
            PlayerCountryView(
                isPresent: .constant(true)
            )
        }
        .environment(gameManager)
    }
}
