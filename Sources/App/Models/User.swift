import Fluent
import Vapor

enum Priority {
    case low
    case normal
    case high
}

final class User: Model, Content, Authenticatable {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "username")
    var username: String?
    
    @Field(key: "password")
    var password: String
    
    @Children(for: \.$owner)
    var posts: [Post]
    
    public init() { }

    public init(id: UUID? = nil, name: String, username: String? = nil, password: String) {
        self.id = id
        self.name = name
        self.username = username
        self.password = password
    }
}

extension User {
    struct PublicUser: Content {
        var name: String
        var username: String?
    }
    
    func toPublic() -> PublicUser {
        PublicUser(name: self.name, username: self.username)
    }
}


