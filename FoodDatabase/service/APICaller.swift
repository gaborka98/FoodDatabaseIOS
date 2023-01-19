//
//  APICaller.swift
//  FoodDatabase
//
//  Created by Gábor Horváth on 2022. 12. 31..
//

import SwiftUI

class ApiCaller: ObservableObject {
    private let backendUrl: String = "http://192.168.2.55:8094/"
    
    static let shared = ApiCaller()
    
    private init() {}
    
    
    // MARK: addFood
    func addFood(food: Food, completion:@escaping (Result<Food, Error>) -> ()) {
        guard let url = URL(string: backendUrl + "add-food") else {fatalError("Missing URL")}
        
        let dataString = try? JSONEncoder().encode(food)
        
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
            if response.statusCode == 201 {
                guard let data = data else {return}
                
                DispatchQueue.main.async {
                    do {
                        let decodedJSON = try JSONDecoder().decode(Food.self, from: data)
                        print(decodedJSON)
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
    func getFood(barcode: String, completion:@escaping (Result<Food, Error>) -> ()) {
        guard let url = URL(string: backendUrl + "get-food/\(barcode)") else {fatalError("Missing URL")}
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
                        let decodedFood = try JSONDecoder().decode(Food.self, from: data)
                        print(decodedFood)
                        completion(.success(decodedFood))
                    } catch let decodeError{
                        //print("Error decoding: ", decodeError)
                        completion(.failure(decodeError))
                    }
                }
            }
        }
        
        dataTask.resume()
    }
    
    func getAllFood(completion: @escaping (Result<Storage, Error>)-> ()) {
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
}
