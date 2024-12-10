import Foundation

class SolarDetailsData: ObservableObject {
    @Published var todaySolarProduction: Double?
    @Published var forecastToday: Double?
    @Published var forecastTomorrow: Double?
    @Published var forecastDayAfterTomorrow: Double?

    init(
        todaySolarProduction: Double? = nil,
        forecastToday: Double? = nil,
        forecastTomorrow: Double? = nil,
        forecastDayAfterTomorrow: Double? = nil
 ) {
        self.todaySolarProduction = todaySolarProduction
        self.forecastToday = forecastToday
        self.forecastTomorrow = forecastTomorrow
        self.forecastDayAfterTomorrow = forecastDayAfterTomorrow
    }
}
