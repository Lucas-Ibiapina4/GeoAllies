//
//  GeoAlliesApp.swift
//  GeoAllies
//
//  Created by Lucas Ibiapina on 28/08/26.
//

import SwiftUI

@main
struct GeoAlliesApp: App {
    
    //mantem os dados enquanto o app está rodando e cria a instancia baseada no GameManager
    @State private var gamemanager = GameManager()
    
        var body: some Scene {
            WindowGroup {
                ContentView()
                    .environment(gamemanager) //disponibiliza essa instancia para todo mundo
                    .preferredColorScheme(.light)
            }
        }
}
