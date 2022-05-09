import Foundation

private let userURL = "http://localhost:8888/users"

struct UserNetwork {
    
    public static var shared: UserNetwork = UserNetwork()
    
    // MARK: - GET
    
    // Get user by id
    
    public func getUser(id: Int, completion: @escaping (Result<User, APIError>) -> Void) {
        
        let userByIdURL = userURL + "/\(id)"
        guard let requestURL = URL(string: userByIdURL) else { return }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
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
    
    // MARK: - POST
    
    // Add User
    
    public func addUser(name: String, email: String, password: String, image: String, completion: @escaping (Result<Response, APIError>) -> Void) {
        
        let parameters: [String: Any] = [
            "name": name,
            "email": email,
            "password": password,
            "image": image
        ]
        
        guard let requestURL = URL(string: userURL) else { return }
        
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
    
}
