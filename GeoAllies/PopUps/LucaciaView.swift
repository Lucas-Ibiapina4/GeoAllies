//
//  LucaciaView.swift
//  GeoAllies
//
//  Created by Agnes Pontes Ristau on 02/09/26.
//

import SwiftUI


struct LucaciaView: View {
    
    @Environment(GameManager.self) private var gameManager
    
    @Binding var isPresent: Bool
    
    @State private var showingCounsil = false
    
    
    // MARK: - Pode se aliar?
    
    private var canAlly: Bool {
        
        gameManager.yourCountry.tecnologia >= 10
    }
    
    
    // MARK: - Verifica se Lucácia já é aliada
    
    private var lucaciaAliada: Bool {
        
        gameManager.aliados.contains {
            $0.id == gameManager.lucacia.id
        }
    }
    
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                
                // MARK: - Fundo escurecido
                
                Color.black
                    .opacity(0.30)
                    .ignoresSafeArea()
                    .onTapGesture {
                        
                        // Só fecha Lucácia se
                        // o Conselheiro não estiver aberto
                        
                        if !showingCounsil {
                            isPresent = false
                        }
                    }
                
                
                // MARK: - Popup da Lucácia
                
                ZStack(alignment: .topTrailing) {
                    
                    // Fundo
                    
                    RoundedRectangle(cornerRadius: 35)
                        .fill(
                            Color(
                                red: 245 / 255,
                                green: 245 / 255,
                                blue: 245 / 255
                            )
                        )
                    
                    
                    // Conteúdo
                    
                    HStack(spacing: 30) {
                        
                        countrySection
                        
                        statisticSection
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 18)
                    
                    
                    // Botão fechar
                    
                    closeButton
                }
                .padding(.horizontal, 65)
                .padding(.vertical, 30)
                .offset(y: 15)
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
    }
    
    
    // MARK: - Lado esquerdo
    
    private var countrySection: some View {
        
        VStack(spacing: 8) {
            
            // MARK: Nome do país
            
            Text("LUCÁCIA")
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
            
            
            // MARK: - Imagem
            
            if lucaciaAliada {
                
                Image("País3")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: 210,
                        height: 170
                    )
                
            } else {
                
                Image("LucaciaImage")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: 210,
                        height: 170
                    )
            }
            
            
            // MARK: - Sombra
            
            Ellipse()
                .fill(
                    Color.gray.opacity(0.20)
                )
                .frame(
                    width: 170,
                    height: 22
                )
            
            
            // MARK: - Parte inferior
            
            HStack(
                alignment: .bottom,
                spacing: 12
            ) {
                
                // Conselheiro
                
                counselorButton
                
                
                // Requisito
                
                Text(
                    "Você precisa de 10 pontos de Tecnologia para se aliar com esse país"
                )
                .font(
                    .system(
                        size: 12,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .multilineTextAlignment(.center)
                .foregroundStyle(.black)
                .padding(.horizontal, 12)
                .padding(.vertical, 1)
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
    
    
    // MARK: - Lado direito
    
    private var statisticSection: some View {
        
        VStack(spacing: -10) {
            
            // MARK: - Economia
            
            ProgressBar(
                name: "Economia",
                icon: "dollarsign.circle.fill",
                value: gameManager.lucacia.economia,
                maximumValue: 10,
                type: .economia,
                showImproveButton: false
            ) {
                // Sem ação
            }
            
            
            // MARK: - Militarismo
            
            ProgressBar(
                name: "Militarismo",
                icon: "shield.fill",
                value: gameManager.lucacia.militarismo,
                maximumValue: 10,
                type: .militarismo,
                showImproveButton: false
            ) {
                // Sem ação
            }
            
            
            // MARK: - Tecnologia
            
            ProgressBar(
                name: "Tecnologia",
                icon: "desktopcomputer",
                value: gameManager.lucacia.tecnologia,
                maximumValue: 10,
                type: .tecnologia,
                showImproveButton: false
            ) {
                // Sem ação
            }
            
            
            Spacer()
            
            
            // MARK: - Estado da aliança
            
            if lucaciaAliada {
                
                Text("Você já é aliado desse país")
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(
                        Color(
                            red: 0.4,
                            green: 0.4,
                            blue: 0.4
                        )
                    )
                    .padding(.bottom, 10)
                
            } else {
                
                Button {
                    
                    allyWithLucacia()
                    
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
    
    
    // MARK: - Botão Conselheiro
    
    private var counselorButton: some View {
        
        Button {
            
            showingCounsil = true
            
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
                
                
                Image(
                    systemName: "person.wave.2.fill"
                )
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .foregroundStyle(.white)
            }
        }
        .buttonStyle(.plain)
    }
    
    
    // MARK: - Botão Fechar
    
    private var closeButton: some View {
        
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
        .contentShape(Circle())
        .offset(
            x: 12,
            y: -12
        )
    }
    
    
    // MARK: - Fazer aliança
    
    private func allyWithLucacia() {
        
        // Só permite aliança se
        // tiver Tecnologia suficiente
        
        guard canAlly else {
            return
        }
        
        
        // O GameManager adiciona Lucácia
        // e impede duplicatas
        
        gameManager.aliar(
            gameManager.lucacia
        )
        
        
        print("Aliança realizada com Lucácia")
        
        
        // Fecha o popup
        
        isPresent = false
    }
}


// MARK: - Preview

#Preview {
    
    LucaciaPreview()
}


private struct LucaciaPreview: View {
    
    @State private var gameManager = GameManager()
    
    
    var body: some View {
        
        ZStack {
            
            Color.blueSea
                .ignoresSafeArea()
            
            
            LucaciaView(
                isPresent: .constant(true)
            )
        }
        .environment(gameManager)
    }
}
