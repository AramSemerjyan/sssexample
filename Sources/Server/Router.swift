//
//  Router.swift
//
//
//  Created by Aram Semerjyan on 06.02.24.
//

protocol RouterInterface {
    func use(_ middleware: Middleware...)
    func handle(
        request: IncomingMessage,
        response: ServerResponse,
        next upperNext: @escaping Next
    )
}

extension RouterInterface {
    func get(
        _ path: String = "",
        middleware: @escaping Middleware
    ) {
        use { req, res, next in
            guard
                req.header.method == .GET,
                req.header.uri.hasPrefix(path)
            else { return next() }
            
            middleware(req, res,next)
        }
    }
}

class Router: RouterInterface {
    private var middleware = [Middleware]()
    
    func setUp() {
        use(queryParam)
    }
    
    func use(_ middleware: Middleware...) {
        self.middleware.append(contentsOf: middleware)
    }
    
    func handle(
        request: IncomingMessage,
        response: ServerResponse,
        next upperNext: @escaping Next
    ) {
        let stack = self.middleware
        guard !stack.isEmpty else { return upperNext() }
        
        var next: Next? = { (args: Any...) in }
        var i = stack.startIndex
        
        next = { (args: Any...) in
            let middleware = stack[i]
            i = stack.index(after: i)
            
            let isLast = i == stack.endIndex
            middleware(
                request,
                response,
                isLast ? upperNext : next!
            )
        }
        
        if let next {
            next()
        }
    }
}
