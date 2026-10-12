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
    
    func makeSut(
        repository: MockMealDetailsRepository,
        analytics: SpyAnalyticsTracker,
        experiment: LocalExperimentProvider
    ) -> RecipeDetailViewModel {
        .init(repository: repository, id: "teste", analytics: SpyAnalyticsTracker(), experiment: LocalExperimentProvider())
    }
    
    @Test
    func showsMealsOnSuccess() async {
        let spy = SpyAnalyticsTracker()
        let experiment = LocalExperimentProvider()
        let sut = makeSut(repository: MockMealDetailsRepository(result: .success([flan])), analytics: spy, experiment: experiment)
        await sut.search()
        #expect(sut.state == .success([flan]))
    }
    
    @Test
    func showsEmptyWhenThereAreNoMeals() async {
        let spy = SpyAnalyticsTracker()
        let experiment = LocalExperimentProvider()
        let sut = makeSut(repository: MockMealDetailsRepository(result: .success([])), analytics: spy, experiment: experiment)
        await sut.search()
        #expect(sut.state == .empty)
    }
    
    @Test
    func showsErrorWhenRepositoryFails() async {
        let spy = SpyAnalyticsTracker()
        let experiment = LocalExperimentProvider()
        let sut = makeSut(repository: MockMealDetailsRepository(result: .failure(URLError(.notConnectedToInternet))), analytics: spy, experiment: experiment)
        await sut.search()
        #expect(sut.state == .error("Could not fetch this recipe. Please try again."))
    }
    
    @Test
    func tracksYoutubeTap() async {
        let experiment = LocalExperimentProvider()
        let spy = SpyAnalyticsTracker()
        let sut = makeSut(repository: MockMealDetailsRepository(result: .success([flan])), analytics: spy, experiment: experiment)
        sut.youtubeLinkTapped()
        #expect(spy.events == [.youtubeLinkTapped("teste")])
    }
    
    @Test
    func tracksRecipeOpened() async {
        let experiment = LocalExperimentProvider()
        let spy = SpyAnalyticsTracker()
        let sut = makeSut(repository: MockMealDetailsRepository(result: .success([flan])), analytics: spy, experiment: experiment)
        sut.screenAppered()
        #expect(spy.events == [.recipeDetailViewed("teste")])
    }
}
