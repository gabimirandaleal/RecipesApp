//
//  ClaudeRecipeTranslator.swift
//  RecipesApp
//
//  Created by gabriela.leal on 12/10/26.
//

import Foundation

struct ClaudeRecipeTranslator: RecipeTranslator {
    let apiKey: String
    
    func translate(_ recipe: MealDetail, to language: String) async throws -> MealDetail {

        let payload = TranslationPayload(
            ingredients: recipe.ingredients.map { .init(name: $0.name, measure: $0.measure) },
            area: recipe.area,
            category: recipe.category,
            instructions: recipe.instructions,
            tags: recipe.tags
        )
        
        let payloadJSON = String(decoding: try JSONEncoder().encode(payload), as: UTF8.self)
        
        var request = URLRequest(url: URL(string: "https://api.anthropic.com/v1/messages")!)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.httpBody = try JSONEncoder().encode(MessagesRequest(
            model: "claude-haiku-5-5",
            max_tokens: 4096,
            system: """
                You are a professional culinary translator. Translate the recipe JSON into the language \
                with code \(language), writing the way a native home cook would read it in a cookbook.

                Ingredients:
                - Translate each "name" together with its "measure", so the pair reads naturally as one line.
                - Make the name agree with the quantity: use the plural when there is more than one \
                (e.g. pt-BR: measure "2", name "Burger Buns" → measure "2", name "pães de hambúrguer").
                - Use local unit names without changing the amounts \
                (e.g. pt-BR: "1 cup" → "1 xícara", "2 tbs" → "2 colheres (sopa)", "1/2 tsp" → "½ colher (chá)", "pinch" → "1 pitada").
                - Use the ingredient's common local name, not a literal translation \
                (e.g. pt-BR: "Plain Flour" → "farinha de trigo", "Spring Onions" → "cebolinha").

                Instructions: keep every step and its order; write fluent, natural sentences, without adding or removing steps.

                Reply ONLY with JSON in exactly the same structure you receive, with the same number of \
                ingredients in the same order, no extra text.
                """,
            messages: [.init(role: "user", content: payloadJSON)]
            )
        )
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let text = try JSONDecoder().decode(MessagesResponse.self, from: data)
            .content
            .filter { $0.type == "text" }
            .compactMap(\.text)
            .joined()

        let translated = try JSONDecoder().decode(TranslationPayload.self, from: Data(text.utf8))
        
        return MealDetail(
            id: recipe.id,
            name: recipe.name,
            imageURL: recipe.imageURL,
            ingredients: translated.ingredients.map { Ingredient(name: $0.name, measure: $0.measure) },
            area: translated.area,
            category: translated.category,
            videoURL: recipe.videoURL,
            instructions: translated.instructions,
            tags: translated.tags,
            sourceURL: recipe.sourceURL
        )
    }
    
    private struct TranslationPayload: Codable {
        struct Item: Codable {
            let name: String
            let measure: String?
        }

        let ingredients: [Item]
        let area: String?
        let category: String?
        let instructions: String
        let tags: [String]
    }
}
