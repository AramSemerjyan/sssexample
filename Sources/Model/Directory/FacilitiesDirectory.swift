//
//  File.swift
//  
//
//  Created by Aram Semerjyan on 07.02.24.
//

import Foundation

struct FacilitiesDirectory: Codable {
    let observingFacilityReferences: [ObservingFacilitiesReference]
    let lastUpdated: String?
}
