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
    var query: String = ""
    
    private let repository: MealRepository
    
    init(repository: MealRepository) {
        self.repository = repository
    }
    
    func search() async {
        let term = query.trimmingCharacters(in: .whitespacesAndNewlines)
        state = .loading
        do {
            let meals = try await repository.searchMeals(query: term)
            state = meals.isEmpty ? .empty : .success(meals)
        } catch {
            state = .error("Não foi possível buscar receitas. Tente novamente.")
        }
    }
}
