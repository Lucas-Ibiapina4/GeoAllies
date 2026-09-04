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
    
    
    // MARK: - Controla o popup do Conselheiro
    
    @State private var showingCounsil = false
    
    // Verifica se o usuário pode se aliar à Lucácia
    private var canAlly: Bool {
        gameManager.yourCountry.militarismo >= 9
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // MARK: - Fundo escurecido da Lucácia
                Color.black
                    .opacity(0.30)
                    .ignoresSafeArea()
                    .onTapGesture {
                        
                        // Só fecha a Lucácia se o
                        // Conselheiro NÃO estiver aberto
                        if !showingCounsil {
                            
                            isPresent = false
                        }
                    }
                
                
                // MARK: - Popup da Lucácia
                ZStack(alignment: .topTrailing) {
                    // Fundo do popup
                    
                    RoundedRectangle(cornerRadius: 35)
                        .fill(
                            Color(
                                red: 245 / 255,
                                green: 245 / 255,
                                blue: 245 / 255
                            )
                        )
                    // Conteúdo principal
                    
                    HStack(spacing: 30) {
                        countrySection
                        statisticSection
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 18)
                    // Botão fechar
                    closeButton
                }
                .frame(
                    width: geometry.size.width * 0.84,
                    height: geometry.size.height * 0.68
                )
                .offset(y: 15)
                // Quando o Conselheiro estiver aberto,
                // não permite clicar no popup da Lucácia
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
                .padding(.horizontal, 20)
                .padding(.vertical, 6)
                .background(
                    Color(
                        red: 140 / 255,
                        green: 180 / 255,
                        blue: 115 / 255
                    )
                )
                .clipShape(Capsule())
            
            // MARK: Imagem da Lucácia
            Image("País3")
                .resizable()
                .scaledToFit()
                .frame(
                    width: 200,
                    height: 150
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
            
            // MARK: Parte inferior
            
            HStack(
                alignment: .bottom,
                spacing: 12
            ) {
                // Botão do Conselheiro
                counselorButton
                // Texto do requisito
                
                Text(
                    "Você precisa de 9 pontos de Militarismo para se aliar com esse país"
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
    
    
    // MARK: - Lado direito
    
    private var statisticSection: some View {
        
        VStack(spacing: -5) {
            
            // MARK: Economia
            
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
            
            
            // MARK: Militarismo
            
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
            
            
            // MARK: Tecnologia
            
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
            
            
            // MARK: - Botão Aliar-se
            
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
    
    
    // MARK: - Botão Fechar Lucácia
    
    private var closeButton: some View {
        
        Button {
            
            // Fecha a Lucácia
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
    
    
    // MARK: - Função de aliança
    
    private func allyWithLucacia() {
        
        // Só permite aliança se tiver
        // Militarismo suficiente
        
        guard canAlly else {
            return
        }
        
        
        // Adiciona Lucácia aos aliados
        
        gameManager.aliados.append(
            gameManager.lucacia
        )
        
        
        print("Aliança realizada com Lucácia")
        
        
        // Fecha o popup da Lucácia
        
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
            
            Color(
                red: 30 / 255,
                green: 42 / 255,
                blue: 130 / 255
            )
            .ignoresSafeArea()
            
            
            LucaciaView(
                isPresent: .constant(true)
            )
        }
        .environment(gameManager)
    }
}
