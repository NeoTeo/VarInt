//
//  VarIntTests.swift
//  VarIntTests
//
//  Created by Teo on 01/10/15.
//  Licensed under MIT See LICENCE file in the root of this project for details.
//

import XCTest
@testable import VarInt

class VarIntTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testStreamUVarIntEmpty() {
        
        let emptyBuffer: [UInt8] = []
        
        XCTAssert(try! streamUVarInt(emptyBuffer) == 0 )
    }
    
    func testStreamUVarIntOverflow() {
        
        let overflowBuffer: [UInt8] = [144, 192, 192, 129, 132, 136, 140, 144, 192, 192, 1, 1]
        do {
            try _ = streamUVarInt(overflowBuffer)
        } catch VarIntError.overflow {
            print("try failed so the operation overflowed")
        } catch {
            XCTFail("try failed for an unexpected reason")
        }
    }
    
    
    func testStreamUVarIntBuffer() {
        let buffer: [UInt8]         = [144, 192, 192, 129, 132, 136, 140, 144, 16, 0, 1, 1]
        
        XCTAssert(try! streamUVarInt(buffer) == 1161981756374523920)
        
    }
    
    func testStreamVarIntEmpty() {
        
        let emptyBuffer: [UInt8] = []
        XCTAssert(try! streamVarInt(emptyBuffer) == 0 )
    }
    
    func testStreamVarIntBuffer() {
        let buffer: [UInt8] = [144, 192, 192, 129, 132, 136, 140, 144, 16, 0, 1, 1]
        
        XCTAssert(try! streamVarInt(buffer) == 580990878187261960)
    }
    
    func testStreamVarIntOverflow() {
        
        let overflowBuffer: [UInt8] = [144, 192, 192, 129, 132, 136, 140, 144, 192, 192, 1, 1]
        do {
            try _ = streamVarInt(overflowBuffer)
        } catch VarIntError.overflow {
            print("try failed so the operation overflowed")
        } catch {
            XCTFail("try failed for an unexpected reason")
        }
    }
    
    
    
    /// Utility methods to avoid repetition
    func streamVarInt(_ buffer: [UInt8]) throws -> Int64 {
        let data: Data = Data(bytes: UnsafePointer<UInt8>(buffer), count: buffer.count)
        let stream: InputStream = InputStream(data: data)
        stream.open()
        
        let result = try readVarInt(stream)
        
        stream.close()
        
        return result
    }
    
    func streamUVarInt(_ buffer: [UInt8]) throws -> UInt64 {
        let data: Data = Data(bytes: UnsafePointer<UInt8>(buffer), count: buffer.count)
        let stream: InputStream = InputStream(data: data)
        stream.open()
        
        let result = try readUVarInt(stream)
        
        stream.close()
        
        return result
    }
    
    
}
