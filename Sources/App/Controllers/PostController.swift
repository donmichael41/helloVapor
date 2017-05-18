import Vapor
import HTTP
import Foundation

final class PostController {
    
    
    
    func create(request: Request) throws -> ResponseRepresentable {
        var post = try request.post()
        try post.save()
        
        return post
    }
}

extension Request {
    func post() throws -> Post {
        guard let json = json else {
            throw Abort.badRequest
        }
        return try Post(node: json)
    }
}
