//
//  CategoryList.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

import SwiftUI

struct CategoryList: View {
    @State private var viewModel: CategoryListViewModel
    private let goRecipeList: (_ id: String) -> Void
    
    init(viewModel: CategoryListViewModel, goRecipeList: @escaping (_ id: String) -> Void) {
        self.viewModel = viewModel
        self.goRecipeList = goRecipeList
    }
    
    var body: some View {
        content
            .navigationTitle("Categories")
            .task {
                try? await Task.sleep(for: .milliseconds(400))
                guard !Task.isCancelled else { return }
                await viewModel.loadIfNeeded()
            }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading: ProgressView()
        case .empty: ContentUnavailableView {
            Label("No categories available.", systemImage: "exclamationmark.circle")
        }
        case .success(let categories):
            List(categories) { category in
                Button {
                    viewModel.categorySelected(category: category.apiName)
                    goRecipeList(category.apiName)
                } label: {
                    HStack(spacing: 12) {
                        AsyncImage(url: category.imageURL) { image in
                            image
                            .resizable()
                            .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())

                        Text(category.name)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.tertiary)
                    }
                    .contentShape(Rectangle())
                    .foregroundStyle(.primary)
                }
            }

        case .error(let message):
            ContentUnavailableView {
                Label("Something went wrong", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button("Try again") {
                    Task {
                        await viewModel.searchCategory()
                    }
                }
            }
        }
    }
}

#Preview {
    CategoryList(
        viewModel: .init(
            repository: RemoteMealCategoryRepository(),
            analytics: ConsoleAnalyticsTracker(),
            translator: ClaudeCategoryTranslator(apiKey: "")
        ),
        goRecipeList: { _ in }
    )
}
