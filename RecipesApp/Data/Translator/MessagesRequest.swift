//
//  MessagesRequest.swift
//  RecipesApp
//
//  Created by gabriela.leal on 12/10/26.
//

struct MessagesRequest: Encodable {
    struct Message: Encodable {
        let role: String
        let content: String
    }
    
    let model: String
    let max_tokens: Int
    let system: String
    let messages: [Message]
}
