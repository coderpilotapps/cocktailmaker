//
//  CocktailResultController.swift
//  cocktailMaker
//
//  Created by Claudia Contreras on 3/25/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import Foundation
import UIKit

class CocktailResultController {
    // MARK: - Properties
    
    //To store our cocktails
    var cocktailResults: DrinksResults?
    var ingredientResults: IngredientDrinks?
    
    //We want to keep track of our possible errors
    enum NetworkError: Error {
        case otherError(Error)
        case noData
        case decodeFailed
    }
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case pull = "PULL"
        case delete = "DELETE"
    }
    
    enum Endpoints {
        static let baseURL = "https://www.thecocktaildb.com/api/json/v1/1/"
        //This is where we store the different endpoint cases. They are named based on their functionality
        case getRandomCocktail
        case getImage(String)
        case searchByName(String)
        case searchByLetter(String)
        case searchByIngredient(String)
        case searchById(String)
        
        var stringValue: String {
            switch self {
            case .getRandomCocktail:
                return Endpoints.baseURL + "/random.php"
            case .getImage(let imagePath):
                return imagePath
            case .searchByName(let searchTerm):
                return Endpoints.baseURL + "search.php?s=\(searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            case .searchByLetter(let searchTerm):
                return Endpoints.baseURL + "search.php?f=\(searchTerm)"
            case .searchByIngredient(let searchTerm):
                return Endpoints.baseURL + "filter.php?i=\(searchTerm)"
            case .searchById(let id):
                return Endpoints.baseURL + "lookup.php?i=\(id)"
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    // MARK: - Functions
    
    // Function to get a random Drink
    func getRandomCocktail(completion: @escaping (Result<DrinksResults, NetworkError>) -> Void) {
        
        //Build up the URL with necessary information
        var request = URLRequest(url: Endpoints.getRandomCocktail.url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        //Request the data
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.otherError(error!)))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            //Decode the data
            let decoder = JSONDecoder()
            do {
                self.cocktailResults = try decoder.decode(DrinksResults.self, from: data)
                completion(.success(self.cocktailResults!))
            } catch  {
                completion(.failure(.decodeFailed))
                return
            }
        }.resume()
    }
    
    //Get the image for the drink
    func downloadCocktailImage(path: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        //Build up the URL with necessary information
        var request = URLRequest(url: Endpoints.getImage(path).url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        //Request the image
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.otherError(error!)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
        }.resume()
    }
    
    //Get a list of drinks by name
    func searchCocktailByName(searchTerm: String, completion: @escaping (Result<DrinksResults, NetworkError>) -> Void) {
        //Build up the URL with necessary information
        var request = URLRequest(url: Endpoints.searchByName(searchTerm).url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        //Request the data
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.otherError(error!)))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            //Decode the data
            let decoder = JSONDecoder()
            do {
                self.cocktailResults = try decoder.decode(DrinksResults.self, from: data)
                completion(.success(self.cocktailResults!))
            } catch  {
                completion(.failure(.decodeFailed))
                return
            }
        }.resume()
    }
    
    //Get a list of drinks by first letter
    func searchCocktailByLetter(searchTerm: String, completion: @escaping (Result<DrinksResults, NetworkError>) -> Void) {
        //Build up the URL with necessary information
        var request = URLRequest(url: Endpoints.searchByLetter(searchTerm).url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        //Request the data
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.otherError(error!)))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            //Decode the data
            let decoder = JSONDecoder()
            do {
                self.cocktailResults = try decoder.decode(DrinksResults.self, from: data)
                completion(.success(self.cocktailResults!))
            } catch  {
                completion(.failure(.decodeFailed))
                return
            }
        }.resume()
    }
    
    //Search drinks by Ingredient
    func searchCocktailByIngredient(searchTerm: String, completion: @escaping (Result<IngredientDrinks, NetworkError>) -> Void) {
        //Build up the URL with necessary information
        var request = URLRequest(url: Endpoints.searchByIngredient(searchTerm).url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        //Request the data
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.otherError(error!)))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            //Decode the data
            let decoder = JSONDecoder()
            do {
                self.ingredientResults = try decoder.decode(IngredientDrinks.self, from: data)
                completion(.success(self.ingredientResults!))
            } catch  {
                completion(.failure(.decodeFailed))
                return
            }
        }.resume()
    }

    //Get a list of drinks by ID
    func searchCocktailByID(id: String, completion: @escaping (Result<DrinksResults, NetworkError>) -> Void) {
        //Build up the URL with necessary information
        var request = URLRequest(url: Endpoints.searchById(id).url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        //Request the data
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.otherError(error!)))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            //Decode the data
            let decoder = JSONDecoder()
            do {
                self.cocktailResults = try decoder.decode(DrinksResults.self, from: data)
                completion(.success(self.cocktailResults!))
            } catch  {
                completion(.failure(.decodeFailed))
                return
            }
        }.resume()
    }
}
