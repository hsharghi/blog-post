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

    try app.register(collection: TodoController())
}
