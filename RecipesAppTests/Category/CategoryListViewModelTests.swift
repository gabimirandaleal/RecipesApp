//
//  CategoryListViewModel.swift
//  RecipesApp
//
//  Created by gabriela.leal on 12/10/26.
//

import Foundation
import Testing
@testable import RecipesApp

@MainActor
struct CategoryListViewModelTests {
    private let flan = MealCategory(id: "1", name: "test", apiName: "test", imageURL: nil, description: "test description")
    
    @Test
    func showsMealsOnSuccess() async {
        let sut = CategoryListViewModel(
            repository: MockCategoryRepository(result: .success([flan])),
            analytics: SpyAnalyticsTracker(),
            translator: ClaudeCategoryTranslator(apiKey: "")
        )
        await sut.searchCategory()
        #expect(sut.state == .success([flan]))
    }
    
    @Test
    func showsEmptyWhenThereAreNoMeals() async {
        let sut = CategoryListViewModel(
            repository: MockCategoryRepository(result: .success([])),
            analytics: SpyAnalyticsTracker(),
            translator: ClaudeCategoryTranslator(apiKey: "")
        )
        await sut.searchCategory()
        #expect(sut.state == .empty)
    }
    
    @Test
    func showsErrorWhenRepositoryFails() async {
        let sut = CategoryListViewModel(
            repository: MockCategoryRepository(result: .failure(URLError(.notConnectedToInternet))),
            analytics: SpyAnalyticsTracker(),
            translator: ClaudeCategoryTranslator(apiKey: ""),
            language: "en"
        )
        await sut.searchCategory()
        #expect(sut.state == .error(String(localized: "Could not fetch the categories. Please try again.")))
    }
    
    @Test
    func trackCategoryTapped() async {
        let spy = SpyAnalyticsTracker()
        let sut = CategoryListViewModel(
            repository: MockCategoryRepository(result: .failure(URLError(.notConnectedToInternet))),
            analytics: spy,
            translator: ClaudeCategoryTranslator(apiKey: "")
        )
        sut.categorySelected(category: "teste")
        #expect(spy.events == [.categorySelected("teste")])
    }
}
