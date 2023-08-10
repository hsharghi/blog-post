import Fluent
import Vapor

struct PostController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let postRoutes = routes.grouped("post")
        postRoutes.post("", use: createPost)
        postRoutes.get(":userId", use: listPosts)
        postRoutes.delete(":postId", use: deletePost)
        //
        //        let todos = routes.grouped("todos")
        //        todos.get(use: index)
        //        todos.post(use: create)
        //        todos.group(":todoID") { todo in
        //            todo.delete(use: delete)
        //        }
    }
    
    struct CreatePostRequest: Content {
        var title: String
        var content: String
        var userId: UUID
    }
    
    struct ListPostRequest: Content {
        var userId: UUID
    }
    
    func createPost(req: Request) async throws -> Post {
        let data = try req.content.decode(CreatePostRequest.self)
        let post = Post(title: data.title, content: data.content, userId: data.userId)
        try await post.save(on: req.db)

        return post
    }
    
    func listPosts_old(req: Request) async throws -> [Post] {
        if let idString = req.parameters.get("userId"), let uuid = UUID(uuidString: idString) {
            if let user = try await User.find(uuid, on: req.db) {
                try await user.$posts.load(on: req.db)
                return user.posts
            } else {
                throw Abort(.notFound)
            }
        } else {
            throw Abort(.badRequest)
        }
    }

    func listPosts(req: Request) async throws -> [Post] {
        guard let idString = req.parameters.get("userId"), let uuid = UUID(uuidString: idString) else {
            throw Abort(.badRequest)
        }
        guard let user = try await User.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }
        try await user.$posts.load(on: req.db)
        return user.posts
    }
    
    func deletePost(req: Request) async throws -> Response {
        guard let idString = req.parameters.get("postId"), let uuid = UUID(uuidString: idString) else {
            throw Abort(.badRequest)
        }
        guard let post = try await Post.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }
        try await post.delete(on: req.db)
        return .init(status: .ok)
    }

}
