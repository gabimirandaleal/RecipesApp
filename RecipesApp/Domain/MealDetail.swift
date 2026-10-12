//
//  Meal.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

import Foundation

struct MealDetail: Hashable, Sendable, Identifiable {
    let id: String
    let name: String
    let imageURL: URL?
    let ingredients: [Ingredient]
    let area: String?
    let category: String?
    let videoURL: URL?
    let instructions: String
    let tags: [String]
    let sourceURL: URL?
}
