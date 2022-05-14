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

        let test1 = SwiftGoLInt.toLocation(world: world, coord: Coord(3, 4))
        let test2 = SwiftGoLInt.toLocation(world: world, coord: Coord(8, 0))
        let test3 = SwiftGoLInt.toLocation(world: world, coord: Coord(7, 11))

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

        XCTAssertTrue(SwiftGoLInt.isAlive(world: world, coords: Coord(0, 0)))
        XCTAssertTrue(SwiftGoLInt.isAlive(world: world, coords: Coord(0, 1)))
        XCTAssertTrue(SwiftGoLInt.isAlive(world: world, coords: Coord(1, 0)))
        XCTAssertFalse(SwiftGoLInt.isAlive(world: world, coords: Coord(1, 1)))
    }

    func testACellCanDie() {
        var world = Game(moduleCount: 1, state: [Coord(0, 0), Coord(0, 1)])

        world = SwiftGoLInt.kill(world: world, coords: Coord(0, 0))
        XCTAssertTrue(SwiftGoLInt.isAlive(world: world, coords: Coord(0, 1)))
        XCTAssertFalse(SwiftGoLInt.isAlive(world: world, coords: Coord(0, 0)))
    }


    func testCanCountLivingNeighbours() {
        let world = Game(moduleCount: 1, state: [Coord(0, 1), Coord(1, 0), Coord(1, 1), Coord(1, 2), Coord(2, 1)])

        XCTAssertEqual(4, SwiftGoLInt.countLivingNeighbours(world: world, coords: Coord(1, 1)))
        XCTAssertEqual(3, SwiftGoLInt.countLivingNeighbours(world: world, coords: Coord(0, 0)))
        XCTAssertEqual(1, SwiftGoLInt.countLivingNeighbours(world: world, coords: Coord(3, 1)))
    }

    func testACellWithTwoLivingNeighboursComesToLife() {
        let world = Game(moduleCount: 1, state: [Coord(0, 0), Coord(1, 0), Coord(1, 2)])

        let new_world = SwiftGoLInt.next(world: world)
        XCTAssertTrue(SwiftGoLInt.isAlive(world: new_world, coords: Coord(1, 1)))
    }

    func testTranslatesNeighbourTopLeft() {
        let expected: UInt64 = 1
        let full = UInt64.max;
        let neighbours = [full, 0, 0, 0, 0, 0, 0, 0]

        XCTAssertEqual(expected, SwiftGoLInt.translateNeighbours(module: 0, neighbours: neighbours));
    }

    func testTranslatesNeighbourTop() {
        let module: UInt64 = SwiftGoLInt.cleanModule(module: UInt64.random(in: 0x400...0x7E7E7E7E7E7E00))
        let expected: UInt64 = 0x7E | module
        let full: UInt64 = UInt64.max
        let neighbours = [0, full, 0, 0, 0, 0, 0, 0]

        let actual = SwiftGoLInt.translateNeighbours(module: module, neighbours: neighbours)

        XCTAssertEqual(expected, actual);
    }

    func testTranslatesNeighbourTopRight() {
        let module: UInt64 = 0x600000500000
        let expected: UInt64 = 0x80 | module
        let full: UInt64 = 0x2000000000000
        let neighbours = [0, 0, full, 0, 0, 0, 0, 0]

        XCTAssertEqual(expected, SwiftGoLInt.translateNeighbours(module: module, neighbours: neighbours));
    }

    func testTranslatesNeighbourLeft() {
        let expected: UInt64 = 0x1010101010100
        let full = UInt64.max
        let neighbours = [0, 0, 0, full, 0, 0, 0, 0]

        XCTAssertEqual(expected, SwiftGoLInt.translateNeighbours(module: 0, neighbours: neighbours));
    }

    func testTranslatesNeighbourRight() {
        let expected: UInt64 = 0x80808080808000
        let full = UInt64.max
        let neighbours = [0, 0, 0, 0, full, 0, 0, 0]

        XCTAssertEqual(expected, SwiftGoLInt.translateNeighbours(module: 0, neighbours: neighbours));
    }


    func testTranslatesNeighbourBottomLeft() {
        let expected: UInt64 = 0x100000000000000
        let full = UInt64.max
        let neighbours = [0, 0, 0, 0, 0, full, 0, 0]

        XCTAssertEqual(expected, SwiftGoLInt.translateNeighbours(module: 0, neighbours: neighbours));
    }

    func testTranslatesNeighbourBottom() {
        let expected: UInt64 = 0x7E00000000000000
        let full = UInt64.max
        let neighbours = [0, 0, 0, 0, 0, 0, full, 0]

        XCTAssertEqual(expected, SwiftGoLInt.translateNeighbours(module: 0, neighbours: neighbours));
    }

    func testTranslatesNeighbourBottomRight() {
        let expected: UInt64 = 0x8000000000000000
        let full = UInt64.max
        let neighbours = [0, 0, 0, 0, 0, 0, 0, full]

        XCTAssertEqual(expected, SwiftGoLInt.translateNeighbours(module: 0, neighbours: neighbours));
    }

    func testTranslatesNeighbours() {
        let module: UInt64 = UInt64.random(in: 0x400...0x7E7E7E7E7E7E00)

        let neighbours: [UInt64] = [0x40000000000000,
                                    0x18000000000000,
                                    0x2000000000000,
                                    0x4000400000,
                                    0x20002000000,
                                    0x4000,
                                    0xC00,
                                    0x200]

        let expected_edge: UInt64 = 0x8D00800180010099;

        let translated = SwiftGoLInt.translateNeighbours(module: module, neighbours: neighbours)

        let expected = expected_edge | SwiftGoLInt.cleanModule(module: module)

        XCTAssertEqual(expected, translated);
    }

    func testACellBetweenTwoModulesComesToLife() {
        let world = Game(moduleCount: 2, state: [Coord(5, 1),
                                                 Coord(7, 1),
                                                 Coord(4, 3),
                                                 Coord(6, 3)
        ])

        let new_world = SwiftGoLInt.next(world: world)


        XCTAssertTrue(SwiftGoLInt.isAlive(world: new_world, coords: Coord(5, 2)))
        XCTAssertTrue(SwiftGoLInt.isAlive(world: new_world, coords: Coord(6, 2)))
    }

    func testAWorldPerforms() {
        var world = Game(moduleCount: 1, state: [Coord(0, 0), Coord(1, 0), Coord(1, 2)])
        measure {
            world = SwiftGoLInt.next(world: world)
        }
    }

}
