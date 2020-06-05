//
//  PlanResult.swift
//  DailyDiet
//
//  Created by ali on 5/29/20.
//  Copyright © 2020 Alireza. All rights reserved.
//
import Foundation

// MARK: - Diet
struct Diet: Codable {
    var diet: [DietElement]
}

enum DietElement: Codable {
    case dietClass(DietClass)
    case integer(Int)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(DietClass.self) {
            self = .dietClass(x)
            return
        }
        throw DecodingError.typeMismatch(DietElement.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for DietElement"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .dietClass(let x):
            try container.encode(x)
        case .integer(let x):
            try container.encode(x)
        }
    }
}

// MARK: - DietClass
struct DietClass: Codable {
    var category: String
    var id: Int
    var image: String?
    var nutrition: DietNutrition
    var thumbnail: String?
    var title: String
}

// MARK: - Nutrition
struct DietNutrition: Codable {
    var calories: Int
    var fat, fiber, protein: Double
}
