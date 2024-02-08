//
//  String+UUID.swift
//
//
//  Created by Aram Semerjyan on 08.02.24.
//

import Foundation

extension String {
    var toUUID: UUID? {
        UUID(uuidString: self)
    }
}
