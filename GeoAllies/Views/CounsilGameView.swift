//
//  CounsilGameView.swift
//  GeoAllies
//
//  Created by Bianca Moura on 02/09/26.
//

import SwiftUI
import UniformTypeIdentifiers
import Foundation

struct CounsilGameView: View {
    @State var isCorrectGame: Bool = false
    @State var showResultGame: Bool = false
    @State private var viewModelGame = FoundationModelGameServices()
    @FocusState private var isKeyboard: Bool
    
    var body: some View{
        HStack {
            Image("counsil")
                .resizable()
                .scaledToFit()
            Spacer()
            Spacer()
            
            VStack(alignment: .leading){
                Text("Qual a sua dúvida?")
                TextField("Digite aqui", text: $viewModelGame.answerUserGame, axis: .vertical)
                    .frame(maxWidth: 250)
                    .border(Color.black)
                    .focused($isKeyboard)
                if !viewModelGame.messageErrorGame.isEmpty {
                    Text(viewModelGame.messageErrorGame)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
                Button(action: {
                    Task {
                        await viewModelGame.loadModelGame()
                    }
                    isKeyboard = false
                }) {
                    Text("Gerar Resposta")
                        .bold()
                }
                .buttonStyle(.borderedProminent)
                ScrollView {
                    Text(viewModelGame.responseModelGame)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding()
            }
        }
    }
}
#Preview {
    // ContentView(text: "")
}
