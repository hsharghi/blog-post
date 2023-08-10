import Fluent
import Vapor

enum Priority {
    case low
    case normal
    case high
}

final class User: Model, Content {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "username")
    var username: String?
    
    @Children(for: \.$owner)
    var posts: [Post]
    
    public init() { }

    public init(id: UUID? = nil, name: String, username: String? = nil) {
        self.id = id
        self.name = name
        self.username = username
    }
}
