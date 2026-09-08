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
                    Color(red: 0.6, green: 0.35, blue: 0.1)
                )
                .mask(configuration.label)
                .offset(x: 4, y: 7)
            
            configuration.label
                .offset(
                    x: configuration.isPressed ? 4 : 0,
                    y: configuration.isPressed ? 7 : 0
                )
        }
        .animation(
            .spring(response: 0.3, dampingFraction: 0.6),
            value: configuration.isPressed
        )
    }
}

struct MapView: View {
    @Environment(\.modelContext) private var context
    @Query private var savedCountries: [Country]
    @State private var gameManager = GameManager()
    
    @State private var isPresentedSeuPais = false
    @State private var isPresentedAgnolia = false
    @State private var isPresentedCaustria = false
    @State private var isPresentedLucasia = false
    
    @State private var showingCounsil = false
    
    private var hasCountryPopupOpen: Bool {
        isPresentedSeuPais ||
        isPresentedAgnolia ||
        isPresentedCaustria ||
        isPresentedLucasia ||
        showingCounsil
    }
    
    private var lucaciaAliada: Bool {
        gameManager.aliados.contains { $0.id == gameManager.lucacia.id }
    }
    
    private var agnoliaAliada: Bool {
        gameManager.aliados.contains { $0.id == gameManager.agnolia.id }
    }
    
    private var caustriaAliada: Bool {
        gameManager.aliados.contains { $0.id == gameManager.cuastria.id }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Group {
                    Color.blueSea
                    Image("fundo")
                        .resizable()
                }
                .ignoresSafeArea()
                
                Button {
                    isPresentedAgnolia = true
                } label: {
                    Image(agnoliaAliada ? "AgnoliaGreen" : "AgnoliaImage")
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220)
                        .contentShape(Circle())
                }
                .buttonStyle(EstiloIlha3D())
                .offset(x: -180, y: -80)
                
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
                
                Button {
                    isPresentedCaustria = true
                } label: {
                    Image(caustriaAliada ? "CaustriaGreen" : "CaustriaImage")
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 210)
                        .contentShape(Circle())
                }
                .buttonStyle(EstiloIlha3D())
                .offset(x: 20, y: 30)
                
                Button {
                    isPresentedLucasia = true
                } label: {
                    Image(lucaciaAliada ? "País3" : "LucaciaImage")
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: lucaciaAliada ? 210 : 190)
                        .contentShape(Capsule())
                }
                .buttonStyle(EstiloIlha3D())
                .offset(x: 230, y: 0)
                
                VStack {
                    HStack {
                        Spacer()
                        counselorButton
                            .padding(.top, 32)
                            .padding(.trailing, 48)
                    }
                    Spacer()
                }
                .allowsHitTesting(!hasCountryPopupOpen)

                if isPresentedSeuPais {
                    PlayerCountryView(isPresent: $isPresentedSeuPais)
                        .zIndex(100)
                }
                
                if isPresentedAgnolia {
                    AgnoliaView(isPresent: $isPresentedAgnolia)
                        .zIndex(100)
                }
                
                if isPresentedCaustria {
                    CaustriaView(isPresent: $isPresentedCaustria)
                        .zIndex(100)
                }
                
                if isPresentedLucasia {
                    LucaciaView(isPresent: $isPresentedLucasia)
                        .zIndex(100)
                }
                
                if showingCounsil {
                    CounsilView(isPresent: $showingCounsil)
                        .zIndex(1000)
                }
            }
        }

        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .environment(gameManager)
        
        .onAppear {
            if let savedData = savedCountries.first {
                gameManager.yourCountry = savedData
                
                gameManager.aliados.removeAll()
                
                if savedData.aliouAgnolia {
                    gameManager.aliados.append(gameManager.agnolia)
                }
                if savedData.aliouCaustria {
                    gameManager.aliados.append(gameManager.cuastria)
                }
                if savedData.aliouLucacia {
                    gameManager.aliados.append(gameManager.lucacia)
                }
                
            } else {
                let newData = Country(economia: 0, militarismo: 0, tecnologia: 0)
                context.insert(newData)
                gameManager.yourCountry = newData
            }
        }
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
}

#Preview {
    MapView()
}
