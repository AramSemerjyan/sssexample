//
//  Express.swift
//
//
//  Created by Aram Semerjyan on 06.02.24.
//

import NIO
import NIOHTTP1

final class Express {
    private let router: RouterInterface
    private let loopGroup = MultiThreadedEventLoopGroup(
        numberOfThreads: System.coreCount
    )
    
    init(router: RouterInterface) {
        self.router = router
    }
    
    func listen(_ port: Int) {
        let reuseAddrOpt = ChannelOptions.socket(
            SocketOptionLevel(SOL_SOCKET),
            SO_REUSEADDR
        )
        
        let bootstrap = ServerBootstrap(group: loopGroup)
            .serverChannelOption(
                ChannelOptions.backlog,
                value: 256
            )
            .serverChannelOption(
                reuseAddrOpt,
                value: 1
            )
            .childChannelInitializer { channel in
                channel.pipeline.configureHTTPServerPipeline()
                    .flatMap { channel.pipeline.addHandler(
                        HTTPHandler(router: self.router)
                    ) }
            }
            .childChannelOption(
                ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY),
                value: 1
            )
            .childChannelOption(
                reuseAddrOpt,
                value: 1
            )
            .childChannelOption(
                ChannelOptions.maxMessagesPerRead,
                value: 1
            )
        
        do {
            let serverChannel = try bootstrap.bind(
                host: Constants.host,
                port: port
            )
            .wait()
            
            SSSLogger.debug(message: "Server running on: \(serverChannel.localAddress!)")
            
            try serverChannel.closeFuture.wait() // runs forever
        } catch {
            SSSLogger.fatal(message: "Failed to start server: \(error)")
        }
    }
}
