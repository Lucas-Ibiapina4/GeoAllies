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
    
    @State private var showingCounsil = false
    
    
    private var canAlly: Bool {
        gameManager.yourCountry.militarismo >= 8
    }
    
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                
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
            
            
            Image("País2")
                .resizable()
                .scaledToFit()
                .frame(width: 210, height: 170)
            
            
            Ellipse()
                .fill(Color.gray.opacity(0.20))
                .frame(width: 170, height: 22)
            
            
            HStack(
                alignment: .bottom,
                spacing: 12
            ) {
                
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
                    RoundedRectangle(cornerRadius: 16)
                )
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
    }
    
    
    private var statisticSection: some View {
        
        VStack(spacing: 12) {
            
            ProgressBar(
                name: "Economia",
                icon: "dollarsign.circle.fill",
                value: gameManager.yourCountry.economia,
                maximumValue: 10,
                type: .economia
            ) {
                print("Abrir quiz de Economia")
            }
            
            
            ProgressBar(
                name: "Militarismo",
                icon: "shield.fill",
                value: gameManager.yourCountry.militarismo,
                maximumValue: 10,
                type: .militarismo
            ) {
                print("Abrir quiz de Militarismo")
            }
            
            
            ProgressBar(
                name: "Tecnologia",
                icon: "desktopcomputer",
                value: gameManager.yourCountry.tecnologia,
                maximumValue: 10,
                type: .tecnologia
            ) {
                print("Abrir quiz de Tecnologia")
            }
            
            
            Spacer()
            
            
            Button {
                
                if canAlly {
                    
                    gameManager.aliados.append(
                        gameManager.cuastria
                    )
                    
                    isPresent = false
                }
                
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
                        RoundedRectangle(cornerRadius: 20)
                    )
            }
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
            RoundedRectangle(cornerRadius: 22)
        )
    }
    
    
    private var counselorButton: some View {
        
        Button {
            
            showingCounsil = true
            
        } label: {
            
            Image(systemName: "person.fill")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 52, height: 52)
                .background(.orange)
                .clipShape(Circle())
        }
    }
    
    
    private var closeButton: some View {
        
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
}
