import Vapor
import HTTP

final class WeatherController {
    
    func addRoutes(drop: Droplet) {

        drop.group("weather") { group in
            group.get("sunny", handler: sunny)
            group.get("cloudy", handler: cloudy)
            group.get("testFromMobile", handler: testFromMobile)
            group.get(String.self, handler: argument)
            group.post("post", handler: post)
        }
        
    }
    var connt = 0
    func testFromMobile(_ request: Request) throws -> ResponseRepresentable {
        return try JSON(node: ["message": "It's \(TimeKeeper().systemTime())"])
    }
    
    func sunny(_ request: Request) throws -> ResponseRepresentable {
        return "The sun is shining"
    }
    
    func cloudy(_ request: Request) throws -> ResponseRepresentable {
        return "It's cloudy today"
    }
    
    func argument(_ request: Request, weather: String) throws -> ResponseRepresentable {
        
        return try JSON(node: ["message": "It's \(weather) today!"])
    }

    func post(_ request: Request) throws -> ResponseRepresentable {
        
        guard let city = request.data["city"]?.string else {
            throw Abort.badRequest
        }
        return try JSON(node: [ "message": "It's sunny in \(city) today"])
    }

}