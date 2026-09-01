//
//  SeuPaís.swift
//  GeoAllies
//
//  Created by Lucas Ibiapina on 31/08/26.
//

import SwiftUI

struct SeuPais: View {
//    @State var yourCountry = Country(economia: 0, militarismo: 0, tecnologia: 0)
    
    //verifica a instancia criada lá no GameManager
    @Environment(GameManager.self) private var gamemanager
    
    var body: some View {
        
        //mostra os dados em tempo real do que está no GameManager
        VStack {
                    Text("Meu País")
                    
                    Text("Economia: \(gamemanager.yourCountry.economia)")
                    Text("Militarismo: \(gamemanager.yourCountry.militarismo)")
                    Text("Tecnologia: \(gamemanager.yourCountry.tecnologia)")
                }
        
//        HStack {
//            Text("Economia = \(yourCountry.economia)")
//            Quiz(yourCountry: yourCountry)
//        }
//        Text("Militarismo = \(yourCountry.militarismo)")
//            Quiz(yourCountry: yourCountry)
//        Text("Tecnologia = \(yourCountry.tecnologia)")
    }
}

#Preview {
    SeuPais()
        .environment(GameManager())
}
