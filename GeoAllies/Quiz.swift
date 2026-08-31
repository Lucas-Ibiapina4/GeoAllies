//
//  Quiz.swift
//  GeoAllies
//
//  Created by Lucas Ibiapina on 31/08/26.
//

import SwiftUI

struct Quiz: View {
    @State var yourCountry = Country(economia: 0, militarismo: 0, tecnologia: 0)
    
    @State var irParaYourCountry: Bool = false
    var body: some View {
        Button(action: {
            yourCountry.economia += 1
            }) {
                Image(systemName: "plus")
            }
        }
    }


#Preview {
    Quiz()
}
