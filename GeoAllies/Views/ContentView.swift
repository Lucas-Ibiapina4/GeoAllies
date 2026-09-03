//
//  ContentView.swift
//  GeoAllies
//
//  Created by Lucas Ibiapina on 28/08/26.
//
//
import SwiftUI

struct ContentView: View {
    @State private var isPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            Button{
                isPresented = true
            } label: {
                Label("Conversar com o Conselheiro", systemImage: "person.fill")
                    .navigationDestination(isPresented: $isPresented){
                        CounsilView()
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
