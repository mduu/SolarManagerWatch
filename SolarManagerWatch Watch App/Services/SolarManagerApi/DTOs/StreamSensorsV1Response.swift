//
//  StreamSensorsV1Response.swift
//  SolarManagerWatch
//
//  Created by Marc Dürst on 21.10.2024.
//

struct StreamSensorsV1Response : Codable {
    var TimeStamp: String // "2024-10-20T19:14:23.193Z"
    var currentPowerConsumption: Int // Watt
    var currentPvGeneration: Int // Watt
    var currentGridPower: Int // Watt
    var devices: [StreamSensorsV1Device]
    var currentBatteryChargeDischarge: Int
    // NOTE: Some more fields exists but we don't know that they mean so far
}

struct StreamSensorsV1Device : Codable {
    var _id: String
    var activeDevice: Int?
    var currentMode: Int?
    var currentPower: Int?
    var deviceStatus: Int?
    var signal: SensorConnectionStatus?
}