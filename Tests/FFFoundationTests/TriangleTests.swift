import XCTest
@testable import FFFoundation

// Unfortunately, Darwin XCTest does not really support *all* FloatingPoint types.
// https://github.com/apple/swift/blob/master/stdlib/public/SDK/XCTest/XCTest.swift#L379
#if !os(Linux)
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

final class TriangleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTriangleBeingEquatable() {
        let triangle1 = Triangle(orthogonallyOnCWithA: Point(x: 1, y: 1),
                                b: Point(x: 3, y: 4))
        let triangle2 = Triangle(orthogonallyOnCWithA: Point(x: 2, y: 2),
                                 b: Point(x: 4, y: 5))
        XCTAssertEqual(triangle1, triangle2)
    }

    func testTriangleBeingHashable() {
        var hasher1 = Hasher()
        let triangle1 = Triangle(orthogonallyOnCWithA: Point(x: 1, y: 1),
                                 b: Point(x: 3, y: 4))
        triangle1.hash(into: &hasher1)
        var hasher2 = Hasher()
        let triangle2 = Triangle(orthogonallyOnCWithA: Point(x: 2, y: 2),
                                 b: Point(x: 4, y: 5))
        triangle2.hash(into: &hasher2)
        XCTAssertEqual(hasher1.finalize(), hasher2.finalize())
    }
    
    func testOrthogonalTriangleCalculation() {
        let pointA = Point(x: 1, y: 1)
        let pointB = Point(x: 3, y: 4)

        let triangle = Triangle(orthogonallyOnCWithA: pointA, b: pointB)
        
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

    func testOrthogonalTriangleWithSinglePoint() {
        let point = Point(x: 0, y: 0)
        let triangle = Triangle(orthogonallyOnCWithA: point, b: point)
        XCTAssertEqual(triangle.points.a, point)
        XCTAssertEqual(triangle.points.b, point)
        XCTAssertEqual(triangle.points.c, point)
        XCTAssertEqual(triangle.sides.a, 0)
        XCTAssertEqual(triangle.sides.b, 0)
        XCTAssertEqual(triangle.sides.c, 0)
        XCTAssertTrue(triangle.angles.α.isNaN)
        XCTAssertTrue(triangle.angles.β.isNaN)
        XCTAssertEqual(triangle.angles.γ, .pi / 2, accuracy: .ulpOfOne)
    }
    
    func testTriangleWithAllPointsGiven() {
        let pointA = Point(x: 1, y: 1)
        let pointB = Point(x: 7, y: 3)
        let pointC = Point(x: 9, y: 7)
        let a: Point.Value = (4 * 4 + 2 * 2).squareRoot()
        let b: Point.Value = (6 * 6 + 8 * 8).squareRoot()
        let c: Point.Value = (2 * 2 + 6 * 6).squareRoot()
        let cosα = (b * b + c * c - a * a) / (2 * b * c)
        let cosβ = (a * a + c * c - b * b) / (2 * a * c)
        let cosγ = (a * a + b * b - c * c) / (2 * a * b)
        
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

    func testTriangleWithAllPointsBeingTheSame() {
        let point = Point(x: 0, y: 0)
        let triangle = Triangle(a: point, b: point, c: point)
        XCTAssertEqual(triangle.points.a, point)
        XCTAssertEqual(triangle.points.b, point)
        XCTAssertEqual(triangle.points.c, point)
        XCTAssertEqual(triangle.sides.a, 0)
        XCTAssertEqual(triangle.sides.b, 0)
        XCTAssertEqual(triangle.sides.c, 0)
        XCTAssertTrue(triangle.angles.α.isNaN)
        XCTAssertTrue(triangle.angles.β.isNaN)
        XCTAssertTrue(triangle.angles.γ.isNaN)
    }
}

fileprivate struct Point: Equatable, TriangulatablePoint {
    let x: Double
    let y: Double
}
