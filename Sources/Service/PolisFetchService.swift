//
//  PolisFetchService.swift
//
//
//  Created by Aram Semerjyan on 07.02.24.
//

import Foundation
import swift_polis

protocol PolisFetchServiceInterface {
    func fetchRemoteFinder() -> PolisRemoteResourceFinder?
    func fetchDirectory(finder: PolisRemoteResourceFinder) async -> FacilitiesDirectory?
    func fetchFacility(
        withFinder finder: PolisRemoteResourceFinder,
        forId id: String
    ) async -> Facility?
    func fetchFacilityLocation(
        withFinder finder: PolisRemoteResourceFinder,
        withId id: String,
        andLocationId locationId: String
    ) async -> FacilityLocation?
}

final class PolisFetchService {
    private let serverUrl = Constants.polisURL
}

// MARK: - PolisFetchServiceInterface

extension PolisFetchService: PolisFetchServiceInterface {
    func fetchRemoteFinder() -> PolisRemoteResourceFinder? {
        do {
            let remoteFinder = try PolisRemoteResourceFinder(
                at: serverUrl,
                supportedImplementation: .oldestSupportedImplementation()
            )
            
            return remoteFinder
        } catch {
            SSSLogger.error(message: error.localizedDescription)
            
            return nil
        }
    }
    
    func fetchDirectory(finder: PolisRemoteResourceFinder) async -> FacilitiesDirectory? {
        guard
            let directoryUrl = URL(string: finder.observingFacilitiesDirectoryURL())
        else {
            return nil
        }
        
        do {
            let facilitiesDirectory = try await URLSession.shared.decode(
                FacilitiesDirectory.self,
                from: directoryUrl
            )
            
            return facilitiesDirectory
        } catch {
            SSSLogger.error(message: error.localizedDescription)
            
            return nil
        }
    }
    
    func fetchFacility(
        withFinder finder: PolisRemoteResourceFinder,
        forId id: String
    ) async -> Facility? {
        guard 
            let facilityUUID = id.toUUID,
            let facilityUrl = URL(string: finder.observingFacilityURL(observingFacilityID: facilityUUID))
        else {
            return nil
        }
        
        do {
            return try await URLSession.shared.decode(
                Facility.self,
                from: facilityUrl
            )
        } catch {
            SSSLogger.error(message: error.localizedDescription)
            
            return nil
        }
    }
    
    func fetchFacilityLocation(
        withFinder finder: PolisRemoteResourceFinder,
        withId id: String,
        andLocationId locationId: String
    ) async -> FacilityLocation? {
        guard 
            let facilityUUID = id.toUUID,
            let locationUUID = locationId.toUUID,
            let locationUrl = URL(
                string: finder.observingDataURL(
                    withID: locationUUID,
                    observingFacilityID: facilityUUID
                )
            )
        else {
            return nil
        }
        
        do {
            return try await URLSession.shared.decode(
                FacilityLocation.self,
                from: locationUrl
            )
        } catch {
            SSSLogger.error(message: error.localizedDescription)
            return nil
        }
    }
}
