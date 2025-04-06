//
//  MoveImportToTopCommand.swift
//  ImPower
//
//  Created by Jatin Mishra.
//

import Foundation
import XcodeKit

class MoveImportToTopCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        var bufferLines = invocation.buffer.lines
        guard let cursorSelection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
            completionHandler(nil)
            return
        }

        let cursorLine = cursorSelection.start.line

        if let line = (bufferLines[cursorLine] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines),
           line.starts(with: "import ") {
            moveNewImportToTop(line, at: cursorLine, in: &bufferLines)
        }

        completionHandler(nil)
    }

    /// Moves the newly added import statement to the top of the buffer, just below existing imports
    private func moveNewImportToTop(
        _ newImport: String,
        at originalIndex: Int,
        in buffer: inout NSMutableArray
    ) {
        // Step 1: Find all existing import statements
        let importIndices = buffer.enumerated().compactMap { (index, line) -> Int? in
            guard let lineString = line as? String, lineString.starts(with: "import ") else {
                return nil
            }
            return index
        }
        
        // Step 2: If there are existing imports, insert the new import below them
        if !importIndices.isEmpty {
            let lastImportIndex = importIndices.last!
            buffer.insert(newImport, at: lastImportIndex + 1)
        } else {
            // If no imports are found, insert it at the top
            buffer.insert(newImport, at: 0)
        }
        
        // Step 3: Remove the duplicate line where the import statement was originally placed
        buffer.removeObject(at: originalIndex + 1)
    }
}
