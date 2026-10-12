//
//  AppRouteView.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

import SwiftUI

struct AppRouteView: View {
    
    private static let apiKey: String? = {
        let key = Bundle.main.object(forInfoDictionaryKey: "AnthropicAPIKey") as? String
        return key?.isEmpty == false ? key : nil
    }()
    
    private static let translatorRecipe: RecipeTranslator? = (apiKey)
        .flatMap { $0.isEmpty ? nil : ClaudeRecipeTranslator(apiKey: $0) }
    
    private static let translatorCategory: CategoryTranslator? = (apiKey)
        .flatMap { $0.isEmpty ? nil : ClaudeCategoryTranslator(apiKey: $0) }
    
    @State private var router = Router()
    @State private var categoryViewModel = CategoryListViewModel(
        repository: RemoteMealCategoryRepository(),
        analytics: ConsoleAnalyticsTracker(),
        translator: Self.translatorCategory
    )
    
    
    
    var body: some View {
        NavigationStack(path: $router.path) {
            CategoryList(viewModel: categoryViewModel) { id in
                router.showList(of: id)
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .recipeList(let category):
                    RecipeListView(
                        viewModel: RecipeListViewModel(
                            repository: RemoteMealRepository(),
                            categoryName: category
                        ),
                        goRecipeDetails: { id in
                            router.showDetail(of: id)
                        }
                    )
                    
                case .recipeDetail(let id):
                    RecipeDetailView(
                        viewModel: RecipeDetailViewModel(
                            repository: RemoteMealDetailRepository(),
                            id: id,
                            analytics: ConsoleAnalyticsTracker(),
                            experiment: LocalExperimentProvider(),
                            translator: Self.translatorRecipe
                        )
                    )

                }
            }
        }
    }
}
