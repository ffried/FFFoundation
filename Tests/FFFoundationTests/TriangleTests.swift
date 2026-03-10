import Testing
@testable import FFFoundation

@Suite
struct TriangleTests {
    @Test
    func triangleBeingEquatable() {
        let triangle1 = Triangle(orthogonallyOnCWithA: TestPoint(x: 1, y: 1),
                                 b: TestPoint(x: 3, y: 4))
        let triangle2 = Triangle(orthogonallyOnCWithA: TestPoint(x: 2, y: 2),
                                 b: TestPoint(x: 4, y: 5))
        #expect(triangle1 == triangle2)
    }

    @Test
    func triangleBeingHashable() {
        var hasher1 = Hasher()
        let triangle1 = Triangle(orthogonallyOnCWithA: TestPoint(x: 1, y: 1),
                                 b: TestPoint(x: 3, y: 4))
        triangle1.hash(into: &hasher1)
        var hasher2 = Hasher()
        let triangle2 = Triangle(orthogonallyOnCWithA: TestPoint(x: 2, y: 2),
                                 b: TestPoint(x: 4, y: 5))
        triangle2.hash(into: &hasher2)
        #expect(hasher1.finalize() == hasher2.finalize())
    }

    @Test
    func orthogonalTriangleCalculation() {
        let pointA = TestPoint(x: 1, y: 1)
        let pointB = TestPoint(x: 3, y: 4)

        let triangle = Triangle(orthogonallyOnCWithA: pointA, b: pointB)
        
        #expect(triangle.pointA == pointA)
        #expect(triangle.pointB == pointB)
        #expect(triangle.pointC == TestPoint(x: 1, y: 4))
        #expect(abs(triangle.a.distance(to: 2)) <= .ulpOfOne)
        #expect(abs(triangle.b.distance(to: 3)) <= .ulpOfOne)
        #expect(abs(triangle.c.distance(to: 3.60555127546399)) <= .ulpOfOne * 4)
        #expect(abs(triangle.α.distance(to: .radians(0.588002603547568))) <= .ulpOfOne * 2)
        #expect(abs(triangle.β.distance(to: .radians(0.982793723247329))) <= .ulpOfOne)
        #expect(abs(triangle.γ.distance(to: .pi / 2)) <= .ulpOfOne)
    }

    @Test
    func orthogonalTriangleWithSinglePoint() {
        let point = TestPoint(x: 0, y: 0)
        let triangle = Triangle(orthogonallyOnCWithA: point, b: point)
        #expect(triangle.points.a == point)
        #expect(triangle.points.b == point)
        #expect(triangle.points.c == point)
        #expect(triangle.sides.a == 0)
        #expect(triangle.sides.b == 0)
        #expect(triangle.sides.c == 0)
        #expect(triangle.angles.α.isNaN)
        #expect(triangle.angles.β.isNaN)
        #expect(abs(triangle.angles.γ.distance(to: .pi / 2)) <= .ulpOfOne)
    }

    @Test
    func triangleWithAllPointsGiven() {
        let pointA = TestPoint(x: 1, y: 1)
        let pointB = TestPoint(x: 7, y: 3)
        let pointC = TestPoint(x: 9, y: 7)
        let a: TestPoint.Value = (4 * 4 + 2 * 2).squareRoot()
        let b: TestPoint.Value = (6 * 6 + 8 * 8).squareRoot()
        let c: TestPoint.Value = (2 * 2 + 6 * 6).squareRoot()
        let cosα = (b * b + c * c - a * a) / (2 * b * c)
        let cosβ = (a * a + c * c - b * b) / (2 * a * c)
        let cosγ = (a * a + b * b - c * c) / (2 * a * b)
        
        let sut = Triangle(a: pointA, b: pointB, c: pointC)
        
        #expect(sut.pointA == pointA)
        #expect(sut.pointB == pointB)
        #expect(sut.pointC == pointC)
        #expect(sut.a == a)
        #expect(sut.b == b)
        #expect(sut.c == c)
        #expect(sut.α == .radians(cosα.acos()))
        #expect(sut.β == .radians(cosβ.acos()))
        #expect(sut.γ == .radians(cosγ.acos()))
    }

    @Test
    func triangleWithAllPointsBeingTheSame() {
        let point = TestPoint(x: 0, y: 0)
        let triangle = Triangle(a: point, b: point, c: point)
        #expect(triangle.points.a == point)
        #expect(triangle.points.b == point)
        #expect(triangle.points.c == point)
        #expect(triangle.sides.a == 0)
        #expect(triangle.sides.b == 0)
        #expect(triangle.sides.c == 0)
        #expect(triangle.angles.α.isNaN)
        #expect(triangle.angles.β.isNaN)
        #expect(triangle.angles.γ.isNaN)
    }
}

fileprivate struct TestPoint: Equatable, TriangulatablePoint {
    let x: Double
    let y: Double
}
