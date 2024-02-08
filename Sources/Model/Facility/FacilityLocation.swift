//
//  File.swift
//  
//
//  Created by Aram Semerjyan on 07.02.24.
//

struct FacilityLocation: Codable {
    let earthCountry: String?
    let earthCountryCode: String?
    let earthContinent: String?
    let eastLongitude: FacilityLocationCoordinate?
    let latitude: FacilityLocationCoordinate?
    let altitude: FacilityLocationCoordinate?
    let earthTimeZoneIdentifier: String?
}
