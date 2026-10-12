//
//  MessagesResponse.swift
//  RecipesApp
//
//  Created by gabriela.leal on 12/10/26.
//

struct MessagesResponse: Decodable {
    struct Block: Decodable {
        let text: String?
        let type: String
    }
    
    let content: [Block]
    let stop_reason: String?
}
