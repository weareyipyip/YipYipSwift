//
//  DocumentsFileUtils.swift
//  Pods-YipYipSwiftExample
//
//  Created by Rens Wijnmalen on 03/07/2020.
//

import Foundation

public class DocumentsFileUtils {
    
    private var fileManager = FileManager.default
    
    // ----------------------------------------------------
    // MARK: - String
    // ----------------------------------------------------
    
    public func set(value: String, fileName: String) -> Bool {
        let filePath = self.getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            try value.write(to: filePath, atomically: true, encoding: String.Encoding.utf8)
            return true
        } catch {
            return false
        }
    }
    
    public func delete(fileName: String) -> Bool {
        let filePath = self.getDocumentsDirectory().appendingPathComponent(fileName)
        if self.fileManager.fileExists(atPath: filePath.path) {
            do {
                try self.fileManager.removeItem(at: filePath)
                return true
            } catch {
                return false
            }
        }
        return false
    }
    
    public func string(fileName: String) -> String? {
        let filePath = self.getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            let data = try Data(contentsOf: filePath)
            return String(data: data, encoding: String.Encoding.utf8)
        }  catch {
            return nil
        }
    }
    
    // ----------------------------------------------------
    // MARK: - Private methods
    // ----------------------------------------------------
    
    private func getDocumentsDirectory() -> URL {
        let paths = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

