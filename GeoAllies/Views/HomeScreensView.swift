//
//  HomeScreensView.swift
//  GeoAllies
//
//  Created by Agnes Pontes Ristau on 31/08/26.
//

import SwiftUI

struct HomeScreensView: View {
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                
                // Fundo da tela
                Color(
                    red: 26 / 255,
                    green: 34 / 255,
                    blue: 125 / 255
                )
                .ignoresSafeArea()
                
                
                // Botão que leva para o mapa
                NavigationLink {
                    MapView()
                } label: {
                    ZStack {
                        // sombra do botão
                        RoundedRectangle(cornerRadius: 50)
                            .fill(
                                Color(
                                    red: 77 / 255,
                                    green: 45 / 255,
                                    blue: 12 / 255
                                )
                            )
                            .frame(width: 285, height: 108)
                            .offset(y: 6)
                        
                        
                        // Botão
                        RoundedRectangle(cornerRadius: 50)
                            .fill(
                                Color(
                                    red: 254 / 255,
                                    green: 148 / 255,
                                    blue: 39 / 255
                                )
                            )
                            .frame(width: 285, height: 102)
                        
                        
                        // Conteúdo do botão
                        HStack(spacing: 14) {
                            
                            Image(systemName: "play.fill")
                                .font(.system(size: 48))
                                .foregroundStyle(.white)
                            
                            Text("Play")
                                .font(
                                    .system(
                                        size: 56,
                                        weight: .bold,
                                        design: .rounded
                                    )
                                )
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
            
            // Esconde a barra de navegação
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    HomeScreensView()
}
