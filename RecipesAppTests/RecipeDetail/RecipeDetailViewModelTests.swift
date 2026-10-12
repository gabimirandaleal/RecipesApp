//
//  RecipeDetailViewModel.swift
//  RecipesApp
//
//  Created by gabriela.leal on 12/10/26.
//

import Foundation
import Testing
@testable import RecipesApp

@MainActor
struct RecipesDetailsViewModelTests {
    private let flan = MealDetail(
        id: "1",
        name: "teste",
        imageURL: nil,
        ingredients: [
            Ingredient(name: "teste", measure: "teste 2"),
            Ingredient(name: "teste2", measure: "teste 2"),
        ],
        area: nil,
        category: "Brazil",
        videoURL: nil,
        instructions: "",
        tags: [],
        sourceURL: nil
    )
    
    @Test
    func showsMealsOnSuccess() async {
        let sut = RecipeDetailViewModel(repository: MockMealDetailsRepository(result: .success([flan])), id: "teste", analytics: SpyAnalyticsTracker())
        await sut.search()
        #expect(sut.state == .success([flan]))
    }
    
    @Test
    func showsEmptyWhenThereAreNoMeals() async {
        let sut = RecipeDetailViewModel(repository: MockMealDetailsRepository(result: .success([])), id: "teste", analytics: SpyAnalyticsTracker())
        await sut.search()
        #expect(sut.state == .empty)
    }
    
    @Test
    func showsErrorWhenRepositoryFails() async {
        let sut = RecipeDetailViewModel(repository: MockMealDetailsRepository(result: .failure(URLError(.notConnectedToInternet))), id: "teste", analytics: SpyAnalyticsTracker())
        await sut.search()
        #expect(sut.state == .error("Could not fetch this recipe. Please try again."))
    }
    
    @Test
    func tracksYoutubeTap() async {
        let spy = SpyAnalyticsTracker()
        let sut = RecipeDetailViewModel(repository: MockMealDetailsRepository(result: .success([flan])), id: "teste", analytics: spy)
        sut.youtubeLinkTapped()
        #expect(spy.events == [.youtubeLinkTapped("teste")])
    }
    
    @Test
    func tracksRecipeOpened() async {
        let spy = SpyAnalyticsTracker()
        let sut = RecipeDetailViewModel(repository: MockMealDetailsRepository(result: .success([flan])), id: "teste", analytics: spy)
        sut.screenAppered()
        #expect(spy.events == [.recipeDetailViewed("teste")])
    }
}
