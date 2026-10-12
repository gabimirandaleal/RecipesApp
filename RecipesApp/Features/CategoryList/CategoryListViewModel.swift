//
//  CategoryListViewModel.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class CategoryListViewModel {
    enum State: Equatable {
        case idle
        case loading
        case success([MealCategory])
        case empty
        case error(String)
    }
    
    private(set) var state: State = .idle
    var query: String = ""
    
    private let repository: MealCategoryRepository
    
    init(repository: MealCategoryRepository) {
        self.repository = repository
    }
    
    func searchCategory() async {
        let term = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let start = Date()
        state = .loading
        do {
            let mealsCategory = try await repository.searchCategory(query: term)
            state = mealsCategory.isEmpty ? .empty : .success(mealsCategory)
        } catch {
            state = .error("Could not fetch the categories. Please try again.")
        }
    }
}
