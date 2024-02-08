//
//  FacilityLocationCoordinate.swift
//
//
//  Created by Aram Semerjyan on 07.02.24.
//

struct FacilityLocationCoordinate: Codable {
    let unit: String?
    let valueKind: String?
    let value: String?
    
    var doubleValue: Double? {
        Double(value ?? "")
    }
}
