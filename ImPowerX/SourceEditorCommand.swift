//
//  SourceEditorCommand.swift
//  ImPowerX
//
//  Created by Jatin Mishra.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        var buffer = invocation.buffer.lines
        
        guard let cursorSelection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
            completionHandler(nil)
            return
        }
        
        let cursorLine = cursorSelection.start.line
        
        if let line = (buffer[cursorLine] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines), line.starts(with: "import ") {
            moveNewImportToTop(line, at: cursorLine, in: &buffer)
        }
        
        let updatedImportStatements = extractImportStatements(from: buffer)
        
        let sortedImports = updatedImportStatements.map { $0.1 }.sorted { $0.count > $1.count }
        
        replaceImportStatements(in: &buffer, with: sortedImports)
        
        completionHandler(nil)
    }
    
    /// Extracts all the import statements and their line numbers from the buffer,
    /// removing any duplicate import statements.
    private func extractImportStatements(from buffer: NSMutableArray) -> [(Int, String)] {
        var uniqueImports: [(Int, String)] = []  // List to store unique imports with line numbers
        
        for (index, line) in buffer.enumerated() {
            guard let lineString = line as? String, lineString.starts(with: "import ") else {
                continue
            }
            
            // Only add to uniqueImports if it's not already present
            if !uniqueImports.contains(where: { $0.1 == lineString }) {
                uniqueImports.append((index, lineString))
            }
        }
        
        return uniqueImports
    }
    
    /// Replaces the original import statements with the sorted imports in the buffer.
    private func replaceImportStatements(
        in buffer: inout NSMutableArray,
        with sortedImports: [String]
    ) {
        // Find indices of all the import statements
        let importIndices = buffer.enumerated().compactMap { (index, line) -> Int? in
            guard let lineString = line as? String, lineString.starts(with: "import ") else {
                return nil
            }
            return index
        }
        
        // Create an IndexSet from the indices of the import statements
        let indexSet = IndexSet(importIndices)
        
        // Remove all lines that are imports
        buffer.removeObjects(at: indexSet)
        
        // Find the position for inserting the imports: below comments at the top
        let positionToInsertImports = findPositionForImportInsertion(in: buffer)
        
        // Now, insert the sorted imports at the position found
        sortedImports.forEach { importStatement in
            buffer.insert(importStatement, at: positionToInsertImports)
        }
    }
    
    /// Finds the position in the buffer to insert the import statements, just below the top comments.
    private func findPositionForImportInsertion(in buffer: NSMutableArray) -> Int {
        var position = 0
        // Iterate through the lines to find the last comment before the imports
        for (index, line) in buffer.enumerated() {
            if let lineString = line as? String {
                if lineString.starts(with: "//") || lineString.starts(with: "/*") {
                    position = index + 2  // Set position to the line after the last comment
                } else {
                    break  // Stop once we hit the first non-comment line
                }
            }
        }
        return position
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
