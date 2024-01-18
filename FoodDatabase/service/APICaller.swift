//
//  APICaller.swift
//  FoodDatabase
//
//  Created by Gábor Horváth on 2022. 12. 31..
//

import SwiftUI

class ApiCaller: ObservableObject {
//    private let backendUrl: String = "http://192.168.2.55:8094/"
//    private let backendUrl: String = "http://192.168.2.41:8080/"
    private let backendUrl: String = "https://foods.sativus.space/"
    
    static let shared = ApiCaller()
    
    private init() {}
    
    
    // MARK: addFood
    func addFood(food: Food, completion:@escaping (Result<Food, Error>) -> Void) {
        print("addFood called")
        guard let url = URL(string: backendUrl + "add-food") else {fatalError("Missing URL")}
        var dataString: Data?
        do {
            dataString = try JSONEncoder().encode(food)
        } catch let encodeError {
            print("encoding error:", encodeError)
            completion(.failure(encodeError))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("\(String(describing: dataString?.count))", forHTTPHeaderField: "Content-Length")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = dataString
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                completion(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse else {return}
            print(response)
            print(response.statusCode)
            if response.statusCode == 201 {
                guard let data = data else {return}
                
                DispatchQueue.main.async {
                    do {
                        let decodedJSON = try JSONDecoder().decode(Food.self, from: data)
                        print("decoded JSON: ", decodedJSON)
                        completion(.success(decodedJSON))
                    } catch {
                        print("Error decoding: ", error)
                        completion(.failure(error))
                    }
                }
            }
        }
        
        task.resume()
        
    }
    
    // MARK: getFood
    func getFood(barcode: String, completion:@escaping (Result<Food, Error>) -> Void) {
        guard let url = URL(string: backendUrl + "get-food/\(barcode)") else {fatalError("Missing URL")}
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            if let error = error {
                print("Request error: ", error)
                completion(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse else {return}
            
            print(response)
            
            if response.statusCode == 200 {
                guard let data = data else {return}
                DispatchQueue.main.async {
                    do {
                        print(data)
                        let decodedFood = try JSONDecoder().decode(Food.self, from: data)
                        print(decodedFood)
                        completion(.success(decodedFood))
                    } catch let decodeError{
                        print("Error decoding: ", decodeError)
                        completion(.failure(decodeError))
                    }
                }
            }
        }
        
        dataTask.resume()
    }
    
    // MARK: getAllFood
    func getAllFood(completion: @escaping (Result<Storage, Error>) -> Void) {
        guard let url = URL(string: backendUrl + "get-all") else {fatalError("Missing URL")}
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            if let error = error {
                //print("Request error: ", error)
                completion(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse else {return}
            
            print(response)
            
            if response.statusCode == 200 {
                guard let data = data else {return}
                DispatchQueue.main.async {
                    do {
                        print(data)
                        let decoded = try JSONDecoder().decode(Storage.self, from: data)
                        print(decoded)
                        completion(.success(decoded))
                    } catch let decodeError{
                        print("Error decoding: ", decodeError)
                        completion(.failure(decodeError))
                    }
                }
            }
        }
        
        dataTask.resume()
    }
    
    // MARK: deleteFood
    func deleteFood(food: Food, completion: @escaping(Bool) -> Void) {
        print("delete called!")
        guard let id = food.id else { fatalError("Missing ID") }
        
        guard let url = URL(string: backendUrl + "delete/\(id)") else {fatalError("Missing URL")}
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "DELETE"
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            if let error = error {
                print("Request error: ", error)
                completion(false)
            }
            
            guard let response = response as? HTTPURLResponse else {return}
            
            print(response)
            
            if response.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }
        
        dataTask.resume()
    }
    
    // MARK: deleteStorageFood
    func deleteStorageFood(food: Food, completion: @escaping(Bool)-> Void) {
        print("deleteStorageFood called")
        
        guard let url = URL(string: backendUrl + "delete-all/\(food.barcode)") else {fatalError("Missing URL")}
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "DELETE"
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            if let error = error {
                print("Request error: ", error)
                completion(false)
            }
            
            guard let response = response as? HTTPURLResponse else {return}
            
            print(response)
            
            if response.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }
        
        dataTask.resume()
    }
}
