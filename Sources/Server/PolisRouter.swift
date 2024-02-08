//
//  PolisRouter.swift
//
//
//  Created by Aram Semerjyan on 07.02.24.
//

import Foundation

final class PolisRouter: Router {
    private let polisService: PolisServiceInterface
    
    init(polisService: PolisServiceInterface) {
        self.polisService = polisService
        
        super.init()
        
        setUpRoutes()
    }
}

extension PolisRouter {
    func setUpRoutes() {
        super.setUp()
        
        get("/updateDate") { _, res, _ in
            res.send(self.polisService.getDirectoryLastUpdateDate())
        }

        get("/directory") { _, res, _ in
            res.json(self.polisService.getDirectory())
        }

        get("/numberOfObservingFacilities")   { _, res, _ in
            res.send("\(self.polisService.getNumberOfFacilitiesInDirectory())")
        }

        get("/search") { req, res, _ in
            let result = self.polisService.getUUIDOfFacilities(withName: req.param("name") ?? "")
            
            res.json(result)
        }

        get("/location") { req, res, _ in
            let id = req.param("uuid") ?? ""
            
            let location = self.polisService.getLocationOfFacility(withId: id)
            let result = [
                "long": location?.eastLongitude?.doubleValue,
                "lat": location?.latitude?.doubleValue
            ]
            
            res.json(result)
        }
    }
}
