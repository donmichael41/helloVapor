import Vapor
import Fluent
import Foundation

final class Post: Model {
    var id: Node?
    var exists: Bool = false
    
    var createdon: String
    var content: String
    var mediaurl: String
    
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        createdon = try node.extract("createdon")
        content = try node.extract("content")
        mediaurl = try node.extract("mediaurl")
    }
    
    init(createdon: String, content: String, mediaurl: String) {
        self.id = nil
        self.createdon = createdon
        self.content = content
        self.mediaurl = mediaurl
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
                "id": id,
                "createdon": createdon,
                "content": content,
                "mediaurl": mediaurl
            ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("posts") { post in
            post.id()
            post.string("createdon")
            post.string("content")
            post.string("mediaurl")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("posts")
    }
}


