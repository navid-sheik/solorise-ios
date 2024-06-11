//
//  Networr.swift
//  solorise
//
//  Created by Navid Sheikh on 27/05/2024.
//

import Foundation

enum NetworkError : Error{
    case failedToCreateRequest
    case failedToFetchData
    case failedToDecode
    case unAuthorized
    case customError(code: Int, message : String)
    case invalidReponse
    
}



final class NetworkManager{
    
    /// Shared singleton
    static var shared = NetworkManager()
    
    /// URLSession instance
    private let session: URLSession
      
      /// Private Constructor
    private init() {
          let config = URLSessionConfiguration.default
          config.httpCookieAcceptPolicy = .always
          config.httpCookieStorage = HTTPCookieStorage.shared
          self.session = URLSession(configuration: config)
      }

    
    public func execute <T: Codable>(_ urlRequest: URLRequest?, expecting type : T.Type, completion : @escaping (Result<T, Error>) -> Void){
        
        guard let urlRequest = urlRequest else {
            completion(.failure(NetworkError.failedToCreateRequest))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let data = data, error == nil, let httpResponse = response as? HTTPURLResponse else{
                completion(.failure(NetworkError.failedToFetchData))
                return
            }
            print(error)
            print (httpResponse.statusCode)
            //Ensure response code is correct
            guard (200...299).contains(httpResponse.statusCode) else{
                do{
                    let errorResponse =  try JSONDecoder().decode(ApiErrorResponse.self, from: data)
                    completion(.failure(
                        NetworkError.customError(code: errorResponse.code, message: errorResponse.message)
                    ))
                    
                }catch{
                    completion(.failure(NetworkError.invalidReponse))
                }
                return
                
            }
            
            //Decode the object
            do{
                //DEUBBING: Look at the raw JSON values
                let jsonObject =  try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                print(jsonObject)
                let result =  try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            }catch let error as DecodingError{
                
               //DEBUGGING: Show the error in each request
               switch error {
               case .typeMismatch(_, let context):
                   print("Type mismatch: \(context.debugDescription)")
               case .dataCorrupted(let context):
                   print("Data corrupted: \(context.debugDescription)")
               case .keyNotFound(_, let context):
                   print("Key not found: \(context.debugDescription)")
               case .valueNotFound(_, let context):
                   print("Value not found: \(context.debugDescription)")
               @unknown default:
                   print("Unknown decoding error: \(error.localizedDescription)")
               }
                completion(.failure(NetworkError.failedToDecode))
            }catch {
                print("Unexpected error: \(error.localizedDescription)")
                completion(.failure(NetworkError.failedToDecode))
            }
            
        
        }
        task.resume()
        
    }
    
    /// Method to check if there are cookies stored
    public func hasCookies() -> Bool {
        if let cookies = HTTPCookieStorage.shared.cookies, !cookies.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    /// Method to print all keys and values of the cookies
    public func printCookies() {
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                print("Name: \(cookie.name), Value: \(cookie.value)")
                print("Properties:")
                if let properties = cookie.properties {
                    for (key, value) in properties {
                        print("  \(key.rawValue): \(value)")
                    }
                }
            }
        } else {
            print("No cookies found.")
        }
    }

}


extension NetworkManager{
    
    public func test <T:Codable>(expecting type: T.Type, completion: @escaping (Result <T, Error>) -> Void){
        
        let request =  Request(endpoint: .test)
            .set(method: .GET)
            .build()
        
        NetworkManager.shared.execute(request, expecting: T.self) { [weak self] result in
            guard let _ = self else { return }
            completion(result)
        }
    }
    
    public func register <T:Codable> (_ userData :  [String: Any], expecting type : T.Type, completion : @escaping (Result <T, Error>)->Void ){
        let jsonData  =  try? JSONSerialization.data(withJSONObject: userData)
        
        //Use the url request builder
        let request  =  Request(endpoint: .auth, pathComponents: ["signup"])
            .add(headerField: "Content-Type", value: "application/json")
            .set(body: jsonData)
            .set(method: .POST)
            .build()
        
        
        NetworkManager.shared.execute(request, expecting: T.self) { [weak self] result in
            guard let _ = self else { return }
            completion(result)
        }
        
    }
    
    public func login<T:Codable>(_ userData : [String: Any], expecting type : T.Type,  completion : @escaping (Result <T, Error>) -> Void){
        //Send the data to server
        let jsonData  =  try? JSONSerialization.data(withJSONObject: userData)

        //Use the url request builder
        let request  =  Request(endpoint: .auth, pathComponents: ["login"])
            .add(headerField: "Content-Type", value: "application/json")
            .set(body: jsonData)
            .set(method: .POST)
            .build()
        
        NetworkManager.shared.execute(request, expecting: T.self) { [weak self] result in
            guard let _ = self else { return }
            completion(result)
        }
        
    }
    
    /// Method to sign out and clear cookies
    public func logout<T:Codable>(expecting type : T.Type,  completion : @escaping (Result <T, Error>) -> Void){
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        
        // Optionally, you can make a network request to inform the server about the sign-out
        //Use the url request builder
        let request  =  Request(endpoint: .auth, pathComponents: ["logout"])
            .add(headerField: "Content-Type", value: "application/json")
            .set(method: .POST)
            .build()
        
        NetworkManager.shared.execute(request, expecting: T.self) { [weak self] result in
            guard let _ = self else { return }
            completion(result)
        }
       
    }
    
    
    
    /// Method to sign out and clear cookies
    public func testAuth<T:Codable>(expecting type : T.Type,  completion : @escaping (Result <T, Error>) -> Void){
        
        // Optionally, you can make a network request to inform the server about the sign-out
        //Use the url request builder
        let request  =  Request(endpoint: .auth, pathComponents: ["test"])
            .add(headerField: "Content-Type", value: "application/json")
            .set(method: .GET)
            .build()
        
        NetworkManager.shared.execute(request, expecting: T.self) { [weak self] result in
            guard let _ = self else { return }
            completion(result)
        }
       
    }
    
    
    
    
}
