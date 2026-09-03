//
//  ContentView.swift
//  GeoAllies
//
//  Created by Lucas Ibiapina on 28/08/26.
//
//
import SwiftUI

struct ContentView: View {
    @State private var isPresentedGeo: Bool = false
    @State private var isPresentedGame: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(){
                Button{
                    isPresentedGeo = true
                } label: {
                    Label("Conversar sobre Geopolitica", systemImage: "person.fill")
                        .navigationDestination(isPresented: $isPresentedGeo){
                            CounsilView()
                        }
                }
                .padding(70)
                Button{
                    isPresentedGame = true
                } label: {
                    Label("Conversar sobre o jogo", systemImage: "person.fill")
                        .navigationDestination(isPresented: $isPresentedGame){
                            CounsilGameView()
                        }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
