//
//  Food.swift
//  DailyDiet
//
//  Created by ali on 5/24/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import Foundation



// MARK: - Food
struct FoodInfo: Codable {
    var id: Int
    var category: String
    var image, thumbnail: String
    var title: String
    var nutrition: FoodNutrition
}

// MARK: - Nutrition
struct FoodNutrition: Codable {
    var calories, fat: Int
    var fiber, protein: Double
}
