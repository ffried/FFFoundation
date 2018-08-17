import XCTest
@testable import FFFoundation

// Unfortunately, Darwin XCTest does not really support *all* FloatingPoint types.
// https://github.com/apple/swift/blob/master/stdlib/public/SDK/XCTest/XCTest.swift#L379
#if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
internal func XCTAssertEqual<T: FloatingPoint>(_ expression1: @autoclosure () throws -> T, _ expression2: @autoclosure () throws -> T, accuracy: T, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
    XCTAssertNoThrow(try {
        let (value1, value2) = (try expression1(), try expression2())
        XCTAssert(!value1.isNaN && !value2.isNaN && abs(value1 - value2) <= accuracy,
                  message().isEmpty ? "(\"\(value1)\") is not equal to (\"\(value2)\") +/- (\"\(accuracy)\")" : message(),
                  file: file, line: line
        )
        }(), file: file, line: line)
}
internal func XCTAssertNotEqual<T: FloatingPoint>(_ expression1: @autoclosure () throws -> T, _ expression2: @autoclosure () throws -> T, accuracy: T, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
    XCTAssertNoThrow(try {
        let (value1, value2) = (try expression1(), try expression2())
        XCTAssert(value1.isNaN || value2.isNaN || abs(value1 - value2) > accuracy,
                  message().isEmpty ? "(\"\(value1)\") is equal to (\"\(value2)\") +/- (\"\(accuracy)\")" : message(),
                  file: file, line: line
        )
        }(), file: file, line: line)
}
#endif

class TriangleTests: XCTestCase {
    
    static let allTests : [(String, (TriangleTests) -> () throws -> Void)] = [
        ("testSimpleTriangleCalculation", testSimpleTriangleCalculation)
    ]
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSimpleTriangleCalculation() {
        let pointA = Point(x: 1, y: 1)
        let pointB = Point(x: 3, y: 4)

        let triangle = Triangle(orthogonallyWithA: pointA, b: pointB)
        
        XCTAssertEqual(triangle.pointA, pointA)
        XCTAssertEqual(triangle.pointB, pointB)
        XCTAssertEqual(triangle.pointC, Point(x: 1, y: 4))
        XCTAssertEqual(triangle.a, 2, accuracy: .ulpOfOne)
        XCTAssertEqual(triangle.b, 3, accuracy: .ulpOfOne)
        XCTAssertEqual(triangle.c, 3.60555127546399, accuracy: .ulpOfOne * 4)
        XCTAssertEqual(triangle.α, .radians(0.588002603547568), accuracy: .ulpOfOne * 2)
        XCTAssertEqual(triangle.β, .radians(0.982793723247329), accuracy: .ulpOfOne)
        XCTAssertEqual(triangle.γ, .pi / 2, accuracy: .ulpOfOne)
    }
    
    func testTriangleWithAllLengthsGiven() {
        let pointA = Point(x: 1, y: 1)
        let pointB = Point(x: 7, y: 3)
        let pointC = Point(x: 9, y: 7)
        
        // expectations
        let a = (4*4+2*2).squareRoot() as Point.Value
        let b = (6*6+8*8).squareRoot() as Point.Value
        let c = (2*2+6*6).squareRoot() as Point.Value
        let cosα = (b*b+c*c-a*a)/(2*b*c)
        let cosβ = (a*a+c*c-b*b)/(2*a*c)
        let cosγ = (a*a+b*b-c*c)/(2*a*b)
        
        let sut = Triangle(a: pointA, b: pointB, c: pointC)
        
        XCTAssertEqual(sut.pointA, pointA)
        XCTAssertEqual(sut.pointB, pointB)
        XCTAssertEqual(sut.pointC, pointC)
        XCTAssertEqual(sut.a, a)
        XCTAssertEqual(sut.b, b)
        XCTAssertEqual(sut.c, c)
        XCTAssertEqual(sut.α, Angle.radians(cosα.acos()))
        XCTAssertEqual(sut.β, Angle.radians(cosβ.acos()))
        XCTAssertEqual(sut.γ, Angle.radians(cosγ.acos()))
    }
}

fileprivate struct Point: Equatable, TriangulatablePoint {
    let x: Double
    let y: Double
    
    static func ==(lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
