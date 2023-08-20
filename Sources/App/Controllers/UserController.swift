import Fluent
import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let userRoutes = routes.grouped("user")
        userRoutes.post("", use: createUser)
        userRoutes.post("login", use: loginUser)
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
        var password: String
    }
    
    func createUser(req: Request) async throws -> User.PublicUser {
        let data = try req.content.decode(CreateUserRequest.self)
        let usersWithSameNameCount = try await User.query(on: req.db)
            .filter(\.$name == data.name)
            .count()
        
        guard usersWithSameNameCount == 0 else {
            throw AppError.duplicateName
        }
        
        let user = User(name: data.name,
                        username: data.username,
                        password: try req.password.hash(data.password))
        try await user.save(on: req.db)
        
        return user.toPublic()
    }
    
    struct LoginUseRequest: Content {
        var name: String
        var password: String
    }
    
    struct TokenResponse: Content {
        var token: String
    }

    func loginUser(req: Request) async throws -> TokenResponse {
        let data = try req.content.decode(LoginUseRequest.self)
        let foundUser = try await User.query(on: req.db)
            .filter(\.$name == data.name)
            .first()
        guard let foundUser else {
            throw AppError.invalidUserPassword
        }
        guard try req.password.verify(data.password, created: foundUser.password) else {
            throw AppError.invalidUserPassword
        }
        
        let tokenString = try req.password.hash(String(Int.random()))
        let tokenData = try await Token.query(on: req.db)
            .filter(\.$user.$id == foundUser.requireID())
            .first()
        if let tokenData {
            tokenData.token = tokenString
            tokenData.expiresAt = Date().addingTimeInterval(60 * 60)
            try await tokenData.update(on: req.db)
        } else {
            let token = Token(userId: try foundUser.requireID(),
                              token: tokenString,
                              expiresAt: Date().addingTimeInterval(60 * 60))
            try await token.save(on: req.db)
        }
        return TokenResponse(token: tokenString)
    }
    
    func listUsers(req: Request) async throws -> [User] {
        try await User.query(on: req.db).all()
    }
    
}
