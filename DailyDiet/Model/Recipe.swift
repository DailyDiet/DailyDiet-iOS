//
//  Recipe.swift
//  DailyDiet
//
//  Created by ali on 5/24/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import Foundation


// MARK: - Recipe
struct Recipe: Codable {
    var authorID: Int
    var category: String
    var cookTime: Int
    var dateCreated, recipeDescription: String
    var directions: [Direction]
    var foodName: String
    var id: Int
    var images: [Image]
    var ingredients: [Ingredient]
    var nutrition: Nutrition
    var prepTime: Int
    var primaryImage, primaryThumbnail: String
    var servings: Int
    var source, tagCloud: String

    enum CodingKeys: String, CodingKey {
        case authorID = "author_id"
        case category
        case cookTime = "cook_time"
        case dateCreated = "date_created"
        case recipeDescription = "description"
        case directions
        case foodName = "food_name"
        case id, images, ingredients, nutrition
        case prepTime = "prep_time"
        case primaryImage = "primary_image"
        case primaryThumbnail = "primary_thumbnail"
        case servings, source
        case tagCloud = "tag_cloud"
    }
}

// MARK: - Direction
struct Direction: Codable {
    var id: Int
    var text: String
}

// MARK: - Image
struct Image: Codable {
    var id: Int
    var image, thumbnail: String
}

// MARK: - Ingredient
struct Ingredient: Codable {
    var amount: Double
    var food: Food
    var grams: Double
    var preparation: String?
    var units: String
}

// MARK: - Food
struct Food: Codable {
    var foodName: String
    var id: Int
    var nutrition: Nutrition
    var primaryThumbnail: String

    enum CodingKeys: String, CodingKey {
        case foodName = "food_name"
        case id, nutrition
        case primaryThumbnail = "primary_thumbnail"
    }
}

// MARK: - Nutrition
struct Nutrition: Codable {
    var calories, carbs, fats, proteins: Double
}
