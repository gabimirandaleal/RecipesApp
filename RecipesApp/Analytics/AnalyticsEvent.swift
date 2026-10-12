//
//  AnalyticsEvent.swift
//  RecipesApp
//
//  Created by gabriela.leal on 12/10/26.
//

enum AnalyticsEvent: Equatable, Sendable {
    case categorySelected(_ category: String)
    case recipeDetailViewed(_ recipeId: String)
    case youtubeLinkTapped(_ recipeId: String)
    
    var name: String {
        switch self {
        case .categorySelected:
            return "category_elected"
        case .recipeDetailViewed:
            return "recipe_detail_viewed"
        case .youtubeLinkTapped:
            return "youTube_link_tapped"
        }
    }
    
    var properties: [String: String] {
        switch self {
        case let .categorySelected(category):
            return ["category": category]
        case let .recipeDetailViewed(recipeId):
            return ["recipe_id": recipeId]
        case let .youtubeLinkTapped(recipeId):
            return ["recipe_id": recipeId]
        }
    }
}
