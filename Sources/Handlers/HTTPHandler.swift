//
//  HTTPHandler.swift
//
//
//  Created by Aram Semerjyan on 06.02.24.
//

import NIO
import NIOHTTP1

final class HTTPHandler: ChannelInboundHandler {
    typealias InboundIn = HTTPServerRequestPart
    
    private let router: RouterInterface
    
    init(router: RouterInterface) {
        self.router = router
    }
    
    func channelRead(
        context: ChannelHandlerContext,
        data: NIOAny
    ) {
        let reqPart = unwrapInboundIn(data)
        
        switch reqPart {
        case .head(let header):
            SSSLogger.debug(message: header)
            
            let request = IncomingMessage(header: header)
            let response = ServerResponse(channel: context.channel)
            
            router.handle(
                request: request,
                response: response
            ) { (items: Any...) in
                response.status = .notFound
                response.send("Not found")
            }
        default:
            break
        }
    }
}
