//
//  File.swift
//  
//
//  Created by Aram Semerjyan on 07.02.24.
//

struct FacilityVisitingHours: Codable {
    let note: String?
}

struct Facility: Codable {
    let item: FacilityItem?
    let astronomicalCode: String?
    let placeInTheSolarSystem: String?
    let gravitationalBodyRelationship: String?
    let website: String?
    let facilityLocationId: String?
    let visitingHours: FacilityVisitingHours?
    let subObservingFacilityIds: [String]?
    let deviceIds: [String]?
    let history: String?
}
