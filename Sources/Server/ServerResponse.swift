//
//  ServerResponse.swift
//  
//
//  Created by Aram Semerjyan on 06.02.24.
//

import NIO
import NIOHTTP1
import Foundation

final class ServerResponse {
    var status = HTTPResponseStatus.ok
    var headers = HTTPHeaders()
    let channel: Channel
    var didWriteHeader = false
    var didEnd = false
    
    init(channel: Channel) {
        self.channel = channel
    }
    
    func send(_ message: String) {
        flushHeader()
        
        var buffer = channel.allocator.buffer(capacity: message.count)
        buffer.writeString(message)
        
        let part = HTTPServerResponsePart.body(.byteBuffer(buffer))
        
        _ = channel.writeAndFlush(part)
            .recover(handleError)
            .map(end)
    }
    
    func flushHeader() {
        guard !didWriteHeader else { return }
        didWriteHeader = true
        
        let head = HTTPResponseHead(
            version: .init(major: 1, minor: 1),
            status: status,
            headers: headers
        )
        let part = HTTPServerResponsePart.head(head)
        _ = channel.writeAndFlush(part).recover(handleError)
    }
    
    func handleError(_ error: Error) {
        SSSLogger.error(message: error.localizedDescription)
        end()
    }
    
    func end() {
        guard !didEnd else { return }
        didEnd = true
        _ = channel.writeAndFlush(HTTPServerResponsePart.end(nil))
            .map { self.channel.close() }
    }
}

extension ServerResponse {
    func json<T: Encodable>(_ model: T) {
        let data: Data
        
        do {
            data = try JSONEncoder().encode(model)
        } catch {
            return handleError(error)
        }
        
        self["Content-Type"] = "aplication/json"
        self["Content-Length"] = "\(data.count)"
        
        flushHeader()
        
        var buffer = channel.allocator.buffer(capacity: data.count)
        buffer.writeBytes(data)
        let part = HTTPServerResponsePart.body(.byteBuffer(buffer))
        
        _ = channel.writeAndFlush(part)
            .recover(handleError)
            .map(end)
    }
}

extension ServerResponse {
    subscript(name: String) -> String? {
        set {
            assert(!didWriteHeader, "header is out!")
            if let newValue {
                headers.replaceOrAdd(name: name, value: newValue)
            } else {
                headers.remove(name: name)
            }
        }
        get {
            headers[name].joined(separator: ",")
        }
    }
}
