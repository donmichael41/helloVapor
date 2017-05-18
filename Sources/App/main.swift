import Vapor
import HTTP
import VaporPostgreSQL

let drop = Droplet()
try drop.addProvider(VaporPostgreSQL.Provider)

//try drop.addProvider(VaporPostgreSQL.Provider.self)

let weatherController = WeatherController()
weatherController.addRoutes(drop: drop)

drop.client = FoundationClient.self

drop.get("version") { _ in
    if let db = drop.database?.driver as? PostgreSQLDriver {
        let version = try db.raw("SELECT version()")
        
        return try JSON(node: version)
    }
    
    return "No db"
}

drop.get("loaderio-822a5198e007a78606027c6f7d2f3624") { _ in
        return "loaderio-822a5198e007a78606027c6f7d2f3624"
}

drop.get("current") { request in
    let json = try drop.client.get("https://api.darksky.net/forecast/1fc982716a795567a7239dcf5f061bb1/37.8267,-122.4233",
                                   query: ["exclude":"minutely,daily,alerts,flag"])
    let body = try JSON(bytes: json.body.bytes!)
    
    if let currently = body["currently"], let hourly = body["hourly"] {
        
        return try JSON(node: Node(node: [
            "times": TimeKeeper().systemTime(),
            "temp" : currently["apparentTemperature"],
            "current-summary" : currently["summary"],
            "hourly-summary" : hourly["summary"],
            "icon" : currently["icon"]
            ]))
    }
    
    return "Some thing went wrong"
    
}

drop.run()
