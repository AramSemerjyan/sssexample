//
//  SSSLogger.swift
//
//
//  Created by Aram Semerjyan on 07.02.24.
//

import Foundation

enum SSSLogger: String {
    case debug
    case success
    case warning
    case error
}

extension SSSLogger {
    static func debug(
        message: Any?,
        pathToFile: String = #file
    ) {
        log(for: .debug, message: message, pathToFile: pathToFile)
    }

    static func success(
        message: Any?,
        pathToFile: String = #file
    ) {
        log(for: .success, message: message, pathToFile: pathToFile)
    }

    static func warning(
        message: Any?,
        pathToFile: String = #file
    ) {
        log(for: .warning, message: message, pathToFile: pathToFile)
    }

    static func error(
        message: Any?,
        pathToFile: String = #file
    ) {
        log(for: .error, message: message, pathToFile: pathToFile)
    }
    
    static func fatal(
        message: String?,
        pathToFile: String = #file
    ) {
        fatalError(message ?? "fatal error")
    }
}

private extension SSSLogger {
    var title: String { self.rawValue.uppercased() }

    var symbol: String {
        switch self {
        case .debug:
            return "👨‍💻"
        case .success:
            return "✅"
        case .warning:
            return "⚠️"
        case .error:
            return "🛑"
        }
    }

    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"

        return formatter.string(from: Date())
    }
}

private extension SSSLogger {
    static func log(
        for type: SSSLogger,
        message: Any?,
        pathToFile: String
    ) {
        let fileName = (pathToFile as NSString)
            .lastPathComponent
            .replacingOccurrences(of: ".swift", with: "")
        let title: String = "\(type.date): \(fileName) - \(type.title) \(type.symbol)"
        let separator = String(repeating: "=", count: title.count).appending("=")

        let SSSLogger = createLog(
                    header: separator,
                    title: title,
                    message: message ?? "",
                    footer: separator
                )
        print(SSSLogger)
    }

    static func createLog(
        header: String,
        title: String,
        message: Any,
        footer: String
    ) -> String {
        return
          """
          \n\(header)\n
          \(title)\n
          \(message)\n
          \(footer)\n
          """
    }
}

