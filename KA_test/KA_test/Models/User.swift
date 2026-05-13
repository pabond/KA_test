
//
//  User.swift
//  KA_test
//
//  Created by Pavel Bondar on 12.05.26.
//

import Foundation

struct User: Codable, Identifiable {
    let identifier: Identidier
    let gender: String?
    let name: Name?
    let location: Location?
    let email: String?
    let picture: Picture?
    let nat: String?
    let phone: String?
    let registered: RegistrationInfo
    
    var id: String {
        return fullName + (identifier.name ?? "") + (email ?? "")
    }
    
    var locationInfo: String {
        var addressInfo = ""
        location?.street?.name.map { addressInfo += $0 }
        location?.street?.number.map { addressInfo += " \($0)" }
        
        return "\(addressInfo), \(location?.city ?? ""), \(location?.state ?? "")"
    }
    
    var fullName: String {
        return "\(name?.first ?? "") \(name?.last ?? "")"
    }
    
    var registerionDate: String {
        guard let dateString = registered.date, !dateString.isEmpty
        else { return " - " }
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "dd.MM.yyyy"
                
            let result = displayFormatter.string(from: date)
            
            return result.description
        }
        
        return " - "
    }
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case gender
        case name
        case location
        case email
        case picture
        case nat
        case phone
        case registered
    }
}

struct RegistrationInfo: Codable {
    let date: String?
}

struct Identidier: Codable {
    let name: String?
}

struct Name: Codable {
    let title: String?
    let first: String?
    let last: String?
}

struct Location: Codable {
    let street: Street?
    let city: String?
    let state: String?
    let country: String?
}

struct Street: Codable {
    let number: Int?
    let name: String?
}

struct Picture: Codable {
    let large: String?
    let medium: String?
    let thumbnail: String?
}
