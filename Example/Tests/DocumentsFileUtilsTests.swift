//
//  DocumentsFileUtilsTests.swift
//  YipYipSwift_Tests
//
//  Created by Rens Wijnmalen on 03/07/2020.
//  Copyright © 2020 YipYip. All rights reserved.
//

import XCTest
import YipYipSwiftExample
import YipYipSwift

class DocumentsFileUtilsTests: XCTestCase {

    private let testFileName: String = "unitTestFile.txt"
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        let _ = YipYipUtils.documents.delete(fileName: self.testFileName)
    }

    func testManageSavedString() throws {
        let initialContent: String = "This is a test file"
        
        // Save a new file
        let fileSaved = YipYipUtils.documents.set(value: initialContent, fileName: self.testFileName)
        XCTAssert(fileSaved, "Saving string did not succeed")
        
        // Get the files content
        let content = YipYipUtils.documents.string(fileName: self.testFileName)
        XCTAssertEqual(content, initialContent, "Initial content not the same as the content of the file")
        
        // Update the content
        let updatedInitialContent: String = "This is new content"
        let fileUpdated = YipYipUtils.documents.set(value: updatedInitialContent, fileName: self.testFileName)
        XCTAssert(fileUpdated, "Updating string did not succeed")
        
        // Validate updated content
        let updatedContent = YipYipUtils.documents.string(fileName: self.testFileName)
        XCTAssertEqual(updatedContent, updatedInitialContent, "Updated content is not the same as the updated initial content")
        
        // Delete file
        let deleted = YipYipUtils.documents.delete(fileName: self.testFileName)
        XCTAssert(deleted, "Deleting the file did fail")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
