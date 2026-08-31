//
//  Mourash.swift
//  GeoAllies
//
//  Created by Lucas Ibiapina on 31/08/26.
//

import SwiftUI

struct Mourash: View {
    let mourash = Country(economia: 1, militarismo: 1, tecnologia: 5)
    var body: some View {
        Text("Economia = \(mourash.economia)")
        Text("Militarismo = \(mourash.militarismo)")
        Text("Tecnologia = \(mourash.tecnologia)")
    }
}

#Preview {
    Mourash()
}
