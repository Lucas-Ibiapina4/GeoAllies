//
//  Agnolia.swift
//  GeoAllies
//
//  Created by Lucas Ibiapina on 31/08/26.
//

import SwiftUI

struct Agnolia: View {
    
    @Environment(GameManager.self) private var gamemanager
    
    var body: some View {
        VStack {
            Text("Agnolia")
            
            Text("Economia: \(gamemanager.agnolia.economia)")
            Text("Militarismo: \(gamemanager.agnolia.militarismo)")
            Text("Tecnologia: \(gamemanager.agnolia.tecnologia)")
        }
    }
}

#Preview {
    Agnolia()
        .environment(GameManager())
}
