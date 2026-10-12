//
//  ContentView.swift
//  ReceitasApp
//
//  Created by gabriela.leal on 11/10/26.
//

import SwiftUI

struct RecipeListView: View {
    @State private var viewModel: RecipeListViewModel
    private let goRecipeDetail: (_ id: String) -> Void
    
    init(viewModel: RecipeListViewModel, goRecipeDetails: @escaping (_ id: String) -> Void) {
        self.viewModel = viewModel
        self.goRecipeDetail = goRecipeDetails
    }
    
    var body: some View {
        content
            .navigationTitle("Recipe")
            .task {
                await viewModel.search()
            }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading: ProgressView()
        case .empty: ContentUnavailableView {
            Label("We have no recipes for this category", systemImage: "doc.text.magnifyingglass")
        }
        case .success(let meals):
            recipeList(meals)
            
        case .error(let message):
            ContentUnavailableView {
                Label("Something went wrong", systemImage: "wifi.exclamationmark")
            } description: {
                Text(message)
            }
        }
    }
    
    private func recipeList(_ meals: [Meal]) -> some View {
        List(meals) { meal in
            Button {
                goRecipeDetail(meal.id)
            } label: {
                HStack(spacing: 12) {
                    AsyncImage(url: meal.imageURL) { image in
                        image
                        .resizable()
                        .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    
                    Text(meal.name)
                }
            }
            .buttonStyle(.plain)
        }
    }

}

#Preview {
    RecipeListView(
        viewModel: .init(
            repository: RemoteMealRepository(),
            categoryName: ""
        ),
        goRecipeDetails: { _ in }
    )
}
