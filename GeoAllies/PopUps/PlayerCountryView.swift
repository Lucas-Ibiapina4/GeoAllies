//
//  PlayerCountryView.swift
//  GeoAllies
//
//  Created by Agnes Pontes Ristau on 02/09/26.
//

import SwiftUI

struct PlayerCountryView: View {
    @Environment(GameManager.self) private var gameManager
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    @Binding var isPresent: Bool
    
    @State private var showingCounsil = false
    @State private var pilarQuizselected: QuizPilar?
    @State private var isQuizOpen = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    // MARK: - Fundo escurecido
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            isPresent = false
                        }
                    
                    // MARK: - Popup Principal
                    ZStack(alignment: .topTrailing) {
                        
                        // Fundo
                        RoundedRectangle(cornerRadius: 35)
                            .fill(Color(red: 245 / 255, green: 245 / 255, blue: 245 / 255))
                        
                        ScrollView {
                            if dynamicTypeSize.isAccessibilitySize {
                                VStack(spacing: 30) {
                                    countrySection
                                    statisticSection
                                }
                                .padding(.horizontal, 24)
                                .padding(.vertical, 32)
                            } else {
                                HStack(spacing: 30) {
                                    countrySection
                                    statisticSection
                                }
                                .padding(.horizontal, 32)
                                .padding(.vertical, 18)
                            }
                        }
                        .scrollIndicators(.hidden)
                        
                        // Botão Fechar
                        Button {
                            isPresent = false
                        } label: {
                            Image(systemName: "xmark")
                                .font(.custom("Fredoka-Bold", size: 23))
                                .foregroundStyle(.white)
                                .frame(width: 50, height: 50)
                                .background(.red)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                        }
                        .offset(x: 12, y: -12)
                    }
                    .padding(8)
                    .frame(maxHeight: geometry.size.height * 0.95) // Altura máxima para permitir rolagem
                    
                    // MARK: - Popups Sobrepostos
                    
                    if isQuizOpen, let pilar = pilarQuizselected {
                        Quiz(pilar: pilar, isPresent: $isQuizOpen)
                            .zIndex(1000)
                    }
                    
                    if showingCounsil {
                        CounsilView(isPresent: $showingCounsil)
                            .zIndex(1000)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Lado esquerdo (ou Cima)
    private var countrySection: some View {
        VStack(spacing: 10) {
            Text("SEU PAÍS")
                .font(.custom("Fredoka", size: 23))
                .bold()
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
            
            Image("PaísSeu")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: dynamicTypeSize.isAccessibilitySize ? 100 : 170)

            
            Ellipse()
                .fill(
                    Color.gray.opacity(0.20)
                )
                .frame(
                    width: 170,
                    height: 22
                )
            
            HStack {
                counselorButton
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Botão do Conselheiro
    private var counselorButton: some View {
        Button(action: {
            showingCounsil = true
        }) {
            ZStack {
                Circle()
                    .fill(Color(red: 241/255, green: 157/255, blue: 59/255))
                    .frame(width: 50, height: 50)
                    .shadow(radius: 3)
                
                HStack(spacing: 2) {
                    Image(systemName: "questionmark.bubble.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .foregroundColor(.white)
                }
            }
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Lado direito (ou Baixo)
    private var statisticSection: some View {
        VStack(spacing: 12) {
            ProgressBar(
                name: "Economia",
                icon: "dollarsign.circle.fill",
                value: gameManager.yourCountry.economia,
                maximumValue: 10,
                type: .economia
            ) {
                openEconomyQuiz()
            }
            .font(.caption2)
            
            ProgressBar(
                name: "Militarismo",
                icon: "shield.fill",
                value: gameManager.yourCountry.militarismo,
                maximumValue: 10,
                type: .militarismo
            ) {
                openMilitarismQuiz()
            }
            .font(.caption2)
            
            ProgressBar(
                name: "Tecnologia",
                icon: "desktopcomputer",
                value: gameManager.yourCountry.tecnologia,
                maximumValue: 10,
                type: .tecnologia
            ) {
                openTechnologyQuiz()
            }
            .font(.caption2)
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity) // Removido maxHeight: .infinity
        .background(.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 22)
        )
    }
    
    private func openEconomyQuiz() {
        pilarQuizselected = .economia
        isQuizOpen = true
    }
    
    private func openMilitarismQuiz() {
        pilarQuizselected = .militarismo
        isQuizOpen = true
    }
    
    private func openTechnologyQuiz() {
        pilarQuizselected = .tecnologia
        isQuizOpen = true
    }
}

// MARK: - Preview
#Preview {
    PlayerCountryPreview()
}

private struct PlayerCountryPreview: View {
    @State private var gameManager = GameManager()
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()
            PlayerCountryView(
                isPresent: .constant(true)
            )
        }
        .environment(gameManager)
    }
}
