//
//  SSSCodable.swift
//
//
//  Created by Aram Semerjyan on 07.02.24.
//

import Foundation

final class SSSDecoder: JSONDecoder {
    override init() {
        super.init()
        self.keyDecodingStrategy = .convertFromSnakeCase
    }
}

final class SSSEncoder: JSONEncoder {
    override init() {
        super.init()
        self.keyEncodingStrategy = .convertToSnakeCase
    }
}
