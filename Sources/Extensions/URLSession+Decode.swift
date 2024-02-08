//
//  URLSession.swift
//  
//
//  Created by Aram Semerjyan on 07.02.24.
//

import Foundation

extension URLSession {
    func decode<T: Decodable>(
        _ type: T.Type = T.self,
        from url: URL
    ) async throws  -> T {
        let (data, _) = try await data(from: url)

        let decoded = try SSSDecoder().decode(T.self, from: data)
        return decoded
    }
}
