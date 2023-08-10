import Fluent
import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let userRoutes = routes.grouped("user")
        userRoutes.post("", use: createUser)
        userRoutes.get("", use: listUsers)
        //
        //        let todos = routes.grouped("todos")
        //        todos.get(use: index)
        //        todos.post(use: create)
        //        todos.group(":todoID") { todo in
        //            todo.delete(use: delete)
        //        }
    }
    
    struct CreateUserRequest: Content {
        var name: String
        var username: String?
    }
    
    func createUser(req: Request) async throws -> User {
        let data = try req.content.decode(CreateUserRequest.self)
        let user = User(name: data.name, username: data.username)
        try await user.save(on: req.db)

        return user
    }
    
    func listUsers(req: Request) async throws -> [User] {
        try await User.query(on: req.db).all()
    }

}
