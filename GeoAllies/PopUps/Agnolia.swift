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
    @State private var showingCounsil = false
    
    private var canAlly: Bool {
        gameManager.yourCountry.economia >= 7
    }
    
    private var agnoliaAliada: Bool {
        gameManager.aliados.contains {
            $0.id == gameManager.agnolia.id
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black
                    .opacity(0.30)
                    .ignoresSafeArea()
                    .onTapGesture {
                        if !showingCounsil {
                            isPresent = false
                        }
                    }
                
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
                .padding(.horizontal, 65)
                .padding(.vertical, 30)
                .offset(y: 15)
                .allowsHitTesting(!showingCounsil)
                
                if showingCounsil {
                    ZStack {
                        Color.black
                            .opacity(0.35)
                            .ignoresSafeArea()
                        
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
                .background(Color.green.opacity(0.65))
                .clipShape(Capsule())
                .padding(10)
            
            if agnoliaAliada {
                Image("AgnoliaGreen")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: 210,
                        height: 170
                    )
                
                Ellipse()
                    .fill(Color.gray.opacity(0.20))
                    .frame(
                        width: 170,
                        height: 22
                    )
            } else {
                Image("AgnoliaImage")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: 210,
                        height: 170
                    )
                
                Ellipse()
                    .fill(Color.gray.opacity(0.20))
                    .frame(
                        width: 170,
                        height: 22
                    )
            }
            
            HStack(
                alignment: .bottom,
                spacing: 12
            ) {
                counselorButton
                
                Text("Você precisa de 7 pontos de Econômia para se aliar com esse país")
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
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
    }
    
    private var statisticSection: some View {
        VStack(spacing: -10) {
            ProgressBar(
                name: "Economia",
                icon: "dollarsign.circle.fill",
                value: gameManager.agnolia.economia,
                maximumValue: 10,
                type: .economia,
                showImproveButton: false
            ) {}
            
            ProgressBar(
                name: "Militarismo",
                icon: "shield.fill",
                value: gameManager.agnolia.militarismo,
                maximumValue: 10,
                type: .militarismo,
                showImproveButton: false
            ) {}
            
            ProgressBar(
                name: "Tecnologia",
                icon: "desktopcomputer",
                value: gameManager.agnolia.tecnologia,
                maximumValue: 10,
                type: .tecnologia,
                showImproveButton: false
            ) {}
            
            Spacer()
            
            if agnoliaAliada {
                Text("Você já é aliado desse país")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
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
    
    private func allyWithAgnolia() {
        guard canAlly else { return }
        
        gameManager.aliados.append(gameManager.agnolia)
        gameManager.yourCountry.aliouAgnolia = true
        
        isPresent = false
    }
}

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
