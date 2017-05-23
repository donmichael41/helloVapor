import Vapor
import Turnstile
import TurnstileCrypto
import FluentProvider
//
final class User: Model {
    var id: Node?
    var exists: Bool = false
    
    let storage = Storage()
    var name: String
    var email: String
    var password: String
    var api_key_id = URandom().secureToken
    var api_key_secret = URandom().secureToken
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", name)
        try row.set("email", email)
        try row.set("pasword", password)
        try row.set("api_key_id", api_key_id)
        try row.set("api_ley-secret", api_key_secret)
        
        return row
    }
    
    init(row: Row) throws {
        name = try row.get("name")
        email = try row.get("email")
        password = try row.get("password")
        api_key_id = try row.get("api_key_id")
        api_key_secret = try row.get("api_key_secret")
    }
    
}
enum Error_: Error {
    case userNotFound
    case registerNotSupported
    case unsupportedCredential
}

extension User: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { post in
            post.id()
            post.string("name")
            post.string("email")
            post.string("password")
            post.string("api_key_id")
            post.string("api_key_secret")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension User: ResponseRepresentable {
    func makeResponse() throws -> Response {
        var json = JSON()
        try json.set("name", name)
        try json.set("email", email)
        try json.set("password", password)
        try json.set("api_key_secrect", api_key_secret)
        try json.set("api_key_id", api_key_id)
        
        return try json.makeResponse()
    }
}
