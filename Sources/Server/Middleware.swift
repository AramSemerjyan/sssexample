//
//  Middleware.swift
//
//
//  Created by Aram Semerjyan on 06.02.24.
//

typealias Next = ( Any... ) -> Void

typealias Middleware = (
    IncomingMessage,
    ServerResponse,
    @escaping Next
) -> Void
