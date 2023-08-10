import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    app.get("hello", ":name") { req async -> String in
        if let name = req.parameters.get("name") {
            return "Hello \(name)"
        }
        return "Unknown!"
    }

    app.get("produt", "image", ":imageId", "edit") { req async -> String in 
        return ""
    }

    try app.register(collection: TodoController())
    try app.register(collection: UserController())
    try app.register(collection: PostController())
}
