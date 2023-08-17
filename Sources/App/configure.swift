import NIOSSL
import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.sqlite(.file("blog.sqlite")), as: .sqlite)

    app.migrations.add(CreateTodo())
    app.migrations.add(CreateUserSchema())
    app.migrations.add(CreatePostSchema())
    app.migrations.add(AddPasswordFieldToUser())
    app.migrations.add(CreateUserTokens())

    try await app.autoMigrate()
    app.passwords.use(.bcrypt)

    // register routes
    try routes(app)
}
