//
//  AppRouteView.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

import SwiftUI

struct AppRouteView: View {
    @State private var router = Router()
    @State private var categoryViewModel = CategoryListViewModel(repository: RemoteMealCategoryRepository(), analytics: ConsoleAnalyticsTracker())
    
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
                            analytics: ConsoleAnalyticsTracker()
                        )
                    )

                }
            }
        }
    }
}
