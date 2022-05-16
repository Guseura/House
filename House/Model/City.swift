import Foundation

struct City: Codable {
    let cities: [String]
    
    public static var all: [String] = []
    
    public static func get() {
        self.all.removeAll()
        let code = State.shared.getLanguageCode()
        guard let jsonData = readLocalJSONFile(forName: "cities-\(code.rawValue)") else { return }
        do {
            let response = try JSONDecoder().decode(City.self, from: jsonData)
            self.all = response.cities
        } catch {
            print("Error: \(error)")
        }
    }
    
}
