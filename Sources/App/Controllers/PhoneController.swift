//
//  PhoneController.swift
//  hello
//
//  Created by Hung Nguyen on 5/18/17.
//
//

import Foundation
import Vapor
import HTTP

final class PhoneController {
    func addRoutes(drop: Droplet) {
        drop.get("phone", handler: phone)
    }
    
    func phone(request: Request) throws -> ResponseRepresentable {
        return "Phone of hung"
    }
    
}
