import Vapor

let drop = Droplet()

let weatherController = WeatherController()
weatherController.addRoutes(drop: drop)

drop.get("current") { request in
    let json = try drop.client.get("https://api.darksky.net/forecast/1fc982716a795567a7239dcf5f061bb1/37.8267,-122.4233",
                                   query: ["exclude":"minutely,daily,alerts,flag"])
    let body = try JSON(bytes: json.body.bytes!)
    
    if let currently = body["currently"], let hourly = body["hourly"] {
        
//        return try drop.view.make("welcome", Node(node: [
//            "temp" : currently["apparentTemperature"],
//            "current-summary" : currently["summary"],
//            "hourly-summary" : hourly["summary"],
//            "icon" : currently["icon"]
//            ]))
        
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
