//
//  CounsilBotonView.swift
//  GeoAllies
//
//  Created by Bianca Moura on 03/09/26.
//

import SwiftUI
import Foundation

struct CounsilButtonView: View {
    var body: some View {
        Button(action: {
            print("Abrir conselheiro")
        }) {
            ZStack {
                Circle()
                    .fill(Color(red: 241/255, green: 157/255, blue: 59/255))
                    .frame(width: 50, height: 50)
                    .shadow(radius: 3)
                
                HStack(spacing: 2) {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .foregroundColor(.white)
                    
                    Image(systemName: "waveform")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 14)
                        .foregroundColor(.white)
                }
            }
        }
    }
}
