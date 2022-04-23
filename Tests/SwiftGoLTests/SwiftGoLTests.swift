import XCTest
@testable import SwiftGoL

final class SwiftGoLTests: XCTestCase {
    
    func testTheWorldStartsDead() {
        let world = WorldMap()
    
        XCTAssertFalse(SwiftGoL.isAlive(world: world, coords: Coord(0,0)))
    }
    
    func testACellCanComeToLife() {
        var world = WorldMap()
        
        XCTAssertFalse(SwiftGoL.isAlive(world: world, coords: Coord(0, 0)))
        world = SwiftGoL.bringToLife(world: world, coords: Coord(0,0))
        XCTAssertTrue(SwiftGoL.isAlive(world: world, coords:  Coord(0,0)))
    }
    
    func testACellCanDie() {
        var world = WorldMap(state: [Coord(0,0), Coord(0,1)])
    
        
        world = SwiftGoL.kill(world: world, coords: Coord(0,0))
        XCTAssertTrue(SwiftGoL.isAlive(world: world, coords:  Coord(0,1)))
        XCTAssertFalse(SwiftGoL.isAlive(world: world, coords: Coord(0, 0)))
    }
    
    func testACellHasNeighbours() {
        let expected =
            Set([Coord(0, 0), Coord(0, 1), Coord(0, 2),
             Coord(1, 0),        Coord(1, 2),
             Coord(2, 0), Coord(2, 1), Coord(2, 2)])
        
        XCTAssertEqual(expected, Set(SwiftGoL.getNeighbours(coords: Coord(1, 1))))
    }
    
    func testCanCountLivingNeighbours(){
        let world = WorldMap(state: [Coord(0, 1),Coord(1, 0), Coord(1, 1), Coord(1, 2),Coord(2, 1)] )
        
        XCTAssertEqual(4, SwiftGoL.countLivingNeighbours(world: world, coords: Coord(1, 1)))
        XCTAssertEqual(3, SwiftGoL.countLivingNeighbours(world: world, coords: Coord(0, 0)))
        XCTAssertEqual(1, SwiftGoL.countLivingNeighbours(world: world, coords: Coord(3, 1)))
    }
    
    func testACellWithTwoLivingNeighboursComesToLife() {
        let world = WorldMap(state: [Coord(0, 0), Coord(1, 0), Coord(1, 2)])
        
        let new_world = SwiftGoL.next(world: world)
        XCTAssertTrue(SwiftGoL.isAlive(world: new_world, coords: Coord(1, 1)))
    }
    
    func testAWorldPerforms() {
        var world = WorldMap(state: [Coord(0, 0), Coord(1, 0), Coord(1, 2)])
        measure{world = SwiftGoL.next(world: world)}
    }
}
