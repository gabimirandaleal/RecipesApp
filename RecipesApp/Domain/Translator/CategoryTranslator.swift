//
//  CategoryTranslator.swift
//  RecipesApp
//
//  Created by gabriela.leal on 12/10/26.
//

protocol CategoryTranslator {
    func translate(_ categories: [MealCategory], to language: String) async throws -> [MealCategory]
}
