//
//  RecipeDetailViewModel.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class RecipeDetailViewModel {
    enum State: Equatable {
        case idle
        case loading
        case success([MealDetail])
        case empty
        case error(String)
    }
    

    private(set) var state: State = .idle
    private(set) var id: String
    private let repository: MealDetailRepository
    private let analytics: AnalyticsTracker
    private let youtubeVariant: Variant
    
    init(
        repository: MealDetailRepository,
        id: String,
        analytics: AnalyticsTracker,
        experiment: ExperimentProvider
    ) {
        self.repository = repository
        self.id = id
        self.analytics = analytics
        self.youtubeVariant = experiment.variant(for: .youtubeButtonPosition)
    }
    
    var showsYoutubeOnTop: Bool {
        youtubeVariant == .treatment
    }
    
    func search() async {
        let term = id.trimmingCharacters(in: .whitespacesAndNewlines)
        let start = Date()
        state = .loading
        do {
            let meals = try await repository.searchRecipe(id: term)
            state = meals.isEmpty ? .empty : .success(meals)
        } catch {
            state = .error("Could not fetch this recipe. Please try again.")
        }
    }
    
    func youtubeLinkTapped() {
        analytics.track(.youtubeLinkTapped(id))
    }
    
    func screenAppered() {
        analytics.track(.recipeDetailViewed(id))
        analytics.track(.experimentExposed(experiment: .youtubeButtonPosition, variant: youtubeVariant))
    }
}
