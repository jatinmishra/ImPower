//
//  SortImportsCommand.swift
//  ImPower
//
//  Created by Jatin Mishra.
//

import Foundation
import XcodeKit

/// Command to sort import statements in an Xcode source file.
class SortImportsCommand: NSObject, XCSourceEditorCommand {
    
    /// Performs the sorting of import statements in the source editor's buffer.
    ///
    /// This method extracts the import statements from the buffer, sorts them by length (longest to shortest),
    /// and replaces the original import statements with the sorted ones.
    ///
    /// - Parameters:
    ///   - invocation: The command invocation containing the buffer with source code.
    ///   - completionHandler: A closure to be called after the operation completes, with an optional error.
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        var bufferLines = invocation.buffer.lines
        
        // Extract import statements from the buffer and remove duplicates
        let updatedImportStatements = extractImportStatements(from: bufferLines)
        
        // Sort the imports by length (longest to shortest)
        let sortedImports = updatedImportStatements.map { $0.1 }.sorted { $0.count > $1.count }
        
        // Replace the original import statements with the sorted ones
        replaceImportStatements(in: &bufferLines, with: sortedImports)
        
        // Call the completion handler with no error
        completionHandler(nil)
    }

    /// Extracts all the import statements and their line numbers from the buffer,
    /// removing any duplicate import statements.
    ///
    /// - Parameter buffer: The source code buffer containing lines of code.
    /// - Returns: A tuple array containing the line number and the import statement, without duplicates.
    private func extractImportStatements(from buffer: NSMutableArray) -> [(Int, String)] {
        var uniqueImports: [(Int, String)] = []  // List to store unique imports with line numbers
        
        // Iterate over each line in the buffer
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
    ///
    /// - Parameters:
    ///   - buffer: The source code buffer to modify. The buffer will be updated in place.
    ///   - sortedImports: An array of sorted import statements to insert into the buffer.
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
    ///
    /// This method identifies the first line that isn't a comment and determines the line number
    /// where imports should be inserted (just below any top comments).
    ///
    /// - Parameter buffer: The source code buffer to analyze.
    /// - Returns: The index of the line where the imports should be inserted.
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
}

