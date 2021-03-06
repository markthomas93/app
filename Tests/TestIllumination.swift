@testable import Moonraker
import XCTest

final class TestIllumination: XCTestCase {
    private var moonraker: Moonraker!
    
    override func setUp() {
        moonraker = .init()
    }
    
    func testPhase() {
        XCTAssertEqual(.waxingGibbous, moonraker.illumination(1300000000).0)
    }
    
    func testFraction() {
        XCTAssertEqual(0.5490432602177777, moonraker.illumination(1300000000).1)
    }
    
    func testAngle() {
        XCTAssertEqual(-1.5893102315841525, moonraker.illumination(1300000000).2)
    }
    
    func testDays() {
        XCTAssertEqual(4088.7962962961756, moonraker.days(1300000000))
    }
    
    func testSunDeclination() {
        XCTAssertEqual(0.09136648771862077, moonraker.sunCoords(5000).0)
    }
    
    func testSunRightAscension() {
        XCTAssertEqual(2.928664200072675, moonraker.sunCoords(5000).1)
    }
    
    func testMoonRightAscension() {
        XCTAssertEqual(-2.5731558790135023, moonraker.moonCoords(5000).0)
    }
    
    func testMoonDeclination() {
        XCTAssertEqual(-0.22925186514190146, moonraker.moonCoords(5000).1)
    }
    
    func testMoonDistance() {
        XCTAssertEqual(374571.2587323985, moonraker.moonCoords(5000).2)
    }
    
    func testSolarMeanAnomaly() {
        XCTAssertEqual(92.24990993958214, moonraker.solarMeanAnomaly(5000))
    }
    
    func testSunEclipticLongitude() {
        XCTAssertEqual(97.15794246793237, moonraker.sunEclipticLongitude(92.24990993958214))
    }
    
    func testDeclination() {
        XCTAssertEqual(0.09136648771862077, moonraker.declination(0, 97.15794246793237))
    }
    
    func testRightAscension() {
        XCTAssertEqual(2.928664200072675, moonraker.rightAscension(0, 97.15794246793237))
    }
}
