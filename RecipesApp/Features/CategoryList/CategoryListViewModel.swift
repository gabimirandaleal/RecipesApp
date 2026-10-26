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

    private let repository: MealCategoryRepository
    private let analytics: AnalyticsTracker
    
    private let translator: CategoryTranslator?
    private let language: String
    
    init(
        repository: MealCategoryRepository,
        analytics: AnalyticsTracker,
        translator: CategoryTranslator?,
        language: String = Bundle.main.preferredLocalizations.first ?? "en"
    ) {
        self.repository = repository
        self.analytics = analytics
        self.translator = translator
        self.language = language
    }
    
    func loadIfNeeded() async {
        guard case .idle = state else { return }
        await searchCategory()
    }
    
    func searchCategory(value: String = "") async {
        let term = value.trimmingCharacters(in: .whitespacesAndNewlines)
        state = .loading
        
        do {
            let mealsCategory = try await repository.searchCategory(query: term)
            if let translator, !language.hasPrefix("en") {
                do {
                    let translated = try await translator.translate(mealsCategory, to: language)
                    state = translated.isEmpty ? .empty : .success(translated)
                } catch {
                    state = mealsCategory.isEmpty ? .empty : .success(mealsCategory)
                }
            } else {
                state = mealsCategory.isEmpty ? .empty : .success(mealsCategory)
            }
        } catch {
            state = .error(String(localized: "Could not fetch the categories. Please try again."))
        }
    }
    
    func categorySelected(category: String) {
        analytics.track(.categorySelected(category))
    }
}
