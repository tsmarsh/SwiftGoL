//
//  SwiftGolIntTest.swift
//
//
//  Created by Tom Marsh on 3/20/22.
//

import XCTest
@testable import SwiftGoL

class SwiftGolIntTest: XCTestCase {

    func testTheWorldStartsDead() {
        let world = Game(moduleCount: 1)
    
        XCTAssertFalse(SwiftGoLInt.isAlive(world: world, coords: Coord(0, 0)))
    }
    
    func testACellCanComeToLife() {
        var world = Game(moduleCount: 1)
        
        XCTAssertFalse(SwiftGoLInt.isAlive(world: world, coords: Coord(0, 0)))
        world = SwiftGoLInt.bringToLife(world: world, coords: Coord(0, 0))
        XCTAssertTrue(SwiftGoLInt.isAlive(world: world, coords:  Coord(0, 0)))
    }
    
    func testACellCanDie() {
        var world = Game(moduleCount: 1, state: [Coord(0, 0),Coord(0, 1)])
        
        world = SwiftGoLInt.kill(world: world, coords: Coord(0, 0))
        XCTAssertTrue(SwiftGoLInt.isAlive(world: world, coords:  Coord(0, 1)))
        XCTAssertFalse(SwiftGoLInt.isAlive(world: world, coords: Coord(0, 0)))
    }
    
//    func testACellHasNeighbours() {
//        let expected =
//            Set([Coord(0, 0), Coord(0, 1), Coord(0, 2),
//             Coord(1, 0),        Coord(1, 2),
//             Coord(2, 0), Coord(2, 1), Coord(2, 2)])
//
//        XCTAssertEqual(expected, Set(SwiftGoLInt.getNeighbours(coords: Coord(1, 1))))
//    }
    
//    func testCanCountLivingNeighbours(){
//        let world = Game(moduleCount: 1, state: [Coord(0, 1),Coord(1, 0), Coord(1, 1), Coord(1, 2),Coord(2, 1)])
//
//        XCTAssertEqual(4, SwiftGoLInt.countLivingNeighbours(world: world, coords: Coord(1, 1)))
//        XCTAssertEqual(3, SwiftGoLInt.countLivingNeighbours(world: world, coords: Coord(0, 0)))
//        XCTAssertEqual(1, SwiftGoLInt.countLivingNeighbours(world: world, coords: Coord(3, 1)))
//    }
    
    func testACellWithTwoLivingNeighboursComesToLife() {
        let world = Game(moduleCount: 1, state: [Coord(0, 0), Coord(1, 0), Coord(1, 2)])
        
        let new_world = SwiftGoLInt.next(world: world)
        XCTAssertTrue(SwiftGoLInt.isAlive(world: new_world, coords: Coord(1, 1)))
    }
    
    func testAWorldPerforms() {
        var world = Game(moduleCount: 1, state: [Coord(0, 0), Coord(1, 0), Coord(1, 2)])
        measure{ world = SwiftGoLInt.next(world: world)}
    }

}
