import Vapor
import HTTP
import Foundation
import PostgreSQLProvider

final class PostController {
    
    func addRoutes(drop: Droplet) {
        drop.group("posts") { group in
            group.post("create", handler: create)
            group.get(handler: index)
            group.post("update", Post.self, handler: update)
            group.post("show", Post.self, handler: show)
            group.post("delete", Post.self, handler: delete)
        }
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        
        guard let content = request.formData?["content"]?.string else {
            throw Abort.badRequest
        }
        
        var mediaurl: String?
        if let fileData = request.formData?["image"]?.part.body {
            let workpath = drop.workDir
            let name = UUID().uuidString + ".png"
            let imageFolder = "Public/images/uploads"
            let saveUrl = URL(fileURLWithPath: workpath).appendingPathComponent(imageFolder, isDirectory: true).appendingPathComponent(name, isDirectory: false)
            
            do {
                let data = Data(bytes: fileData)
                try data.write(to: saveUrl)
                mediaurl = name
            } catch {
                throw Abort.custom(status: .internalServerError, message: "Unable to write image")
            }
        }
        
        var post = Post(createdon: Date().stringForDate(),
                        content: content,
                        mediaurl: mediaurl)
        
        try post.save()
        
        return Response(redirect: "/posts")
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        
        var parametes = [String: Node]()
        if let db = drop.database?.driver as? PostgreSQLDriver {
            let query = try db.raw("Select * from posts order by createdon desc")
            parametes = ["posts": query]
        }
        
        return try drop.view.make("manage", parametes)
    }
    
    func show(request: Request, post: Post) throws -> ResponseRepresentable {
        return post
    }
    
    func update(request: Request, post: Post) throws -> ResponseRepresentable {
            let new = try request.post()
            var post = post
            post.createdon = new.createdon
            post.content = new.content
            post.mediaurl = new.mediaurl
        
            try post.save()
            return post
    }
    
    func delete(request: Request, post: Post) throws -> ResponseRepresentable {
        try post.delete()
        
        return Response(redirect: "/posts")
    }
    
    func deleteAll(request: Request) throws -> ResponseRepresentable {
        let posts = try Post.all()
        
        try posts.forEach { (post) in
            try post.delete()
        }
        return "Delete all"
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

extension Date {
    func stringForDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy 'at' hh:mm"
        return formatter.string(from: self)
    }
}
