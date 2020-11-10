//
//  AppDelegate+Log.swift
//  LEGOSwiftFastApp
//
//  Created by 马陈爽 on 2020/11/9.
//

import Foundation
import XCGLogger


let appDelegate = UIApplication.shared.delegate as! AppDelegate
let logger: XCGLogger = {
    let log = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)

    // Create a destination for the system console log (via NSLog)
    let systemDestination = AppleSystemLogDestination(identifier: "advancedLogger.appleSystemLogDestination")

    // Optionally set some configuration options
    systemDestination.outputLevel = .debug
    systemDestination.showLogIdentifier = false
    systemDestination.showFunctionName = true
    systemDestination.showThreadName = true
    systemDestination.showLevel = true
    systemDestination.showFileName = true
    systemDestination.showLineNumber = true

    // Add the destination to the logger
    log.add(destination: systemDestination)
    
    // Create a file log destination
    let logPath: URL = appDelegate.documentsDirectory.appendingPathComponent("XCGLogger_Log.txt")
    let autoRotatingFileDestination = AutoRotatingFileDestination(writeToFile: logPath, identifier: "advancedLogger.fileDestination", shouldAppend: true,
                                                                  attributes: [.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication], // Set file attributes on the log file
                                                                  maxFileSize: 1024 * 1024 * 10,
                                                                  maxTimeInterval: 60 * 60 * 24,
                                                                  targetMaxLogFiles: 7)

    // Optionally set some configuration options
    autoRotatingFileDestination.outputLevel = .debug
    autoRotatingFileDestination.showLogIdentifier = false
    autoRotatingFileDestination.showFunctionName = true
    autoRotatingFileDestination.showThreadName = true
    autoRotatingFileDestination.showLevel = true
    autoRotatingFileDestination.showFileName = true
    autoRotatingFileDestination.showLineNumber = true
    autoRotatingFileDestination.showDate = true

    // Process this destination in the background
    autoRotatingFileDestination.logQueue = XCGLogger.logQueue
    
    // Add the destination to the logger
    log.add(destination: autoRotatingFileDestination)
    log.logAppDetails()
    
    let emojiLogFormatter = PrePostFixLogFormatter()
    emojiLogFormatter.apply(prefix: "🗯", postfix: "", to: .verbose)
    emojiLogFormatter.apply(prefix: "🔹", postfix: "", to: .debug)
    emojiLogFormatter.apply(prefix: "ℹ️", postfix: "", to: .info)
    emojiLogFormatter.apply(prefix: "✳️", postfix: "", to: .notice)
    emojiLogFormatter.apply(prefix: "⚠️", postfix: "", to: .warning)
    emojiLogFormatter.apply(prefix: "‼️", postfix: "", to: .error)
    emojiLogFormatter.apply(prefix: "💣", postfix: "", to: .severe)
    emojiLogFormatter.apply(prefix: "🛑", postfix: "", to: .alert)
    emojiLogFormatter.apply(prefix: "🚨", postfix: "", to: .emergency)
    log.formatters = [emojiLogFormatter]
    return log
}()

let log: XCGLogger = logger

// MARK: - 日志
extension AppDelegate {

    var documentsDirectory: URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.endIndex - 1]
    }
    
    func getLogFilePath() -> String? {
        guard let fileDestination = log.destination(withIdentifier: "advancedLogger.fileDestination") as? AutoRotatingFileDestination else { return nil }
        guard let url = fileDestination.writeToFileURL else { return nil }
        return url.path
    }
    
    func getLogFileContent() -> String? {
        guard let fileDestination = log.destination(withIdentifier: "advancedLogger.fileDestination") as? AutoRotatingFileDestination else { return nil }
        guard let url = fileDestination.writeToFileURL else { return nil }
        do {
            let data = try Data(contentsOf: url)
            let content = String(data: data, encoding: .utf8)
            return content
        } catch  {
            log.error("\(error.localizedDescription)")
        }
        return nil
    }
}
