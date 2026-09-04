//
//  AgnoliaView.swift
//  GeoAllies
//
//  Created by Lucas Ibiapina on 31/08/26.
//

import SwiftUI
import SwiftData

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
                .padding(.horizontal, 65)
                .padding(.vertical, 30)
                
                .offset(y: 15)
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
        
        VStack(spacing: 7) {
            
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
                .padding(10)
            // MARK: Imagem
            
            Image("País1")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 130)
            
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
                        size: 13,
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
        
        VStack(spacing: -5) {
            
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
                    .padding(.vertical, 9)
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
        Button(action: {
            showingCounsil = true
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
            Color.blueSea
            .ignoresSafeArea()
            
            AgnoliaView(
                isPresent: .constant(true)
            )
        }
        .environment(gameManager)
    }
}
