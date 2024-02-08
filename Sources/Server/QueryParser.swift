//
//  QueryParser.swift
//
//
//  Created by Aram Semerjyan on 06.02.24.
//

import Foundation

let paramDictKey = "query.param"

func queryParam(
    req: IncomingMessage,
    res: ServerResponse,
    next: @escaping Next
) {
    if let queryItems = URLComponents(string: req.header.uri)?.queryItems {
        req.userInfo[paramDictKey] = Dictionary(
            grouping: queryItems,
            by: { $0.name }
        ).mapValues { $0.compactMap({ $0.value }).joined(separator: ",") }
    }
    
    next()
}
