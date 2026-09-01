//
//  Mourash.swift
//  GeoAllies
//
//  Created by Lucas Ibiapina on 31/08/26.
//

import SwiftUI

struct Mourash: View {
    
    @Environment(GameManager.self) private var gamemanager
    
    var body: some View {
        
        VStack {
            Text("Mourash")
            
            Text("Economia: \(gamemanager.mourash.economia)")
            Text("Militarismo: \(gamemanager.mourash.militarismo)")
            Text("Tecnologia: \(gamemanager.mourash.tecnologia)")
        }
    }
}

#Preview {
    Mourash()
        .environment(GameManager())
}
