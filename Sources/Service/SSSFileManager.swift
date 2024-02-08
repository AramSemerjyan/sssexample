//
//  File.swift
//  
//
//  Created by Aram Semerjyan on 08.02.24.
//

import Foundation

protocol SSSFileManagerInterface {
    func save(data: Data, withType type: SSSFileType) throws
    func getFile(_ type: SSSFileType) throws -> Data?
}

final class SSSFileManager: SSSFileManagerInterface {
    private let repoDir = Bundle.main.bundleURL.appendingPathComponent(
        Constants.jsonFolderDir,
        isDirectory: true
    )
    
    func save(data: Data, withType type: SSSFileType) throws {
        try checkDir()
        try data.write(to: repoDir.appending(path: type.nameWithExt))
    }
    
    func getFile(_ type: SSSFileType) throws -> Data? {
        if
            let filePath = URL(string: "\(repoDir.absoluteString)/\(type.nameWithExt)")
        {
            return try Data(contentsOf: filePath)
        }
        
        return nil
    }
}

private extension SSSFileManager {
    func checkDir() throws {
        let exists = FileManager.default.fileExists(
            atPath: repoDir.absoluteString.replacingOccurrences(of: "file://", with: "")
        )
        
        if !exists {
            try FileManager.default.createDirectory(
                at: repoDir.absoluteURL,
                withIntermediateDirectories: true
            )
        }
    }
}
