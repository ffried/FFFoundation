import XCTest
@testable import FFFoundation

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
        XCTAssertEqualWithAccuracy(triangle.a, 2, accuracy: .ulpOfOne)
        XCTAssertEqualWithAccuracy(triangle.b, 3, accuracy: .ulpOfOne)
        XCTAssertEqualWithAccuracy(triangle.c, 3.60555127546399, accuracy: .ulpOfOne * 4)
        XCTAssertEqualWithAccuracy(triangle.α, .radians(0.588002603547568), accuracy: .ulpOfOne * 2)
        XCTAssertEqualWithAccuracy(triangle.β, .radians(0.982793723247329), accuracy: .ulpOfOne)
        XCTAssertEqualWithAccuracy(triangle.γ, .pi / 2, accuracy: .ulpOfOne)
    }
}

fileprivate struct Point: Equatable, Triangulatable {
    let x: Double
    let y: Double
    
    static func ==(lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
