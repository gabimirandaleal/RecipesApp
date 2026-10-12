//
//  RouterTests.swift
//  RecipesApp
//
//  Created by gabriela.leal on 12/10/26.
//

import Testing
@testable import RecipesApp

@MainActor
struct RouterTests {
    @Test
    func startWithEmptyPath() {
        let sut = Router()
        #expect(sut.path.isEmpty)
    }
    
    @Test
    func showListPushesRecipeListRoute() {
        let sut = Router()
        sut.showList(of: "teste")
        #expect(sut.path == [.recipeList(id: "teste")])
    }
    
    @Test
    func showDetailStackOnTopOfList() {
        let sut = Router()
        sut.showDetail(of: "teste")
        #expect(sut.path == [.recipeDetail(id: "teste")])
    }
}
