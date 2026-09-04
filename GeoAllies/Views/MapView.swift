//
//  MapView.swift
//  GeoAllies
//
//  Created by Agnes Pontes Ristau on 31/08/26.
//

import SwiftUI
import SwiftData


// MARK: - Estilo das ilhas

struct EstiloIlha3D: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            // Sombra da ilha
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
            // Ilha
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

// MARK: - Mapa

struct MapView: View {
    @Environment(\.modelContext) private var context
    @Query private var savedCountries: [Country]
    @State private var gameManager = GameManager()
    
    
    // MARK: - Popups dos países
    @State private var isPresentedSeuPais = false
    @State private var isPresentedAgnolia = false
    @State private var isPresentedCaustria = false
    @State private var isPresentedLucasia = false
    
    // MARK: - Popup do Conselheiro
    
    @State private var showingCounsil = false
    // Verifica se existe algum popup aberto
    private var hasCountryPopupOpen: Bool {
        isPresentedSeuPais ||
        isPresentedAgnolia ||
        isPresentedCaustria ||
        isPresentedLucasia ||
        showingCounsil
    }
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - Conteúdo do mapa
                ZStack {
                    
                    // MARK: Fundo
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
                        
                        Image("AgnoliaImage")
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
                    
                    
                    // MARK: - Seu País
                    
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
                    .buttonStyle(EstiloIlha3D())
                    .offset(x: -180, y: 100)
                    
                    Button(action: {
                        isPresentedCaustria = true
                        
                    }) {
                        
                        Image("CaustriaImage")
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
                        
                        Image("LucaciaImage")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 190)
                            .contentShape(Capsule())
                    }
                    .buttonStyle(
                        EstiloIlha3D()
                    )
                    .offset(
                        x: 230,
                        y: 0
                    )
                    
                    
                    // MARK: - Conselheiro do mapa
                    
                    VStack {
                        HStack {
                            Spacer()
                            counselorButton
                                .padding(.top, 32)
                                .padding(.trailing, 48)
                        }
                        Spacer()
                    }
                }
                .allowsHitTesting(!hasCountryPopupOpen)
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
            }
        }
        .navigationBarBackButtonHidden(true)
        .environment(gameManager)
        
        .onAppear {
            if let savedData = savedCountries.first {
                gameManager.yourCountry = savedData
            } else {
                let newData = Country(economia: 0, militarismo: 0, tecnologia: 0)
                context.insert(newData)
                gameManager.yourCountry = newData
            }
        }
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
}



// MARK: - Preview

#Preview {
    
    MapView()
}
