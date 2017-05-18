import Vapor
import HTTP
import Foundation

final class PostController {
    
    func addRoutes(drop: Droplet) {
        drop.group("posts") { group in
            group.post("create", handler: create)
            group.post("/",handler: index)
        }
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        var post = try request.post()
        try post.save()
        
        return post
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try JSON(node:
            Post.all().makeNode()
        )
    }
    
    func show(request: Request, post: Post) throws -> ResponseRepresentable {
        return post
    }
    
//    func update(request: Request, post: Post) throws -> ResponseRepresentable {
//        
//    }
}

extension Request {
    func post() throws -> Post {
        guard let json = json else {
            throw Abort.badRequest
        }
        return try Post(node: json)
    }
}
