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
    
    func testLocationCalculator() {
        let world = Game(moduleCount: 2)
        
        let test1 = SwiftGoLInt.toLocation(world: world, coord: Coord(3,4))
        let test2 = SwiftGoLInt.toLocation(world: world, coord: Coord(8,0))
        let test3 = SwiftGoLInt.toLocation(world: world, coord: Coord(7,11))
        
        XCTAssertTrue(SwiftGoLInt.Location(bucket: 0, bit: 44) == test1)
        XCTAssertTrue(SwiftGoLInt.Location(bucket: 1, bit: 11) == test2)
        XCTAssertTrue(SwiftGoLInt.Location(bucket: 3, bit: 50) == test3)
    }
    
    func testACellCanComeToLife() {
        var world = Game(moduleCount: 1)
        
        XCTAssertFalse(SwiftGoLInt.isAlive(world: world, coords: Coord(0, 0)))
        world = SwiftGoLInt.bringToLife(world: world, coords: Coord(0, 0))
        world = SwiftGoLInt.bringToLife(world: world, coords: Coord(0, 1))
        world = SwiftGoLInt.bringToLife(world: world, coords: Coord(1, 0))
        
        XCTAssertTrue(SwiftGoLInt.isAlive(world: world, coords:  Coord(0, 0)))
        XCTAssertTrue(SwiftGoLInt.isAlive(world: world, coords:  Coord(0, 1)))
        XCTAssertTrue(SwiftGoLInt.isAlive(world: world, coords:  Coord(1, 0)))
        XCTAssertFalse(SwiftGoLInt.isAlive(world: world, coords:  Coord(1, 1)))
    }
    
    func testACellCanDie() {
        var world = Game(moduleCount: 1, state: [Coord(0, 0),Coord(0, 1)])
        
        world = SwiftGoLInt.kill(world: world, coords: Coord(0, 0))
        XCTAssertTrue(SwiftGoLInt.isAlive(world: world, coords:  Coord(0, 1)))
        XCTAssertFalse(SwiftGoLInt.isAlive(world: world, coords: Coord(0, 0)))
    }
    
    
    func testCanCountLivingNeighbours(){
        let world = Game(moduleCount: 1, state: [Coord(0, 1),Coord(1, 0), Coord(1, 1), Coord(1, 2),Coord(2, 1)])
        
        XCTAssertEqual(4, SwiftGoLInt.countLivingNeighbours(world: world, coords: Coord(1, 1)))
        XCTAssertEqual(3, SwiftGoLInt.countLivingNeighbours(world: world, coords: Coord(0, 0)))
        XCTAssertEqual(1, SwiftGoLInt.countLivingNeighbours(world: world, coords: Coord(3, 1)))
    }
    
    func testACellWithTwoLivingNeighboursComesToLife() {
        let world = Game(moduleCount: 1, state: [Coord(0, 0), Coord(1, 0), Coord(1, 2)])
        SwiftGoLInt.printModule(module: world.world[0])
        
        let new_world = SwiftGoLInt.next(world: world)
        XCTAssertTrue(SwiftGoLInt.isAlive(world: new_world, coords: Coord(1, 1)))
    }

    func testTranslatesNeighbour0() {
        let expected: UInt64 = 1
        let full = UInt64.max;
        let neighbours = [full,0,0,0,0,0,0,0]

        XCTAssertEqual(expected,SwiftGoLInt.translateNeighbours(module: 0, neighbours: neighbours));
    }

    func testTranslatesNeighbour1() {
        let expected: UInt64 = 0x7E
        let full = UInt64.max;
        let neighbours = [0, full,0,0,0,0,0,0]

        XCTAssertEqual(expected,SwiftGoLInt.translateNeighbours(module: 0, neighbours: neighbours));
    }

    func testTranslatesNeighbour2() {
        let expected: UInt64 = 0x80
        let full = UInt64.max
        let neighbours = [0, 0,full,0,0,0,0,0]

        XCTAssertEqual(expected,SwiftGoLInt.translateNeighbours(module: 0, neighbours: neighbours));
    }

    func testTranslatesNeighbour3() {
        let expected: UInt64 = 0x1010101010100
        let full = UInt64.max
        let neighbours = [0,0,0,full,0,0,0,0]

        XCTAssertEqual(expected,SwiftGoLInt.translateNeighbours(module: 0, neighbours: neighbours));
    }

    func testTranslatesNeighbour4() {
        let expected: UInt64 = 0x80808080808000
        let full = UInt64.max
        let neighbours = [0,0,0,0,full,0,0,0]

        XCTAssertEqual(expected,SwiftGoLInt.translateNeighbours(module: 0, neighbours: neighbours));
    }


    func testTranslatesNeighbour5() {
        let expected: UInt64 = 0x100000000000000
        let full = UInt64.max
        let neighbours = [0,0,0,0,0,full,0,0]

        XCTAssertEqual(expected,SwiftGoLInt.translateNeighbours(module: 0, neighbours: neighbours));
    }

    func testTranslatesNeighbour6() {
        let expected: UInt64 = 0x7E00000000000000
        let full = UInt64.max
        let neighbours = [0,0,0,0,0,0,full,0]

        XCTAssertEqual(expected,SwiftGoLInt.translateNeighbours(module: 0, neighbours: neighbours));
    }

    func testTranslatesNeighbour7() {
        let expected: UInt64 = 0x8000000000000000
        let full = UInt64.max
        let neighbours = [0,0,0,0,0,0,0,full]

        XCTAssertEqual(expected,SwiftGoLInt.translateNeighbours(module: 0, neighbours: neighbours));
    }

    func testACellBetweenTwoModulesComesToLife() {
        let world = Game(moduleCount: 2, state: [Coord(5, 1), Coord(7, 1), Coord(4, 3), Coord(6,3)])

        let new_world = SwiftGoLInt.next(world: world)
        XCTAssertTrue(SwiftGoLInt.isAlive(world: new_world, coords: Coord(5, 2)))
        XCTAssertTrue(SwiftGoLInt.isAlive(world: new_world, coords: Coord(6, 2)))
    }

    func testAWorldPerforms() {
        var world = Game(moduleCount: 1, state: [Coord(0, 0), Coord(1, 0), Coord(1, 2)])
        measure{ world = SwiftGoLInt.next(world: world)}
    }

}
