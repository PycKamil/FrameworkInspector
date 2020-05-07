//
//  FrameworkDescriptionProvider.swift
//  FrameworkInspector
//
//  Created by Kamil Pyc on 07/05/2020.
//  Copyright © 2020 Kamil Pyc. All rights reserved.
//

import Foundation
import Shell

struct FrameworkDescriptionProvider {
    let frameworkUrl: URL
    
    var frameworkDescription: FrameworkDescription {
        let name = frameworkUrl.lastPathComponent
        guard let executableName = name.components(separatedBy: ".framework").first else { return FrameworkDescription(name: name, type: .unknown("Invalid framework"), architectures: []) }
        let fileSystemRepresentation = frameworkUrl.standardizedFileURL.absoluteString.replacingOccurrences(of: "file://", with: "") + executableName
        let result = shell.usr.bin.file(fileSystemRepresentation)
        if result.isSuccess {
            let fileOutput = result.stdout
            let type: FrameworkType
            if fileOutput.contains("dynamically linked") {
                type = .dynamic
            } else {
                type = .staticLink
            }
            let lines = fileOutput.split(separator: "\n")
            let architectures = lines.compactMap { String($0).slice(from: "(for architecture", to: ")")}
            return FrameworkDescription(name: name, type: type, architectures: architectures)

        }
        return FrameworkDescription(name: name, type: .unknown(result.stderr), architectures: [])
    }
}

extension String {

    func slice(from: String, to: String) -> String? {
        guard let rangeFrom = range(of: from)?.upperBound else { return nil }
        guard let rangeTo = self[rangeFrom...].range(of: to)?.lowerBound else { return nil }
        return String(self[rangeFrom..<rangeTo])
    }

}
