//
//  RefreshResponse.swift
//  SolarManagerWatch
//
//  Created by Marc Dürst on 19.10.2024.
//

struct RefreshResponse : Codable {
    var accessToken: String
    var refreshToken: String
    var expiresIn: Int
    var accessClaims: [String]?

    init(accessToken: String, refreshToken: String, expiresIn: Int, accessClaims: [String]?) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresIn = expiresIn
        self.accessClaims = accessClaims
    }
}
