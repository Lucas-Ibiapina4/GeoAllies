//
//  Castria.swift
//  GeoAllies
//
//  Created by Lucas Ibiapina on 31/08/26.
//

import SwiftUI

struct Castria: View {
    
    @Environment(GameManager.self) private var gamemanager
    
    var body: some View {
        VStack {
            Text("Castria")
            
            Text("Economia: \(gamemanager.castria.economia)")
            Text("Militarismo: \(gamemanager.castria.militarismo)")
            Text("Tecnologia: \(gamemanager.castria.tecnologia)")
        }
    }
}

#Preview {
    Castria()
        .environment(GameManager())
}
