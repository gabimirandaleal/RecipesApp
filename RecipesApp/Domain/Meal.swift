//
//  Meal.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

import Foundation

struct Meal: Hashable, Sendable, Identifiable {
    let id: String
    let name: String
    let imageURL: URL?
    let area: String?
}
