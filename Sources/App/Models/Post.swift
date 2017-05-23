import Vapor
import Fluent
import Foundation
import FluentProvider

final class Post: Model {
    var id: Node?
    var exists: Bool = false
    
    var createdon: String
    var content: String
    var mediaurl: String?
    
    let storage = Storage()
    
    init(row: Row) throws {
        createdon = try row.get("createdon")
        content = try row.get("content")
        mediaurl = try row.get("mediaurl")
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("id", id)
        try row.set("createdon", createdon)
        try row.set("content", content)
        try row.set("mediaurl", mediaurl)
        return row
    }
    
    init(createdon: String, content: String, mediaurl: String?) {
        self.id = nil
        self.createdon = createdon
        self.content = content
        self.mediaurl = mediaurl
    }
}

extension Post: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { post in
            post.id()
            post.string("createdon")
            post.string("content")
            post.string("mediaurl")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Post: ResponseRepresentable {
    func makeResponse() throws -> Response {
        var json = JSON()
        try json.set("id", id)
        try json.set("content", content)
        try json.set("created-at", createdon)
        try json.set("mediaurl", mediaurl)
        return try json.makeResponse()
    }
}
