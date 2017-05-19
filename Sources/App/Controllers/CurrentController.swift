//
//  CurrentController.swift
//  hello
//
//  Created by Hung Nguyen on 5/19/17.
//
//

import Foundation
import HTTP
import Vapor

final class CurrentController {
    
    var drop: Droplet
    
    init(drop: Droplet) {
        self.drop = drop
        drop.client = FoundationClient.self
    }
    
    func addRoutes() {        
        drop.group("weather") { group in
            group.get("current", handler: current)
            group.get("sunny", handler: sunny)
            group.get("cloudy", handler: cloudy)
            group.get(String.self, handler: argument)
            group.post("post", handler: post)
        }
    }
    
    func current(request: Request) throws -> ResponseRepresentable {
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
