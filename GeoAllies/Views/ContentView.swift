//
//  ContentView.swift
//  GeoAllies
//
//  Created by Lucas Ibiapina on 28/08/26.
//
//
import SwiftUI

struct ContentView: View {
    @State private var isPresentedGeo: Bool = false
    @State private var isPresentedGame: Bool = false
    
    var body: some View {
        HomeScreensView()
    }
}

#Preview {
    ContentView()
}
