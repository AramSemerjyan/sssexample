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
    
    mutating func run() throws {
        configureArguments()
        
        DI.shared.assemble()
        
        let app = Express(
            router: DI.shared.container.resolve(PolisRouter.self)!
        )

        app.listen(8888)
    }
}

// MARK: - Handle arguments

private extension Server {
    func configureArguments() {
        configurePolisUrl()
        configureFolderDir()
    }
    
    func configurePolisUrl() {
        guard let polisURL, let url = URL(string: polisURL) else {
            return
        }
        
        Constants.polisURL = url
    }
    
    func configureFolderDir() {
        guard let jsonFolderDir else { return }
        
        Constants.jsonFolderDir = jsonFolderDir
    }
}
