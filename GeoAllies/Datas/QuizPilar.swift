//
//  QuizPilar.swift
//  GeoAllies
//
//  Created by Lucas Ibiapina on 02/09/26.
//

import Foundation

enum QuizPilar: String, Hashable, Identifiable {
    case economia = "Economia"
    case militarismo = "Militarismo"
    case tecnologia = "Tecnologia"
    
    var id: Self { self }
}
//
