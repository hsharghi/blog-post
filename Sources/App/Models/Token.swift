import Fluent
import Vapor

final class Token: Model, Content {
    
    static let schema = "user_tokens"
    
    @ID(key: .id)
    var id: UUID?

    @Parent(key: "user_id")
    var user: User

    @Field(key: "token")
    var token: String

    @Field(key: "expires_at")
    var expiresAt: Date
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    public init() { }
    
    public init(id: UUID? = nil, userId: UUID, token: String, expiresAt: Date, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.$user.id = userId
        self.token = token
        self.expiresAt = expiresAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

}
