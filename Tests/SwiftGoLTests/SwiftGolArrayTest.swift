//
//  SwiftGolArrayTest.swift
//  
//
//  Created by Tom Marsh on 3/20/22.
//

import XCTest
import SwiftGoLArray

class SwiftGolArrayTest: XCTestCase {

    func testTheWorldStartsDead() {
        let world: [Bool] = World(height: 10, width: 10)
    
        XCTAssertFalse(SwiftGoLArray.isAlive(world: world, coords: [0,0]))
    }
    
    func testACellCanComeToLife() {
        let world: [Bool] = World(height: 10, width: 10)
        
        XCTAssertFalse(SwiftGoL.isAlive(world: world, coords: [0, 0]))
        world = SwiftGoL.bringToLife(world: &world, coords: [0,0])
        XCTAssertTrue(SwiftGoL.isAlive(world: world, coords:  [0,0]))
    }
    
    func testACellCanDie() {
        var world: Set<[Int]> = [[0,0],[0,1]]
        
        world = SwiftGoL.kill(world: &world, coords: [0,0])
        XCTAssertTrue(SwiftGoL.isAlive(world: world, coords:  [0,1]))
        XCTAssertFalse(SwiftGoL.isAlive(world: world, coords: [0, 0]))
    }
    
    func testACellHasNeighbours() {
        let expected: Set<[Int]> =
            [[0,0], [0,1], [0,2],
             [1,0],        [1,2],
             [2,0], [2,1], [2,2]]
        
        XCTAssertEqual(expected, SwiftGoL.getNeighbours(coords: [1,1]))
    }
    
    func testCanCountLivingNeighbours(){
        let world: Set<[Int]> = [[0,1],[1,0], [1,1], [1,2],[2,1]]
        
        XCTAssertEqual(4, SwiftGoL.countLivingNeighbours(world: world, coords: [1,1]))
        XCTAssertEqual(3, SwiftGoL.countLivingNeighbours(world: world, coords: [0,0]))
        XCTAssertEqual(1, SwiftGoL.countLivingNeighbours(world: world, coords: [3,1]))
    }
    
    func testACellWithTwoLivingNeighboursComesToLife() {
        let world: Set<[Int]> = [[0,0], [1,0], [1,2]]
        let new_world = SwiftGoL.next(world: world)
        XCTAssertTrue(SwiftGoL.isAlive(world: new_world, coords: [1,1]))
    }
    
    func testAWorldPerforms() {
        let world: Set<[Int]> = [[0,0], [1,0], [1,2]]
        measure{SwiftGoL.next(world: world)}
    }

}
