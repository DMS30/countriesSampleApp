//
//  APIService.swift
//  countriesSampleApp
//
//  Created by Shanmukh D M on 12/09/24.
//

import Foundation

class APIService {
    func fetchCountries(completion: @escaping (Result<[Country], Error>) -> Void) {
        let urlString = "https://api.sampleapis.com/countries/countries"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let countries = try JSONDecoder().decode([Country].self, from: data)
                completion(.success(countries))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }
}
