//
//  Castria.swift
//  GeoAllies
//
//  Created by Lucas Ibiapina on 31/08/26.
//

import SwiftUI

struct Castria: View {
    let castria = Country(economia: 1, militarismo: 5, tecnologia: 1)
    
    var body: some View {
        Text("Economia = \(castria.economia)")
        Text("Militarismo = \(castria.militarismo)")
        Text("Tecnologia = \(castria.tecnologia)")
    }
}

#Preview {
    Castria()
}
