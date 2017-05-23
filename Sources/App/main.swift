import Vapor
import HTTP
import PostgreSQLProvider

let drop = try Droplet()

try drop.addProvider(VaporPostgreSQL.Provider)
drop.preparations += Post.self

let postController = PostController()
postController.addRoutes(drop: drop)

let currentController = CurrentController(drop: drop)

drop.get("version") { _ in
    if let db = drop.database?.driver as? PostgreSQLDriver {
        let version = try db.raw("SELECT version()")
        
        return try JSON(node: version)
    }
    
    return "No db"
}


try drop.run()
