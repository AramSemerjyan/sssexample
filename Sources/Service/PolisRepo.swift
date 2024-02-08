//
//  PolisRepo.swift
//
//
//  Created by Aram Semerjyan on 07.02.24.
//

import Foundation

protocol PolisRepoInterface {
    func save(direcotory: FacilitiesDirectory)
    func getDirectory() -> FacilitiesDirectory?
    func save(facilities: [String: Facility])
    func getFacility(forId id: String) -> Facility?
    func save(facilityLocations: [String: FacilityLocation])
    func getFacilityLocation(forId id: String) -> FacilityLocation?
}

final class PolisRepo {
    private let fileManager: SSSFileManagerInterface
    
    init(fileManager: SSSFileManagerInterface) {
        self.fileManager = fileManager
    }
}

// MARK: - PolisRepoInterface

extension PolisRepo: PolisRepoInterface {
    func save(direcotory: FacilitiesDirectory) {
        save(data: direcotory, type: .facilityDirectories)
    }
    
    func getDirectory() -> FacilitiesDirectory? {
        get(fileType: .facilityDirectories)
    }
    
    func save(facilities: [String : Facility]) {
        save(data: facilities, type: .facilities)
    }
    
    func getFacility(forId id: String) -> Facility? {
        let facilities: [String: Facility]? = get(fileType: .facilities)
        
        return facilities?[id]
    }
    
    func save(facilityLocations: [String : FacilityLocation]) {
        save(data: facilityLocations, type: .facilitiesLocation)
    }
    
    func getFacilityLocation(forId id: String) -> FacilityLocation? {
        let facilities: [String: FacilityLocation]? = get(fileType: .facilitiesLocation)
        
        return facilities?[id]
    }
}

// MARK: - Helpers

private extension PolisRepo {
    func get<T: Decodable>(fileType: SSSFileType) -> T? {
        do {
            if let data = try fileManager.getFile(fileType) {
                let facilities = try SSSDecoder().decode(
                    T.self,
                    from: data
                )
                
                return facilities
            } else {
                return nil
            }
        } catch {
            SSSLogger.error(message: error.localizedDescription)
            return nil
        }
    }
    
    func save(data: Encodable, type: SSSFileType) {
        do {
            try fileManager.save(
                data: try SSSEncoder().encode(data),
                withType: type
            )
        } catch {
            SSSLogger.error(message: error.localizedDescription)
        }
    }
}
