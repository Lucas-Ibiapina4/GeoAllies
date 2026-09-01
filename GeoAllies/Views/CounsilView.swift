//
//  CounsilView.swift
//  GeoAllies
//
//  Created by Bianca Moura on 01/09/26.
//

import SwiftUI
import UniformTypeIdentifiers
import Foundation

struct CounsilView: View {
    @State var isCorrect: Bool = false
    @State var showResult: Bool = false
    @State private var viewModel = FoundationModelServices()
    @FocusState private var tecladoEstaAtivo
    
    var body: some View{
        NavigationStack {
//            Spacer()
//            Spacer()
//            Spacer()
//            Spacer()

            HStack {
                Image("counsil")
                    .resizable()
                    .scaledToFit()
                Spacer()
                Spacer()

                VStack(alignment: .leading){
                    Text("Qual a sua dúvida?")
                    TextField("Digite aqui", text: $viewModel.answerUser, axis: .vertical)
                        .frame(maxWidth: 250)
                        .border(Color.black)
                        .focused($tecladoEstaAtivo)
                    if !viewModel.messageError.isEmpty {
                        Text(viewModel.messageError)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                    Button(action: {
                        Task {
                            await viewModel.loadModel()
                        }
                        tecladoEstaAtivo = false
                    }) {
                        Text("Gerar Resposta")
                            .bold()
                    }
                    .buttonStyle(.borderedProminent)
                    ScrollView {
                        Text(viewModel.responseModel)
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
}
#Preview {
     CounsilView()
}
