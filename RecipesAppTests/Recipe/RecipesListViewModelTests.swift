//
//  RecipesListViewModel.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

import Foundation
import Testing
@testable import RecipesApp

@MainActor
struct RecipesListViewModelTests {
    private let flan = Meal(id: "1", name: "Flan", imageURL: nil, area: nil)
    
    @Test
    func showsMealsOnSuccess() async {
        let sut = RecipeListViewModel(repository: MockMealRepository(result: .success([flan])), categoryName: "teste")
        await sut.search()
        #expect(sut.state == .success([flan]))
    }
    
    @Test
    func showsEmptyWhenThereAreNoMeals() async {
        let sut = RecipeListViewModel(repository: MockMealRepository(result: .success([])), categoryName: "teste")
        await sut.search()
        #expect(sut.state == .empty)
    }
    
    @Test
    func showsErrorWhenRepositoryFails() async {
        let sut = RecipeListViewModel(repository: MockMealRepository(result: .failure(URLError(.notConnectedToInternet))), categoryName: "teste")
        await sut.search()
        #expect(sut.state == .error(String(localized: "Could not fetch the recipes for this category. Please try again.")))
    }
}
