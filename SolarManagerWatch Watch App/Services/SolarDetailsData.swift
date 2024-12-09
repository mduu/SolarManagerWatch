import Foundation

class SolarDetailsData: ObservableObject {
    @Published var todaySolarProduction: Double?
    
    init(todaySolarProduction: Double? = nil) {
        self.todaySolarProduction = todaySolarProduction
    }
}
