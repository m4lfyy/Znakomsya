//
//  User.swift
//  Znakomsya
//
//  Created by Данил Юсупов on 26.05.2024.
//

import Foundation

struct UserInfo: Identifiable, Hashable {
    let id: String
    let fullname: String
    var age: Int
    var profileImageURLs: [String]
}
