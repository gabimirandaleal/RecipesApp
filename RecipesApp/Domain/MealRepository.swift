//
//  MealRepository.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

protocol MealRepository: Sendable {
    func searchMeals(query: String) async throws -> [Meal]
}
