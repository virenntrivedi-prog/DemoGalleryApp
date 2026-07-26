//
//  NetworkError.swift
//  DemoGalleryApp
//
//  Created by Viren Trivedi on 25/07/26.
//

enum NetworkError: Error {
    case invalidURL
    case decodingError
    case invalidResponse
    case invalidData
    case noInternet
}
