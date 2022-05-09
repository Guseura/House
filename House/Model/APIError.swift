import Foundation

enum APIError: String, Error {
    case invalidData = "The data received from the server is invalid. Please try again"
    case decodingProblem
    case encodingProblem
    case invalidURL
    case unableToComplete = "Unable to completed your request. Please check your internet connection."
}
