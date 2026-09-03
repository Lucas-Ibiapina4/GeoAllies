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
    
    // Controla o popup do conselheiro
    @State private var showingCounsil = false
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                // MARK: - Fundo principal do popup
                
                RoundedRectangle(cornerRadius: 35)
                    .fill(
                        Color(
                            red: 245 / 255,
                            green: 245 / 255,
                            blue: 245 / 255
                        )
                    )
                // MARK: - Conteúdo principal
                HStack(spacing: 30) {
                    // Lado esquerdo
                    countrySection
                    // Lado direito
                    statisticSection
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 18)
                
                // MARK: - Botão fechar
                Button {
                    isPresent = false
                } label: {
                    
                    RoundedRectangle(cornerRadius: 35)
                        .fill(
                            Color(
                                red: 245 / 255,
                                green: 245 / 255,
                                blue: 245 / 255
                            )
                        )
                    
                    
                    HStack(spacing: 30) {
                        
                        countrySection
                        
                        statisticSection
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 18)
                    
                    
                    // Fechar popup
                    Button {
                        
                        isPresent = false
                        
                    } label: {
                        
                        Image(systemName: "xmark")
                            .font(.system(size: 22, weight: .heavy))
                            .foregroundStyle(.white)
                            .frame(width: 50, height: 50)
                            .background(.red)
                            .clipShape(Circle())
                    }
                    .offset(x: 12, y: -12)
                }
                .frame(
                    width: geometry.size.width * 0.84,
                    height: geometry.size.height * 0.68
                )
                
                
                // MARK: - Popup do Conselheiro
                
                if showingCounsil {
                    
                    CounsilView(
                        isPresent: $showingCounsil
                    )
                    .zIndex(10)
                }
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
        }
    }
    // MARK: - Lado esquerdo
    private var countrySection: some View {
        VStack(spacing: 10) {
            // MARK: Nome do país
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
            // MARK: Imagem do país
            Image("PaísSeu")
                .resizable()
                .scaledToFit()
                .frame(
                    width: 210,
                    height: 180
                )
            // MARK: Sombra abaixo do país
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
                
                // Conselheiro
                Button {
                    print("Abrir Conselheiro")
                } label: {
                    Image(systemName: "person.fill")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 52, height: 52)
                        .background(.orange)
                        .clipShape(Circle())
                }
                Spacer()
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
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
                print("Abrir quiz de Economia")
            }
            // MARK: Militarismo
            ProgressBar(
                name: "Militarismo",
                icon: "shield.fill",
                value: gameManager.yourCountry.militarismo,
                maximumValue: 10,
                type: .militarismo
            ) {
                print("Abrir quiz de Militarismo")
            }
            // MARK: Tecnologia
            
            ProgressBar(
                name: "Tecnologia",
                icon: "desktopcomputer",
                value: gameManager.yourCountry.tecnologia,
                maximumValue: 10,
                type: .tecnologia
            ) {
                print("Abrir quiz de Tecnologia")
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
            RoundedRectangle(cornerRadius: 22)
        )
    }
    
    
    // MARK: - Funções dos quizzes
    private func openEconomyQuiz() {
        
        print("Abrir quiz de Economia")
    }
    private func openMilitarismQuiz() {
        
        print("Abrir quiz de Militarismo")
    }
    private func openTechnologyQuiz() {
        
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
            // Fundo azul do jogo
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
