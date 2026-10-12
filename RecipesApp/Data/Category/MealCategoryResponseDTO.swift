//
//  MealCategoryResponseDTO.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

import Foundation

struct MealCategoryResponseDTO: Decodable, Sendable {
    let categories: [MealCategoryDTO]?
}

