//
//  MealsResponseDTO.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

import Foundation

struct MealsResponseDTO: Decodable, Sendable {
    let meals: [MealDTO]?
}
