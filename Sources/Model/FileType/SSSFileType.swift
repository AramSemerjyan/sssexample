//
//  SSSFileType.swift
//
//
//  Created by Aram Semerjyan on 08.02.24.
//

enum SSSFileType: String {
    case directories
    case facilities
    case location
}

extension SSSFileType {
    var ext: String {
        switch self {
        default: ".json"
        }
    }
    
    var nameWithExt: String {
        switch self {
        default: rawValue + ext
        }
    }
}
