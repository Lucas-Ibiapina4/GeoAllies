//
//  SeuPaís.swift
//  GeoAllies
//
//  Created by Lucas Ibiapina on 31/08/26.
//

import SwiftUI

struct SeuPais: View {
    @State var yourCountry = Country(economia: 0, militarismo: 0, tecnologia: 0)
    
    var body: some View {
        HStack {
            Text("Economia = \(yourCountry.economia)")
            Quiz(yourCountry: yourCountry)
        }
        Text("Militarismo = \(yourCountry.militarismo)")
            Quiz(yourCountry: yourCountry)
        Text("Tecnologia = \(yourCountry.tecnologia)")
    }
}

#Preview {
    SeuPais()
}
