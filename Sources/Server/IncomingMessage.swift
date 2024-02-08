//
//  IncomingMessage.swift
//
//
//  Created by Aram Semerjyan on 06.02.24.
//

import NIOHTTP1

final class IncomingMessage {
    let header: HTTPRequestHead
    var userInfo = [String: Any]()
    
    init(header: HTTPRequestHead) {
        self.header = header
    }
}

extension IncomingMessage {
    func param(_ id: String) -> String? {
        return (userInfo[paramDictKey] as? [String: String])?[id]
    }
}
