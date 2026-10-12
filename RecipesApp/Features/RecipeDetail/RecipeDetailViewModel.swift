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
    
    private let translator: RecipeTranslator?
    private let language: String
    
    init(
        repository: MealDetailRepository,
        id: String,
        analytics: AnalyticsTracker,
        experiment: ExperimentProvider,
        translator: RecipeTranslator?,
        language: String = Bundle.main.preferredLocalizations.first ?? "en"
    ) {
        self.repository = repository
        self.id = id
        self.analytics = analytics
        self.youtubeVariant = experiment.variant(for: .youtubeButtonPosition)
        self.translator = translator
        self.language = language
    }
    
    var showsYoutubeOnTop: Bool {
        youtubeVariant == .treatment
    }
    
    func loadIfNeeded() async {
        guard case .idle = state else { return }
        await search()
    }
    
    func search() async {
        let term = id.trimmingCharacters(in: .whitespacesAndNewlines)
        state = .loading
        do {
            let meals = try await repository.searchRecipe(id: term)

            if let recipe = meals.first, let translator, !language.hasPrefix("en") {
                do {
                    let translated = try await translator.translate(recipe, to: language)
                    state = .success([translated])
                } catch {
                    state = .success([recipe])
                }
            } else {
                state = meals.isEmpty ? .empty : .success(meals)
            }
        } catch {
            state = .error(String(localized: "Could not fetch this recipe. Please try again."))
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
