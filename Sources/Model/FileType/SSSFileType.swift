//
//  SSSFileType.swift
//
//
//  Created by Aram Semerjyan on 08.02.24.
//

enum SSSFileType {
    case facilityDirectories
    case facilities
    case facilitiesLocation
}

extension SSSFileType {
    var ext: String {
        switch self {
        default: ".json"
        }
    }
    
    var name: String {
        switch self {
        case .facilityDirectories: "directories"
        case .facilities: "facilities"
        case .facilitiesLocation: "locations"
        }
    }
    
    var nameWithExt: String {
        switch self {
        default: name + ext
        }
    }
}
