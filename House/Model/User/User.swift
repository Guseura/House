import Foundation

struct User: Codable {
    
    let id: Int
    let name: String
    let email: String
    let password: String
    let image: String

}

struct Response: Codable {
    
    let status: Bool
    let message: String
    let id: Int?
    
}
