import UIKit

private let userURL = "http://localhost:8888/users"

struct UserNetwork {
    
    public static var shared: UserNetwork = UserNetwork()
    
    // User by id
    
    public func getUser(id: Int, completion: @escaping (Result<User, APIError>) -> Void) {
        
        let requestURLString = userURL + "/get-by-id"
        guard let requestURL = URL(string: requestURLString) else { return }
        
        let parameters: [String: Any] = [
            "id": id
        ]
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.httpBody = parameters.percentEncoded()
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(.success(user))
            }
            catch {
                completion(.failure(.decodingProblem))
            }
        }.resume()
        
    }
    
    // User by email and password
    
    public func getUser(email: String, password: String, completion: @escaping (Result<User, APIError>) -> Void) {
        
        let requestURLString = userURL + "/get-by-email"
        guard let requestURL = URL(string: requestURLString) else { return }
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.httpBody = parameters.percentEncoded()
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(.success(user))
            }
            catch {
                completion(.failure(.decodingProblem))
            }
        }.resume()
        
    }
    
    // Add User
    
    public func addUser(name: String, email: String, password: String, image: String, completion: @escaping (Result<Response, APIError>) -> Void) {
        
        let requestURLString = userURL + "/add-user"
        guard let requestURL = URL(string: requestURLString) else { return }
        
        let parameters: [String: Any] = [
            "name": name,
            "email": email,
            "password": password,
            "image": image
        ]
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.httpBody = parameters.percentEncoded()
                
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let userCreationResponse = try JSONDecoder().decode(Response.self, from: data)
                completion(.success(userCreationResponse))
            }
            catch {
                completion(.failure(.decodingProblem))
            }
        }.resume()
        
    }
    
    // Change user name
    
    public func updateUser(name: String, id: Int, completion: @escaping (Result<Response, APIError>) -> Void) {
        
        let requestURLString = userURL + "/update-name"
        guard let requestURL = URL(string: requestURLString) else { return }
        
        let parameters: [String: Any] = [
            "name": name,
            "id": id
        ]
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.httpBody = parameters.percentEncoded()
                
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let userUpdateNameResponse = try JSONDecoder().decode(Response.self, from: data)
                completion(.success(userUpdateNameResponse))
            }
            catch {
                completion(.failure(.decodingProblem))
            }
        }.resume()
        
    }
    
    public func updateUser(image: UIImage, id: Int, completion: @escaping (Result<Response, APIError>) -> Void) {
        
        guard let imageData = image.pngData() else {
            completion(.failure(.invalidData))
            return
        }
        
        let strBase64image = imageData.base64EncodedString(options: .lineLength64Characters)
        
        let requestURLString = userURL + "/update-image"
        guard let requestURL = URL(string: requestURLString) else { return }
        
        let parameters: [String: Any] = [
            "image": strBase64image,
            "id": id
        ]
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.httpBody = parameters.percentEncoded()
                
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let userUpdateNameResponse = try JSONDecoder().decode(Response.self, from: data)
                completion(.success(userUpdateNameResponse))
            }
            catch {
                completion(.failure(.decodingProblem))
            }
        }.resume()
        
    }
    
}
