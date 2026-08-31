//
//  Agnolia.swift
//  GeoAllies
//
//  Created by Lucas Ibiapina on 31/08/26.
//

import SwiftUI

struct Agnolia: View {
    let agnolia = Country(economia: 5, militarismo: 1, tecnologia: 1)
    
    var body: some View {
        Text("Economia = \(agnolia.economia)")
        Text("Militarismo = \(agnolia.militarismo)")
        Text("Tecnologia = \(agnolia.tecnologia)")
    }
}

//#Preview {
//    Agnolia()
//}
