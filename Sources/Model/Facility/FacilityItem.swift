//
//  File.swift
//  
//
//  Created by Aram Semerjyan on 07.02.24.
//

struct FacilityItem: Codable {
    let identity: FacilityDirectory?
    let owners: [FacilityItemOwner]?
    let imageSource: [FacilityItemImageSource]?
    let modeOfOperation: String?
}
