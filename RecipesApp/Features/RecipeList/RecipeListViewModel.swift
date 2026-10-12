//
//  RecipeListViewModel.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class RecipeListViewModel {
    enum State: Equatable {
        case idle
        case loading
        case success([Meal])
        case empty
        case error(String)
    }
    

    private(set) var state: State = .idle
    private(set) var categoryName: String
    private let repository: MealRepository
    
    init(repository: MealRepository, categoryName: String) {
        self.repository = repository
        self.categoryName = categoryName
    }
    
    func search() async {
        let term = categoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        let start = Date()
        state = .loading
        do {
            let meals = try await repository.searchMeals(query: term)
            state = meals.isEmpty ? .empty : .success(meals)
        } catch {
            state = .error("Could not fetch the recipes for this category. Please try again.")
        }
    }
}
