import Fluent

struct CreatePostSchema: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Post.schema)
            .id()
            .field("title", .string, .required)
            .field("content", .string, .required)
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
