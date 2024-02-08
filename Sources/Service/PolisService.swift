//
//  PolisService.swift
//
//
//  Created by Aram Semerjyan on 07.02.24.
//

import Foundation

protocol PolisServiceInterface {
    func getDirectoryLastUpdateDate() -> String
    func getDirectory() -> [FacilityDirectory]
    func getNumberOfFacilitiesInDirectory() -> Int
    func getUUIDOfFacilities(withName name: String) -> [String]
    func getLocationOfFacility(withId id: String) -> FacilityLocation?
}

final class PolisService {
    let polisRepo: PolisRepoInterface
    let polisFetchService: PolisFetchServiceInterface
    
    init(
        polisRepo: PolisRepoInterface,
        polisFetchService: PolisFetchServiceInterface
    ) {
        self.polisRepo = polisRepo
        self.polisFetchService = polisFetchService
        
        setUp()
    }
}

// MARK: - PolisServiceInterface

extension PolisService: PolisServiceInterface {
    func getDirectoryLastUpdateDate() -> String {
        polisRepo.getDirectory()?.lastUpdated ?? "No data yet"
    }
    
    func getNumberOfFacilitiesInDirectory() -> Int {
        polisRepo.getDirectory()?.observingFacilityReferences.count ?? 0
    }
    
    func getUUIDOfFacilities(withName name: String) -> [String] {
        polisRepo.getDirectory()?.observingFacilityReferences.map { $0.identity }
            .filter { $0.name?.lowercased().contains(name.lowercased()) ?? false }
            .compactMap { $0.id } ?? []
    }
    
    func getDirectory() -> [FacilityDirectory] {
        polisRepo.getDirectory()?.observingFacilityReferences.map { $0.identity } ?? []
    }
    
    func getLocationOfFacility(withId id: String) -> FacilityLocation? {
        polisRepo.getFacilityLocation(forId: id)
    }
}

// MARK: - Set up 

private extension PolisService {
    func setUp() {
        Task {
            let finder = self.polisFetchService.fetchRemoteFinder()
            
            guard let finder else {
                return
            }
            
            guard let directory = await self.polisFetchService.fetchDirectory(finder: finder) else {
                return
            }
            
            self.polisRepo.save(direcotory: directory)
            
            var facilities: [String: Facility] = [:]
            var facilitiesLocation: [String: FacilityLocation] = [:]
            
            for d in directory.observingFacilityReferences.map({ $0.identity }) where d.id != nil {
                
                guard 
                    let facility = await self.polisFetchService.fetchFacility(withFinder: finder, forId: d.id!)
                else {
                    continue
                }
                
                if let facilityId = facility.item?.identity?.id {
                    facilities[facilityId] = facility
                }
                
                guard
                    let locationId = facility.facilityLocationId,
                    let facilityLocation = await self.polisFetchService.fetchFacilityLocation(
                        withFinder: finder,
                        withId: d.id!,
                        andLocationId: locationId
                    )
                else {
                    continue
                }
                
                facilitiesLocation[d.id!] = facilityLocation
            }
            
            self.polisRepo.save(facilities: facilities)
            self.polisRepo.save(facilityLocations: facilitiesLocation)
            
            SSSLogger.debug(message: "Remote data fetched! count: \(polisRepo.getDirectory()?.observingFacilityReferences.count ?? 0)")
        }
    }
}
