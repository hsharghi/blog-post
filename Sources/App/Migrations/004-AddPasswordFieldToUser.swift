import Fluent

struct AddPasswordFieldToUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(User.schema)
            .field("password", .string, .required, .sql(.default("password")))
            .update()
    }

    func revert(on database: Database) async throws {
        try await database.schema(User.schema)
            .field("password", .string, .required)
            .delete()
    }
}
