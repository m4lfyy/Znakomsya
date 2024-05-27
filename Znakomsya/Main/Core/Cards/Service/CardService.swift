//
//  CardService.swift
//  Znakomsya
//
//  Created by Данил Юсупов on 26.05.2024.
//

import Foundation

struct CardService {
    
    func fetchCardModels() async throws -> [CardModel] {
        let users = MockData.users
        return users.map({ CardModel(user: $0) })
    }
}
