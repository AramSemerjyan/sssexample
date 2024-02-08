//
//  DI.swift
//
//
//  Created by Aram Semerjyan on 07.02.24.
//

import Swinject
import SwinjectAutoregistration

class DI {
    let container = Container()
    
    static let shared = DI()
    
    func assemble() {
        container.autoregister(
            PolisRouter.self,
            initializer: PolisRouter.init
        )
        
        container.autoregister(
            PolisRepoInterface.self,
            initializer: PolisRepo.init
        )
        
        container.autoregister(
            PolisFetchServiceInterface.self,
            initializer: PolisFetchService.init
        )
        
        container.autoregister(
            PolisServiceInterface.self,
            initializer: PolisService.init
        )
        
        container.autoregister(
            SSSFileManagerInterface.self,
            initializer: SSSFileManager.init
        )
    }
}
