//
//  ClaudeCategoryTranslator.swift
//  RecipesApp
//
//  Created by gabriela.leal on 12/10/26.
//

import Foundation

struct ClaudeCategoryTranslator: CategoryTranslator {
    let apiKey: String
    
    func translate(_ categories: [MealCategory], to language: String) async throws -> [MealCategory] {
        let payload = categories.map {
            TranslationPayload(
                name: $0.name
            )
        }
        
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
                You translate cooking recipes into the language with code \(language). \
                        Use natural cooking terms and local measurement names. \
                        Reply ONLY with JSON in exactly the same structure you receive, no extra text.
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
        
        let translated = try JSONDecoder().decode([TranslationPayload].self, from: Data(text.utf8))
        
        return zip(categories, translated).map {
            MealCategory(
                id: $0.id,
                name: $1.name,
                imageURL: $0.imageURL,
                description: $0.description
            )
        }
    }
    
    private struct TranslationPayload: Codable {
        let name: String
    }
}

