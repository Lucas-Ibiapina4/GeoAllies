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
    
    
    // MARK: - Conselheiro
    
    @State private var showingCounsil = false
    
    
    // MARK: - Pode se aliar?
    
    private var canAlly: Bool {
        
        gameManager.yourCountry.economia >= 7
    }
    
    
    // MARK: - Já é aliado?
    
    private var agnoliaAliada: Bool {
        
        gameManager.aliados.contains {
            $0.id == gameManager.agnolia.id
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
                        
                        if !showingCounsil {
                            isPresent = false
                        }
                    }
                
                
                // MARK: - Popup do país
                
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
                    
                    
                    closeButton
                }
                .padding(.horizontal, 65)
                .padding(.vertical, 30)
                .offset(y: 15)
                .allowsHitTesting(!showingCounsil)
                
                
                // MARK: - Conselheiro
                
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
        
        VStack(spacing: 7) {
            
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
            
            
            // MARK: - Imagem muda depois da aliança
            
            if agnoliaAliada {
                
                Image("AgnoliaGreen")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: 210,
                        height: 170
                    )
                
            } else {
                
                Image("AgnoliaImage")
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
            
            
            // MARK: - Conselheiro + requisito
            
            HStack(
                alignment: .bottom,
                spacing: 12
            ) {
                
                counselorButton
                
                
                Text(
                    "Você precisa de 7 pontos de Economia para se aliar com esse país"
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
                .padding(.vertical, 6)
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
            
            ProgressBar(
                name: "Economia",
                icon: "dollarsign.circle.fill",
                value: gameManager.agnolia.economia,
                maximumValue: 10,
                type: .economia,
                showImproveButton: false
            ) {
                
            }
            
            
            ProgressBar(
                name: "Militarismo",
                icon: "shield.fill",
                value: gameManager.agnolia.militarismo,
                maximumValue: 10,
                type: .militarismo,
                showImproveButton: false
            ) {
                
            }
            
            
            ProgressBar(
                name: "Tecnologia",
                icon: "desktopcomputer",
                value: gameManager.agnolia.tecnologia,
                maximumValue: 10,
                type: .tecnologia,
                showImproveButton: false
            ) {
                
            }
            
            
            Spacer()
            
            
            // MARK: - Estado da aliança
            
            if agnoliaAliada {
                
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
                    .padding(.bottom, 15)
                
            } else {
                
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
    
    
    // MARK: - Fechar
    
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
    
    private func allyWithAgnolia() {
        
        guard canAlly else {
            return
        }
        
        
        gameManager.aliar(
            gameManager.agnolia
        )
        
        
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
