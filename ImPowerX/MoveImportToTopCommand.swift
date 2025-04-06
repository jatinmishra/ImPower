//
//  MoveImportToTopCommand.swift
//  ImPower
//
//  Created by Jatin Mishra.
//

import Foundation
import XcodeKit

/// Command to move a newly added `import` statement (at the cursor) to the top of the file,
/// just below existing import statements.
class MoveImportToTopCommand: NSObject, XCSourceEditorCommand {

    /// Entry point triggered by Xcode when the command is run.
    ///
    /// - Parameters:
    ///   - invocation: The current editor context, including the text buffer and cursor position.
    ///   - completionHandler: A closure to call after the command finishes.
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

    /// Moves the newly added import statement to the appropriate location in the buffer.
    ///
    /// - Parameters:
    ///   - newImport: The import statement to move (e.g., `"import SwiftUI"`).
    ///   - originalIndex: The index where the import was originally inserted.
    ///   - buffer: The entire buffer of source code lines.
    func moveNewImportToTop(
        _ newImport: String,
        at originalIndex: Int,
        in buffer: inout NSMutableArray
    ) {
        // Find all existing import lines
        let importIndices = buffer.enumerated().compactMap { (index, line) -> Int? in
            guard let lineString = line as? String, lineString.starts(with: "import ") else {
                return nil
            }
            return index
        }

        if !importIndices.isEmpty {
            // Insert new import after last existing import
            let lastImportIndex = importIndices.last!
            buffer.insert(newImport, at: lastImportIndex + 1)
        } else {
            // If no other imports exist, place at top
            buffer.insert(newImport, at: 0)
        }

        // Adjust removal index if insertion was before original
        let removeIndex = originalIndex >= buffer.count ? buffer.count - 1 : originalIndex + 1
        buffer.removeObject(at: removeIndex)
    }
}
