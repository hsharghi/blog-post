import Fluent

struct CreatePostSchema: AsyncMigration {
    func prepare(on database: Database) async throws {
        
        do {
            try await database.enum("post_status").delete()
        } catch { }
        
        var enumBuilder = database.enum("post_status")
        for type in PostStatus.allCases {
            enumBuilder = enumBuilder.case(type.rawValue)
        }
        let accountType = try await enumBuilder.create()


        
        try await database.schema(Post.schema)
            .id()
            .field("title", .string, .required)
            .field("content", .string, .required)
            .field("post_status", accountType, .required)
            .field("user_id", .uuid, .required, .references(User.schema, "id"))
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .field("deleted_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Post.schema).delete()
    }
}
