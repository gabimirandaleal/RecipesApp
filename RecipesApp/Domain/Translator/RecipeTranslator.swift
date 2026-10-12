//
//  RecipeTranslator.swift
//  RecipesApp
//
//  Created by gabriela.leal on 12/10/26.
//

protocol RecipeTranslator {
    func translate(_ recipe: MealDetail, to language: String) async throws -> MealDetail
}
