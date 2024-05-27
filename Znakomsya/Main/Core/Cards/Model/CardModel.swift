//
//  CardModel.swift
//  Znakomsya
//
//  Created by Данил Юсупов on 26.05.2024.
//

import Foundation

struct CardModel {
    let user: UserInfo
}

extension CardModel: Identifiable, Hashable {
    var id: String { return user.id }
}
