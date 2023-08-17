import Fluent

struct CreateUserTokens: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Token.schema)
            .id()
            .field("user_id", .uuid, .required)
            .field("token", .string, .required)
            .field("expires_at", .datetime, .required)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .unique(on: "user_id")
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Token.schema).delete()
    }
}
