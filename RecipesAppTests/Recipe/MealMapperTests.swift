//
//  MealMapper.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

import Foundation
import Testing
@testable import RecipesApp

struct MealMapperTests {
    private func decode(_ json: String) throws -> MealDTO {
        try JSONDecoder().decode(MealDTO.self, from: Data(json.utf8))
    }
    
    @Test
    func returnNilWhenIdIsMissing() throws {
        let dto = try decode("""
        { "strMeal": "Flan" }
        """)
        #expect(MealMapper.map(dto) == nil)
    }
    
    @Test
    func returnNilWhenNameIsMissing() throws {
        let dto = try decode("""
        { "idMeal": "1" }
        """)
        #expect(MealMapper.map(dto) == nil)
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
        let meal = try #require(MealMapper.map(dto))
        print("aqui meal: \(meal)")
        #expect(meal.area == "Brazil")
    }
}
