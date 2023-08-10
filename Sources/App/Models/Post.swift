import Fluent
import Vapor

public enum PostStatus: String, CaseIterable, Content {
    case draft = "draft"
    case published = "published"
}

final class Post: Model, Content {
    
    static let schema = "posts"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "content")
    var content: String
    
    @Enum(key: "status")
    var status: PostStatus
    
    @Parent(key: "user_id")
    var owner: User
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?
    
    init() { }
    
    public init(id: UUID? = nil, title: String, content: String, userId: UUID, status: PostStatus = .draft, createdAt: Date? = nil, updatedAt: Date? = nil, deletedAt: Date? = nil) {
        self.id = id
        self.title = title
        self.content = content
        self.status = status
        self.$owner.id = userId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
        
    }

}
