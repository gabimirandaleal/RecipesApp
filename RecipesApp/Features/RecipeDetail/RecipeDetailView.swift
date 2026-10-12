//
//  RecipeDetailView.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

import SwiftUI

struct RecipeDetailView: View {
    @State private var viewModel: RecipeDetailViewModel
    @Environment(\.openURL) private var openURL
    
    init(viewModel: RecipeDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        content
            .navigationTitle("Recipe Details")
            .task {
                await viewModel.loadIfNeeded()
            }
            .onAppear {
                viewModel.screenAppered()
            }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading: ProgressView()
        case .empty: ContentUnavailableView {
            Label("We have no recipes", systemImage: "doc.text.magnifyingglass")
        }
        case .success(let meal):
            recipeList(meal)
            
        case .error(let message):
            ContentUnavailableView {
                Label("Something went wrong", systemImage: "wifi.exclamationmark")
            } description: {
                Text(message)
            } actions: {
                Button("Try again") {
                    Task {
                        await viewModel.search()
                    }
                }
            }
        }
    }
    
    private func recipeList(_ meals: [MealDetail]) -> some View {
        List(meals) { meal in
            VStack(alignment: .leading) {
                if viewModel.showsYoutubeOnTop, let link = meal.videoURL {
                    makeButton(link: link)
                }
                VStack(alignment: .center, spacing: 12) {
                    AsyncImage(url: meal.imageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    Text(meal.name)
                        .padding(.bottom, 10)
                }
                if let area = meal.area, !area.isEmpty {
                    Text("Created in: \(area)")
                        .padding(.bottom, 5)
                }
                if !meal.instructions.isEmpty {
                    Text("Description: \(meal.instructions)")
                        .padding(.bottom, 5)
                }
                if !meal.ingredients.isEmpty {
                    ForEach(Array(meal.ingredients.enumerated()), id: \.offset) { _, ingredient in
                        HStack {
                            if let measure = ingredient.measure, !measure.isEmpty {
                                Text("\(measure) -")
                                    .foregroundColor(.secondary)
                            }
                            Text(ingredient.name)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            if !viewModel.showsYoutubeOnTop, let link = meal.videoURL {
                makeButton(link: link)
            }
        }
    }
    
    private func makeButton(link: URL) -> some View {
        Button {
            viewModel.youtubeLinkTapped()
            openURL(link)
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "play.fill")
                Text("Watch on YouTube")
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.red)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal)
    }

}

#Preview {
    RecipeDetailView(
        viewModel: .init(
            repository: RemoteMealDetailRepository(),
            id: "",
            analytics: ConsoleAnalyticsTracker(),
            experiment: LocalExperimentProvider(),
            translator: ClaudeRecipeTranslator(apiKey: "")
        )
    )
}
