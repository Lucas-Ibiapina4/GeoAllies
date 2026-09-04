//
//  AgnoliaView.swift
//  GeoAllies
//
//  Created by Lucas Ibiapina on 31/08/26.
//

import SwiftUI

struct AgnoliaView: View {
    
    @Environment(GameManager.self) private var gameManager
    
    @Binding var isPresent: Bool
    
    // MARK: - Controla o popup do Conselheiro
    @State private var showingCounsil = false
    
    
    // MARK: - Verifica se pode fazer aliança
    
    private var canAlly: Bool {
        gameManager.yourCountry.militarismo >= 4
    }
    
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                
                // MARK: - Fundo escurecido
                
                Color.black
                    .opacity(0.30)
                    .ignoresSafeArea()
                    .onTapGesture {
                        
                        // Só fecha Agnólia se
                        // o Conselheiro não estiver aberto
                        
                        if !showingCounsil {
                            isPresent = false
                        }
                    }
                
                
                // MARK: - Popup da Agnólia
                
                ZStack(alignment: .topTrailing) {
                    
                    RoundedRectangle(cornerRadius: 35)
                        .fill(
                            Color(.systemGray6)
                        )
                    
                    
                    HStack(spacing: 30) {
                        
                        countrySection
                        
                        statisticSection
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 18)
                    
                    
                    // Botão fechar Agnólia
                    
                    closeButton
                }
                .frame(
                    width: geometry.size.width * 0.84,
                    height: geometry.size.height * 0.68
                )
                
                // Não permite clicar na Agnólia
                // enquanto o Conselheiro estiver aberto
                .allowsHitTesting(!showingCounsil)
                
                
                // MARK: - Popup do Conselheiro
                
                if showingCounsil {
                    
                    ZStack {
                        
                        // Escurece novamente a tela
                        
                        Color.black
                            .opacity(0.35)
                            .ignoresSafeArea()
                        
                        
                        // Conselheiro
                        
                        CounsilView(
                            isPresent: $showingCounsil
                        )
                    }
                    .zIndex(1000)
                }
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
        }
    }
    
    
    // MARK: - País
    
    private var countrySection: some View {
        
        VStack(spacing: 8) {
            
            // MARK: Nome
            
            Text("AGNÓLIA")
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
                    Color.green.opacity(0.65)
                )
                .clipShape(Capsule())
            
            
            // MARK: Imagem
            
            Image("País1")
                .resizable()
                .scaledToFit()
                .frame(
                    width: 210,
                    height: 170
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
            
            
            // MARK: Parte inferior
            
            HStack(
                alignment: .bottom,
                spacing: 12
            ) {
                
                // Botão do Conselheiro
                
                counselorButton
                
                
                // Texto de requisito
                
                Text(
                    "Você precisa de 4 pontos de Militarismo para se aliar com esse país"
                )
                .font(
                    .system(
                        size: 14,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .multilineTextAlignment(.center)
                .foregroundStyle(.black)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(.white)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 16
                    )
                )
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
    }
    
    
    // MARK: - Estatísticas
    
    private var statisticSection: some View {
        
        VStack(spacing: 12) {
            
            // MARK: Economia da Agnólia
            
            ProgressBar(
                name: "Economia",
                icon: "dollarsign.circle.fill",
                value: gameManager.agnolia.economia,
                maximumValue: 10,
                type: .economia,
                showImproveButton: false
            ) {
                
                // Sem ação
            }
            
            
            // MARK: Militarismo da Agnólia
            
            ProgressBar(
                name: "Militarismo",
                icon: "shield.fill",
                value: gameManager.agnolia.militarismo,
                maximumValue: 10,
                type: .militarismo,
                showImproveButton: false
            ) {
                
                // Sem ação
            }
            
            
            // MARK: Tecnologia da Agnólia
            
            ProgressBar(
                name: "Tecnologia",
                icon: "desktopcomputer",
                value: gameManager.agnolia.tecnologia,
                maximumValue: 10,
                type: .tecnologia,
                showImproveButton: false
            ) {
                
                // Sem ação
            }
            
            
            Spacer()
            
            
            // MARK: - Botão Aliar-se
            
            Button {
                
                allyWithAgnolia()
                
            } label: {
                
                Text("Aliar-se")
                    .font(
                        .system(
                            size: 22,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background(
                        canAlly
                        ? Color.green
                        : Color.gray
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 20
                        )
                    )
            }
            .buttonStyle(.plain)
            .disabled(!canAlly)
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
    
    
    // MARK: - Conselheiro
    
    private var counselorButton: some View {
        
        Button {
            
            // Abre o popup do Conselheiro
            
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
                .shadow(radius: 2)
        }
        .buttonStyle(.plain)
        .contentShape(Circle())
    }
    
    
    // MARK: - Fechar Agnólia
    
    private var closeButton: some View {
        
        Button {
            
            // Fecha somente Agnólia
            
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
        .contentShape(Circle())
        .offset(
            x: 12,
            y: -12
        )
    }
    
    
    // MARK: - Fazer aliança
    
    private func allyWithAgnolia() {
        
        // Verifica se o jogador
        // possui Militarismo suficiente
        
        guard canAlly else {
            return
        }
        
        
        // Adiciona Agnólia aos aliados
        
        gameManager.aliados.append(
            gameManager.agnolia
        )
        
        
        print("Aliança realizada com Agnólia")
        
        
        // Fecha o popup da Agnólia
        
        isPresent = false
    }
}


// MARK: - Preview

#Preview {
    
    AgnoliaPreview()
}


private struct AgnoliaPreview: View {
    
    @State private var gameManager = GameManager()
    
    
    var body: some View {
        
        ZStack {
            
            Color(
                red: 30 / 255,
                green: 42 / 255,
                blue: 130 / 255
            )
            .ignoresSafeArea()
            
            
            AgnoliaView(
                isPresent: .constant(true)
            )
        }
        .environment(gameManager)
    }
}
