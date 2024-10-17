import Foundation

struct MockData {
    
    static let users: [UserInfo] = [
        .init(
            id: NSUUID().uuidString,
            fullname: "Danil",
            age: 20,
            profileImageURLs: ["test1", "test2", "test"]
        ),
        .init(
            id: NSUUID().uuidString,
            fullname: "Tim",
            age: 20,
            profileImageURLs: ["test3"]
        ),
        .init(
            id: NSUUID().uuidString,
            fullname: "Dima",
            age: 20,
            profileImageURLs: ["test4", "test5"]
        )
    ]
    
}
