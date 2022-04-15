//
//  SwiftGolArrayTest.swift
//  
//
//  Created by Tom Marsh on 3/20/22.
//

import XCTest
@testable import SwiftGoL

class SwiftGolArrayTest: XCTestCase {

    func testTheWorldStartsDead() {
        let world = World(height: 10, width: 10)
    
        XCTAssertFalse(SwiftGoLArray.isAlive(world: world, coords: [0,0]))
    }
    
    func testACellCanComeToLife() {
        var world = World(height: 10, width: 10)
        
        XCTAssertFalse(SwiftGoLArray.isAlive(world: world, coords: [0, 0]))
        world = SwiftGoLArray.bringToLife(world: world, coords: [0,0])
        XCTAssertTrue(SwiftGoLArray.isAlive(world: world, coords:  [0,0]))
    }
    
    func testACellCanDie() {
        var world =  World(height: 10, width: 10, state: [[0,0],[0,1]])
        
        world = SwiftGoLArray.kill(world: world, coords: [0,0])
        XCTAssertTrue(SwiftGoLArray.isAlive(world: world, coords:  [0,1]))
        XCTAssertFalse(SwiftGoLArray.isAlive(world: world, coords: [0, 0]))
    }
    
    func testACellHasNeighbours() {
        let expected: Set<[Int]> =
            [[0,0], [0,1], [0,2],
             [1,0],        [1,2],
             [2,0], [2,1], [2,2]]
        
        XCTAssertEqual(expected, SwiftGoLArray.getNeighbours(coords: [1,1]))
    }
    
    func testCanCountLivingNeighbours(){
        let world = World(height: 10, width: 10, state: [[0,1],[1,0], [1,1], [1,2],[2,1]])
        
        XCTAssertEqual(4, SwiftGoLArray.countLivingNeighbours(world: world, coords: [1,1]))
        XCTAssertEqual(3, SwiftGoLArray.countLivingNeighbours(world: world, coords: [0,0]))
        XCTAssertEqual(1, SwiftGoLArray.countLivingNeighbours(world: world, coords: [3,1]))
    }
    
    func testACellWithTwoLivingNeighboursComesToLife() {
        let world = World(height: 10, width: 10, state: [[0,0], [1,0], [1,2]])
        
        let new_world = SwiftGoLArray.next(world: world)
        XCTAssertTrue(SwiftGoLArray.isAlive(world: new_world, coords: [1,1]))
    }
    
    func testAWorldPerforms() {
        var world = World(height: 5, width: 5, state: [[0,0], [1,0], [1,2]])
        measure{ world = SwiftGoLArray.next(world: world)}
    }

}
