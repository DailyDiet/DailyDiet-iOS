//
//  Search.swift
//  DailyDiet
//
//  Created by ali on 5/31/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import Foundation


// MARK: - Search
struct Search: Codable {
    var results: [Result]
    var totalResultsCount: Int

    enum CodingKeys: String, CodingKey {
        case results
        case totalResultsCount = "total_results_count"
    }
}

// MARK: - Result
struct Result: Codable {
    var category: String
    var id: Int
    var image: String
    var nutrition: SearchNutrition
    var thumbnail: String
    var title: String
}

// MARK: - Search Nutrition
struct SearchNutrition: Codable {
    var calories: Int
    var fat: Double
    var fiber: Double
    var protein: Double
}
