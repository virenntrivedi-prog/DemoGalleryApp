//
//  APIManager.swift
//  DemoGalleryApp
//
//  Created by Viren Trivedi on 25/07/26.
//

import Foundation

final class APIManager {

    static let shared = APIManager()

    func request<T: Decodable>(urlString: String, completion: @escaping(Result<T, Error>) -> Void) {

        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let http = response as? HTTPURLResponse,
                  200...299 ~= http.statusCode else {

                completion(.failure(NetworkError.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }

            do {

                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))

            } catch {
                completion(.failure(NetworkError.decodingError))
            }

        }.resume()
    }
}
