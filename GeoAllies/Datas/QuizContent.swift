//
//  QuizContent.swift
//  GeoAllies
//
//  Created by Lucas Ibiapina on 01/09/26.
//

import SwiftUI

struct QuizContent: View {
    
    var quiz : QuizType
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                        
                        Text(quiz.pilar)
                        
                        Spacer()
                        
                        Text(quiz.question)
                        
                        Spacer()
                        
                        ForEach(quiz.options, id: \.self) { index in
                            Spacer()
                            
                            Text(index)
                            
                        }
                        
                        Text(quiz.answer)
                    
                }
            }
        }
        
    }
}

#Preview {
   // QuizContent()
}
