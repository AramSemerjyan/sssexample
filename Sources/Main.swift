import ArgumentParser
import Foundation
import NIO
import NIOHTTP1

@main
struct Server: ParsableCommand {
    @Option
    var polisURL: String?
    @Option
    var jsonFolderDir: String?
    @Option
    var host: String?
    @Option
    var port: Int?
    
    mutating func run() throws {
        configureArguments()
        
        DI.shared.assemble()
        
        let app = Express(
            router: DI.shared.container.resolve(PolisRouter.self)!
        )

        app.listen(Constants.port)
    }
}

// MARK: - Handle arguments

private extension Server {
    func configureArguments() {
        configurePolisUrlArgument()
        configureFolderDirArgument()
        configureServerArguments()
    }
    
    func configurePolisUrlArgument() {
        guard let polisURL, let url = URL(string: polisURL) else {
            return
        }
        
        Constants.polisURL = url
    }
    
    func configureFolderDirArgument() {
        guard let jsonFolderDir else { return }
        
        Constants.jsonFolderDir = jsonFolderDir
    }
    
    func configureServerArguments() {
        if let host {
            Constants.host = host
        }
        
        if let port {
            Constants.port = port
        }
    }
}
