//
//  MealDetailsMapperTests.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

import Foundation
import Testing
@testable import RecipesApp

struct MealDetailsMapperTests {
    private func decode(_ json: String) throws -> MealDetailDTO {
        try JSONDecoder().decode(MealDetailDTO.self, from: Data(json.utf8))
    }
    
    @Test
    func returnNilWhenIdIsMissing() throws {
        let dto = try decode("""
        { "strMeal": "Flan" }
        """)
        #expect(MealDetailMapper.map(dto) == nil)
    }
    
    @Test
    func returnNilWhenNameIsMissing() throws {
        let dto = try decode("""
        { "idMeal": "1" }
        """)
        #expect(MealDetailMapper.map(dto) == nil)
    }
    
    @Test
    func skipsEmptyIngredientAndKeepsPairsAligned() throws {
        let dto = try decode("""
            {
            "idMeal": "1",
            "strMeal": "teste",
            "strIngredient1": "Sugar",
            "strMeasure1": "100g",
            "strIngredient2": "",
            "strMeasure2": "2 cups",
            "strIngredient3": "Milk",
            "strMeasure3": "350g",
            }
            """)
        let meal = try #require(MealDetailMapper.map(dto))
        #expect(
            meal.ingredients == [
                Ingredient(name: "Sugar", measure: "100g"),
                Ingredient(name: "Milk", measure: "350g")
            ]
        )
    }
    
    @Test
    func keepsIngredientWithNilMeasureWhenMeasureIsEmpty() throws {
        let dto = try decode("""
            {
            "idMeal": "1",
            "strMeal": "teste",
            "strIngredient1": "Sugar",
            "strMeasure1": "",
            }
            """)
        let meal = try #require(MealDetailMapper.map(dto))
        #expect(
            meal.ingredients == [
                Ingredient(name: "Sugar", measure: nil)
            ]
        )
    }
    
    @Test
    func doesNotIngredientsWhenNumberingHasGaps() throws {
        let dto = try decode("""
            {
            "idMeal": "1",
            "strMeal": "teste",
            "strIngredient1": "Sugar",
            "strMeasure1": "100g",
            "strIngredient3": "Milk",
            "strMeasure3": "350g",
            }
            """)
        let meal = try #require(MealDetailMapper.map(dto))
        #expect(
            meal.ingredients == [
                Ingredient(name: "Sugar", measure: "100g"),
                Ingredient(name: "Milk", measure: "350g")

            ]
        )
    }
    
    @Test
    func usesCountryWhenAreaIsNull() throws {
        let dto = try decode("""
            {
            "idMeal": "1",
            "strMeal": "teste",
            "strArea": null,
            "strCountry": "Brazil",
            }
            """)
        let meal = try #require(MealDetailMapper.map(dto))
        print("aqui meal: \(meal)")
        #expect(meal.area == "Brazil")
    }
}
