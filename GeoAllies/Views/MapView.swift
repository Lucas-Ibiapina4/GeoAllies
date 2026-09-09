//
//  MapView.swift
//  GeoAllies
//
//  Created by Agnes Pontes Ristau on 31/08/26.
//

import SwiftUI
import SwiftData


struct EstiloIlha3D: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        
        ZStack {
            
            configuration.label
                .overlay(
                    Color(
                        red: 0.6,
                        green: 0.35,
                        blue: 0.1
                    )
                )
                .mask(configuration.label)
                .offset(
                    x: 4,
                    y: 7
                )
            
            
            configuration.label
                .offset(
                    x: configuration.isPressed ? 4 : 0,
                    y: configuration.isPressed ? 7 : 0
                )
        }
        .animation(
            .spring(
                response: 0.3,
                dampingFraction: 0.6
            ),
            value: configuration.isPressed
        )
    }
}


struct MapView: View {
    
    @Environment(\.modelContext) private var context
    
    @Query private var savedCountries: [Country]
    
    @State private var gameManager = GameManager()
    
    
    // MARK: - Popups dos países
    
    @State private var isPresentedSeuPais = false
    
    @State private var isPresentedAgnolia = false
    
    @State private var isPresentedCaustria = false
    
    @State private var isPresentedLucasia = false
    
    
    // MARK: - Conselheiro
    
    @State private var showingCounsil = false
    
    
    // MARK: - Popup final
    
    @State private var showingFinalGame = false
    
    
    // MARK: - Verifica se algum popup está aberto
    
    private var hasCountryPopupOpen: Bool {
        
        isPresentedSeuPais ||
        isPresentedAgnolia ||
        isPresentedCaustria ||
        isPresentedLucasia ||
        showingCounsil ||
        showingFinalGame
    }
    
    
    // MARK: - Verifica alianças
    
    private var lucaciaAliada: Bool {
        
        gameManager.aliados.contains {
            $0.id == gameManager.lucacia.id
        }
    }
    
    
    private var agnoliaAliada: Bool {
        
        gameManager.aliados.contains {
            $0.id == gameManager.agnolia.id
        }
    }
    
    
    private var caustriaAliada: Bool {
        
        gameManager.aliados.contains {
            $0.id == gameManager.cuastria.id
        }
    }
    
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                // MARK: - Fundo
                
                Group {
                    
                    Color.blueSea
                    
                    
                    Image("fundo")
                        .resizable()
                }
                .ignoresSafeArea()
                
                
                // MARK: - Agnólia
                
                Button {
                    
                    isPresentedAgnolia = true
                    
                } label: {
                    
                    Image(
                        agnoliaAliada
                        ? "AgnoliaGreen"
                        : "AgnoliaImage"
                    )
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220)
                    .contentShape(Circle())
                }
                .buttonStyle(
                    EstiloIlha3D()
                )
                .offset(
                    x: -180,
                    y: -80
                )
                
                
                // MARK: - Seu país
                
                Button {
                    
                    isPresentedSeuPais = true
                    
                } label: {
                    
                    Image("PaísSeu")
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 190)
                        .contentShape(Circle())
                }
                .buttonStyle(
                    EstiloIlha3D()
                )
                .offset(
                    x: -180,
                    y: 100
                )
                
                
                // MARK: - Cáustria
                
                Button {
                    
                    isPresentedCaustria = true
                    
                } label: {
                    
                    Image(
                        caustriaAliada
                        ? "CaustriaGreen"
                        : "CaustriaImage"
                    )
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 210)
                    .contentShape(Circle())
                }
                .buttonStyle(
                    EstiloIlha3D()
                )
                .offset(
                    x: 20,
                    y: 30
                )
                
                
                // MARK: - Lucácia
                
                Button {
                    
                    isPresentedLucasia = true
                    
                } label: {
                    
                    Image(
                        lucaciaAliada
                        ? "País3"
                        : "LucaciaImage"
                    )
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: lucaciaAliada
                        ? 210
                        : 190
                    )
                    .contentShape(Capsule())
                }
                .buttonStyle(
                    EstiloIlha3D()
                )
                .offset(
                    x: 230,
                    y: 0
                )
                
                
                // MARK: - Botão Conselheiro
                
                VStack {
                    
                    HStack {
                        
                        Spacer()
                        
                        
                        counselorButton
                            .padding(.top, 32)
                            .padding(.trailing, 48)
                    }
                    
                    
                    Spacer()
                }
                .allowsHitTesting(
                    !hasCountryPopupOpen
                )
                
                
                // MARK: - Popup Seu País
                
                if isPresentedSeuPais {
                    
                    PlayerCountryView(
                        isPresent: $isPresentedSeuPais
                    )
                    .zIndex(100)
                }
                
                
                // MARK: - Popup Agnólia
                
                if isPresentedAgnolia {
                    
                    AgnoliaView(
                        isPresent: $isPresentedAgnolia
                    )
                    .zIndex(100)
                }
                
                
                // MARK: - Popup Cáustria
                
                if isPresentedCaustria {
                    
                    CaustriaView(
                        isPresent: $isPresentedCaustria
                    )
                    .zIndex(100)
                }
                
                
                // MARK: - Popup Lucácia
                
                if isPresentedLucasia {
                    
                    LucaciaView(
                        isPresent: $isPresentedLucasia
                    )
                    .zIndex(100)
                }
                
                
                // MARK: - Popup Conselheiro
                
                if showingCounsil {
                    
                    CounsilView(
                        isPresent: $showingCounsil
                    )
                    .zIndex(1000)
                }
                
                
                // MARK: - POPUP FINAL
                
                if showingFinalGame {
                    
                    FinalGameView(
                        isPresent: $showingFinalGame
                    )
                    .zIndex(2000)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(
            .hidden,
            for: .navigationBar
        )
        .environment(gameManager)
        
        
        // MARK: - Carregar dados
        
        .onAppear {
            
            if let savedData = savedCountries.first {
                
                gameManager.yourCountry = savedData
                
                gameManager.aliados.removeAll()
                
                
                if savedData.aliouAgnolia {
                    
                    gameManager.aliados.append(
                        gameManager.agnolia
                    )
                }
                
                
                if savedData.aliouCaustria {
                    
                    gameManager.aliados.append(
                        gameManager.cuastria
                    )
                }
                
                
                if savedData.aliouLucacia {
                    
                    gameManager.aliados.append(
                        gameManager.lucacia
                    )
                }
                
            } else {
                
                let newData = Country(
                    economia: 0,
                    militarismo: 0,
                    tecnologia: 0
                )
                
                context.insert(newData)
                
                gameManager.yourCountry = newData
            }
        }
        
        
        // MARK: - Verifica se conseguiu os 3 aliados
        
        .onChange(
            of: gameManager.aliados.count
        ) {
            
            if gameManager.aliados.count == 3 {
                
                // Fecha o popup do último país
                
                isPresentedSeuPais = false
                isPresentedAgnolia = false
                isPresentedCaustria = false
                isPresentedLucasia = false
                
                
                // Fecha o conselheiro
                
                showingCounsil = false
                
                
                // Abre o popup final
                
                showingFinalGame = true
            }
        }
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
    }
}


// MARK: - Preview

#Preview {
    
    MapView()
}
