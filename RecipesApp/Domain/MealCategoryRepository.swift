//
//  MealCategoryRepository.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

protocol MealCategoryRepository: Sendable {
    func searchCategory(query: String) async throws -> [MealCategory]
}
