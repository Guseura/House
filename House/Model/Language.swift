import UIKit

struct Language {
    
    let name: String
    let code: Code
    
    internal enum Code: String, Codable {
        case en, uk
        
        init(_ value: String) {
            switch value.lowercased() {
            case "en": self = .en
            case "ua": self = .uk
            case "uk": self = .uk
            default: self = .en
            }
        }
        
        public func getLanguage() -> Language {
            return (Language.languages.first { $0.code == self })!
        }
    }
    
    static let languages: [Language] = [
        Language(name: "English",   code: .en),
        Language(name: "Ukranian",  code: .uk)
    ]
}
