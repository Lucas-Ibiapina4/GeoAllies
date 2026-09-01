//
//  InitialScreen(Test).swift
//  GeoAllies
//
//  Created by Lucas Ibiapina on 31/08/26.
//

import SwiftUI

struct InitialScreen_Test_: View {
    @State var irParaYourCountry: Bool = false
    @State var irParaAgnolia: Bool = false
    @State var irParaCastria: Bool = false
    @State var irParaMourash: Bool = false

    
    var body: some View {
        NavigationStack {
            HStack {
                
                Button(action: {
                    irParaYourCountry = true
                }) {
                    Image("PaísSeu")
                }
                .navigationDestination(isPresented: $irParaYourCountry){
                    SeuPais()
                }
                
                Button(action: {
                    irParaAgnolia = true
                }) {
                    Image("País1")
                }
                .navigationDestination(isPresented: $irParaAgnolia){
                    Agnolia()
                }
                
                Button(action: {
                    irParaCastria = true
                }) {
                    Image("País2")
                }
                .navigationDestination(isPresented: $irParaCastria){
                    Castria()
                }
                
                Button(action: {
                    irParaMourash = true
                }) {
                    Image("País3")
                }
                .navigationDestination(isPresented: $irParaMourash){
                    Mourash()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.blue)
            
        }

        
    }
}

#Preview {
    InitialScreen_Test_()
}
