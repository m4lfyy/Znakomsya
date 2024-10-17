import Foundation

struct CardModel {
    let user: UserInfo
}

extension CardModel: Identifiable, Hashable {
    var id: String { return user.id }
}
