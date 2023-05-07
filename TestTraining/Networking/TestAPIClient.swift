//  Created by Bastien Falcou on 8/27/22.

import Foundation

final class TestAPIClient: APIClient {
    private let defaultSession = URLSession(configuration: .default)
    private let cachingService: CachingService?
    let baseURL: URL

    init(baseURL: URL, cachingService: CachingService?) {
        self.baseURL = baseURL
        self.cachingService = cachingService
    }

    // LEARNING PROGRAM #1-6
    
    func perform<T>(request: RequestType,
                    path: String,
                    properties: [String : Any]?,
                    completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        func returnOnMainThread(error: Error) {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
        defaultSession.dataTask(with: baseURL.appendingPathComponent(path)) { data, response, error in
            DispatchQueue.global(qos: .background).async {
                if let error = error {
                    returnOnMainThread(error: error)
                    return
                }
                guard let data = data else {
                    returnOnMainThread(error: NetworkingError.noData)
                    return
                }
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(result))
                    }
                } catch {
                    returnOnMainThread(error: error)
                }
            }
        }.resume()
    }
    
    // 'async' functions and modules are asynchronous and return promises, they do not block the main thread
    // Question: Does it mean it's equivalent to wrap this function into a 'DispatchQueue.global(qos: .background).async'?
    func perform<T>(request: RequestType,
                    path: String,
                    properties: [String : Any]?) async throws -> T where T: Decodable {
        let url = baseURL.appendingPathComponent(path)
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    // LEARNING PROGRAM #7
    
    @MainActor
    func perform<T>(request: RequestType,
                    path: String,
                    properties: [String : Any]?,
                    completion: @escaping (Result<T, Error>, Bool) -> Void) async where T : Decodable {
        let url = baseURL.appendingPathComponent(path)
        if let cachedData = cachingService?.retrive(for: url, properties: properties) {
            do {
                let result = try JSONDecoder().decode(T.self, from: cachedData)
                completion(.success(result), true)
            } catch {
                completion(.failure(error), true)
            }
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            cachingService?.cache(data, for: url, properties: properties)
            let response = try JSONDecoder().decode(T.self, from: data)
            completion(.success(response), false)
        } catch {
            completion(.failure(error), false)
        }
    }
}
