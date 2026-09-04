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
                .overlay(Color(red: 0.6, green: 0.35, blue: 0.1))
                .mask(configuration.label)
                .offset(x: 4, y: 7)
            
            configuration.label
                .offset(
                    x: configuration.isPressed ? 4 : 0,
                    y: configuration.isPressed ? 7 : 0
                )
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct MapView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var savedCountries: [Country]
    
    @State private var gameManager = GameManager()
    
    @State private var isPresentedSeuPais: Bool = false
    @State private var isPresentedAgnolia: Bool = false
    @State private var isPresentedCaustria: Bool = false
    @State private var isPresentedLucasia: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Group {
                    Color.blueSea
                    Image("fundo")
                        .resizable()
                }
                .ignoresSafeArea(edges: .all)
                
                Button(action: {
                    isPresentedAgnolia = true
                }) {
                    Image("AgnoliaImage")
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220)
                        .contentShape(Circle())
                }
                .buttonStyle(EstiloIlha3D())
                .offset(x: -180, y: -80)
                
                .navigationDestination(isPresented: $isPresentedAgnolia){
                    AgnoliaView(isPresent: $isPresentedAgnolia)
                }
                
                Button(action: {
                    isPresentedSeuPais = true
                }) {
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
                }
                .buttonStyle(EstiloIlha3D())
                .offset(x: 20, y: 30)
                
                .navigationDestination(isPresented: $isPresentedCaustria){
                    CaustriaView(isPresent: $isPresentedCaustria)
                }
                
                Button(action: {
                    isPresentedLucasia = true
                }) {
                    Image("LucaciaImage")
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 190)
                        .contentShape(Capsule())
                }
                .buttonStyle(EstiloIlha3D())
                .offset(x: 230, y: -0)
                
                .navigationDestination(isPresented: $isPresentedLucasia){
                    LucaciaView(isPresent: $isPresentedLucasia)
                }
                
                VStack {
                    HStack {
                        Spacer()
                        CounsilButtonView()
                            .padding(.top, 32)
                            .padding(.trailing, 48)
                    }
                    Spacer()
                }
                
                if isPresentedSeuPais {
                    PlayerCountryView(isPresent: $isPresentedSeuPais)
                        .zIndex(100)
                }
            }
        }
        .navigationBarHidden(true)
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
}

#Preview {
    MapView()
}
