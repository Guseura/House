import Foundation

struct User: Codable {
    
    let uid: String
    let name: String
    let email: String
    let image: String

    var safeEmail: String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
}

struct userResponse: Codable {
    
    let name: String
    let image: String
    
}

struct Response: Codable {
    
    let status: Bool
    let message: String
    let id: Int?
    
}
