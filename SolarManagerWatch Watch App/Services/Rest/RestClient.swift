//
//  RestClient.swift
//  SolarManagerWatch
//
//  Created by Marc Dürst on 12.10.2024.
//

import Combine
import Foundation

class RestClient {
    let baseUrl: String

    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }

    func get<TResponse>(
        serviceUrl: String, parameters: Codable?, accessToken: String?
    ) async throws
        -> TResponse? where TResponse: Codable
    {
        guard let url = URL(string: "\(baseUrl)\(serviceUrl)") else {
            return nil
        }

        var request = URLRequest(url: url, timeoutInterval: 20)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        if let accessToken = KeychainHelper.accessToken {
            request.setValue(
                "Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        if let response = response as? HTTPURLResponse,
            response.statusCode != 200
        {
            print(
                "RestClient Error: \(response.statusCode), \(String(describing: HTTPURLResponse.localizedString))"
            )
            throw RestError.responseError(response: response)
        }

        return try JSONDecoder().decode(TResponse.self, from: data)
    }

}