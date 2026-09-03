//
//  QuizContent.swift
//  GeoAllies
//
//  Created by Lucas Ibiapina on 01/09/26.
//

import SwiftUI

struct QuizContent: View {
    
    var quiz : QuestionsModel
    
    var body: some View {
        
                HStack(spacing: 10) {
                    VStack {
                     
                        Text(quiz.question)
                    }
                    VStack {
                        ForEach(quiz.options, id: \.self) { index in
                            Text(index)
                            
                        }
                        
                    }
                    Text(quiz.answer)
                }
        
    }
}

#Preview {
    QuizContent(
        quiz: QuestionsModel(
            pilar: "pilar",
            question: "question",
            options: ["option1", "option 2", "option 3", "option 4"],
            answer: "option 1"
        )
    )
}
