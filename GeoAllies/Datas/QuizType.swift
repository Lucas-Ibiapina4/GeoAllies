//
//  QuizType.swift
//  GeoAllies
//
//  Created by Lucas Ibiapina on 01/09/26.
//

//import SwiftUI
//import Foundation
//import Playgrounds
//
//struct Quiz: Codable, Identifiable {
//    let id: UUID = UUID()
//    let pilar, question, information, image: String
//    let tipSection: [TipSection]
//    static let listaDicas: [Tip] = Bundle.main.decode(file: "Tips")
//    
//}
//
//extension Bundle {
//    func decode<T: Decodable>(file: String) -> T {
//        
//        guard let url = self.url(forResource: file, withExtension: "json") else {
//            fatalError("Não foi possível encontrar \(file) no projeto.")
//        }
//        print("Encontrou o json")
//        
//        guard let data = try? Data(contentsOf: url) else {
//            fatalError("Não foi possível carregar \(file) do projeto.")
//        }
//        print("Carregou o Data do json")
//        
//        let decoder = JSONDecoder()
//        
//        guard let loadedData = try? decoder.decode(T.self, from: data) else {
//            fatalError("Falha ao decodificar \(file). Verifique se o JSON combina com sua Struct.")
//        }
//        
//        return loadedData
//    }
//}
//
//#Playground {
//    let result: [Tip] = Bundle.main.decode(file: "Tips")
//      
//}


//olaaaaa
