//
//  MealRepository.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

protocol MealDetailRepository: Sendable {
    func searchRecipe(id: String) async throws -> [MealDetail]
}
