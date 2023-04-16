//
//  ConcentrationUITestsLaunchTests.swift
//  ConcentrationUITests
//
//  Created by Taner Mustafa on 16/04/2023.
//  Copyright © 2023 Michael Smith. All rights reserved.
//

import XCTest

final class PerformanceTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        false
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    /// Mocks latency increase by 5 seconds per usage
    func increaseLatencySeconds(by loadTime: Double) {
        let second: Double = 1000000
        usleep(useconds_t(loadTime * second))
    }
        
    /// Mocks memory usage increase by 5MB per usage
    func increaseMemoryUsage() {
        let numberOfBytes: Int = 5 * 1000 * 1000    // 5MB
        var buffer = [UInt8](repeating: 1, count: numberOfBytes)
        for i in 0 ..< numberOfBytes {
            buffer[i] = UInt8(i % 7)
        }
    }

    /// Returns heap memory usage in MB
    func report_memory() -> Double? {
        var info = mach_task_basic_info()
        let MACH_TASK_BASIC_INFO_COUNT = MemoryLayout<mach_task_basic_info>.stride/MemoryLayout<natural_t>.stride
        var count = mach_msg_type_number_t(MACH_TASK_BASIC_INFO_COUNT)

        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: MACH_TASK_BASIC_INFO_COUNT) {
                task_info(mach_task_self_,
                          task_flavor_t(MACH_TASK_BASIC_INFO),
                          $0,
                          &count)
            }
        }

        if kerr == KERN_SUCCESS {
            print("Memory in use (in bytes): \(info.resident_size)")
            let memoryUsageMB: Double = round(Double(info.resident_size) / 1024 / 1024)
            return memoryUsageMB
        }
        else {
            print("Error with task_info(): " +
                (String(cString: mach_error_string(kerr), encoding: String.Encoding.ascii) ?? "unknown error"))
            return nil
        }
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        
        NSLog("[Performance Testing] START - testLaunch")
        app.launch()
        increaseLatencySeconds(by: 5)
        increaseMemoryUsage()
        if let memoryUsageMB = report_memory() {
            NSLog("[Performance Testing] MEMORY_USAGE - testLaunch - \(memoryUsageMB)")
        }
        NSLog("[Performance Testing] END - testLaunch")
    }
    
    func testCustomScenario() throws {
        let app = XCUIApplication()
        app.launch()
        
        NSLog("[Performance Testing] START - testCustomScenario")
        increaseLatencySeconds(by: 2)
        app.staticTexts["NEW GAME"].tap()
        increaseLatencySeconds(by: 3)
        increaseMemoryUsage()
        increaseMemoryUsage()
        if let memoryUsageMB = report_memory() {
            NSLog("[Performance Testing] MEMORY_USAGE_MB - testLaunch - \(memoryUsageMB)")
        }
        NSLog("[Performance Testing] END - testCustomScenario")
    }
}
