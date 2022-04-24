//
//  File.swift
//  
//
//  Created by Thomas Marsh on 4/23/22.
//

public class Game {
    public var width: Int = 0
    
    public var world: [UInt64]
    
    init(moduleCount: Int){
        self.width = moduleCount
        self.world = Array(repeating: 0, count: Int(truncatingIfNeeded: width * width))
    }
    
    convenience init(moduleCount: Int, state: [Coord]) {
        self.init(moduleCount: moduleCount)
        for coord in state {
            _ = SwiftGoLInt.bringToLife(world: self, coords: coord)
        }
    }
    
}

public struct SwiftGoLInt : Gol{
    public typealias T = Game
    
    private struct Location {
        var bucket: Int
        var bit: Int
    }
    
    private static func toLocation(world: Game, coord: Coord) -> Location {
        let index = coord.x + coord.y * world.width
        return Location(bucket: index / 64, bit: index % 64)
    }
    
    public static func isAlive(world: Game, coords: Coord) -> Bool {
        let loc = toLocation(world: world, coord: coords)
        
        let bucket = world.world[ loc.bucket ]
        let mask: UInt64 = 1 << (loc.bit - 1)
        return bucket & mask == 1
    }
    
    

    public static func bringToLife(world: Game, coords: Coord) -> Game {
        let loc = toLocation(world: world, coord: coords)
        
        let bucket = world.world[ loc.bucket ]
        let mask: UInt64 = 1 << (loc.bit - 1)
        world.world[ loc.bucket ] = bucket | mask
        
        return world
    }
    
    public static func kill(world: Game, coords: Coord) -> Game {
        return world
    }
    
    public static func next(world: Game) -> Game {
        return world
    }
}


