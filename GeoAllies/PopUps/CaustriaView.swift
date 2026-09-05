//
//  CaustriaView.swift
//  GeoAllies
//
//  Created by Agnes Pontes Ristau on 02/09/26.
//

import SwiftUI

struct CaustriaView: View {
    
    @Environment(GameManager.self) private var gameManager
    
    @Binding var isPresent: Bool
    
    // MARK: - Controla o popup do Conselheiro
    @State private var showingCounsil = false
    
    
    // MARK: - Verifica se pode fazer aliança
    
    private var canAlly: Bool {
        gameManager.yourCountry.militarismo >= 8
    }
    
    private var caustriaAliada: Bool {
        gameManager.aliados.contains {
            $0.id == gameManager.cuastria.id
        }
    }
    
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                
                // MARK: - Fundo escurecido da tela
                
                Color.black
                    .opacity(0.30)
                    .ignoresSafeArea()
                    .onTapGesture {
                        
                        if !showingCounsil {
                            isPresent = false
                        }
                    }
                
                
                // MARK: - Popup da Cáustria
                
                ZStack(alignment: .topTrailing) {
                    
                    RoundedRectangle(cornerRadius: 35)
                        .fill(Color(.systemGray6))
                    
                    
                    HStack(spacing: 30) {
                        
                        countrySection
                        
                        statisticSection
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 18)
                    
                    
                    closeButton
                }
                .frame(
                    width: geometry.size.width * 0.84,
                    height: geometry.size.height * 0.68
                )
                .allowsHitTesting(!showingCounsil)
                
                
                // MARK: - POPUP DO CONSELHEIRO
                
                if showingCounsil {
                    
                    ZStack {
                        
                        // Escurece a Cáustria atrás
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
    
    
    // MARK: - Lado esquerdo
    
    private var countrySection: some View {
        
        VStack(spacing: 8) {
            
            Text("CÁUSTRIA")
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
            
            
            if caustriaAliada {
                Image("CaustriaGreen")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: 210,
                        height: 170
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
            } else {
                Image("CaustriaImage")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: 210,
                        height: 170
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
            }
            
            
            HStack(
                alignment: .bottom,
                spacing: 12
            ) {
                
                // Botão do Conselheiro
                counselorButton
                
                
                Text(
                    "Você precisa de 8 pontos de Militarismo para se aliar com esse país"
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
    
    
    // MARK: - Lado direito
    
    private var statisticSection: some View {
        
        VStack(spacing: 12) {
            
            ProgressBar(
                name: "Economia",
                icon: "dollarsign.circle.fill",
                value: gameManager.cuastria.economia,
                maximumValue: 10,
                type: .economia,
                showImproveButton: false
            ) {
                
            }
            
            
            ProgressBar(
                name: "Militarismo",
                icon: "shield.fill",
                value: gameManager.cuastria.militarismo,
                maximumValue: 10,
                type: .militarismo,
                showImproveButton: false
            ) {
                
            }
            
            
            ProgressBar(
                name: "Tecnologia",
                icon: "desktopcomputer",
                value: gameManager.cuastria.tecnologia,
                maximumValue: 10,
                type: .tecnologia,
                showImproveButton: false
            ) {
                
            }
            
            
            Spacer()
            
            
            // MARK: - Botão Aliar-se
            
            Button {
                
                allyWithCaustria()
                
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
        
        Button {
            
            // Abre o Conselheiro em formato de popup
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
    
    
    // MARK: - Botão Fechar Cáustria
    
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
    
    
    // MARK: - Função de aliança
    
    private func allyWithCaustria() {
        
        guard canAlly else {
            return
        }
        
        
        gameManager.aliados.append(
            gameManager.cuastria
        )
        
        
        print("Aliança realizada com Cáustria")
        
        
        isPresent = false
    }
}
