//
//  PlanResult.swift
//  DailyDiet
//
//  Created by ali on 5/29/20.
//  Copyright © 2020 Alireza. All rights reserved.
//
import SwiftyJSON
import Foundation


// MARK: - Diet
struct Diet: Codable {
    var diet: [String]
    
    
    
    static func getDietJSON(item: String) -> DietElement?{
        let data = item.data(using: .utf8)!
//        var json = try? JSONSerialization.jsonObject(with: data) as? [String:Any]
//        Log.i("\(json)")
        
        let decoder = JSONDecoder()
        
        if let dietElement = try? decoder.decode(DietElement.self, from: data) {
            return dietElement
           }
        
        return nil
    }
}


struct DietElement: Codable {
    var id: Int
    var category: String
    var image: String
    var thumbnail: String
    var title: String
    var nutrition: DietNutrition
}

struct DietNutrition: Codable {
    var calories: Int
    var fat: Float
    var fiber: Float
    var protein: Float
}

//
//enum DietElement: Codable {
//    case integer(Int)
//    case string(String)
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if let x = try? container.decode(Int.self) {
//            self = .integer(x)
//            return
//        }
//        if let x = try? container.decode(String.self) {
//            self = .string(x)
//            return
//        }
//        throw DecodingError.typeMismatch(DietElement.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for DietElement"))
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        switch self {
//        case .integer(let x):
//            try container.encode(x)
//        case .string(let x):
//            try container.encode(x)
//        }
//    }
//}
