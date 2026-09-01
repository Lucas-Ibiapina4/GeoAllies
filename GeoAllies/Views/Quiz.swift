//
//  Quiz.swift
//  GeoAllies
//
//  Created by Lucas Ibiapina on 31/08/26.
//

import SwiftUI

struct Quiz: View {
    
    @State private var questao: [QuizType] = []
    
    var body: some View {
        
        HStack {
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("QuizTextBox"))
                    .frame(width: 300, height: 300)
                
                Text("teste")
                
            }
           
            VStack(spacing: 35){
                ForEach(0..<4, id: \.self){ _ in
                    
                    
                        Button {
                            
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color("QuizTextBox"))
                                    .frame(width: 300, height: 50)
                                
                                Text("teste")
                                    .foregroundColor(.black)
                            }
                        }
                    
                }
            }
                
        }
                
    }
}


#Preview {
    Quiz()
}
