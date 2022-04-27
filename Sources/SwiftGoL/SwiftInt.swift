//
//  File.swift
//  
//
//  Created by Thomas Marsh on 4/23/22.
//

import Security

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
    
    static let mask: UInt64 = 7 + (5 << 8) + (7 << 16)
    
    struct Location : Equatable{
        var bucket: Int
        var bit: Int
    }
    
    static func toIndex(width: Int, coord: Coord) -> Int {
        return coord.x + coord.y * width
    }
    
    static func printModule(module: UInt64) {
        var i = 0

        var row = ""
        for _ in 0...7 {
            for _ in 0...7 {
                let mask: UInt64 = 1 << i
                let value = (module & mask) >= 1
                
                i += 1
                
                row.append(contentsOf: value ? "X" : ".")
            }
            row.append(contentsOf: "\n")
        }
        print(row)
    }
    
    static func toLocation(world: Game, coord: Coord) -> Location {
        let module_x: Int = coord.x / 6
        let module_y: Int = coord.y / 6
        
        let module_index = toIndex(width: world.width, coord: Coord(module_x, module_y))
        
        let cell_x: Int = (coord.x % 6) + 1
        let cell_y: Int = (coord.y % 6) + 1
        
        let bin_index = toIndex(width: 8, coord: Coord(cell_x, cell_y))
        
        return Location(bucket: module_index, bit: bin_index)
    }
    
    public static func isAlive(world: Game, coords: Coord) -> Bool {
        let loc = toLocation(world: world, coord: coords)
        
        let bucket = world.world[ loc.bucket ]
        let mask: UInt64 = 1 << loc.bit
        
        print("isAlive Bucket", bucket)
        printModule(module: bucket)
        
        return bucket & mask >= 1
    }
    
    

    public static func bringToLife(world: Game, coords: Coord) -> Game {
        let loc = toLocation(world: world, coord: coords)
        
        let bucket = world.world[ loc.bucket ]
        let mask: UInt64 = 1 << loc.bit
        
        print("Bringing to life: ", loc.bucket, loc.bit, bucket, mask)
        world.world[ loc.bucket ] = bucket | mask
        
        return world
    }
    
    public static func kill(world: Game, coords: Coord) -> Game {
        let loc = toLocation(world: world, coord: coords)
        
        let bucket = world.world[ loc.bucket ]
        let mask: UInt64 = 1 << loc.bit
        world.world[ loc.bucket ] = bucket & ~mask
        
        return world
    }
    
    public static func countLivingNeighbours(world: Game, coords: Coord) -> UInt8 {
        let loc = toLocation(world: world, coord: coords)
        let offset = (8 * coords.y) + coords.x
        
        let module = world.world[loc.bucket]
        let fence = (mask << offset)
        
        let neighbours = module & fence
        
        return UInt8(neighbours.nonzeroBitCount)
    }
    
    public static func next(world: Game) -> Game {
//        for module in world.world {
//            var i = 0
//            for _ in 0...7 {
//                for _ in 0...7 {
//                    let mask: UInt64 = 1 << i
//                    let value = (module & mask) >= 1
//                    
//                    i += 1
//                    
//                    row.append(contentsOf: value ? "X" : ".")
//                }
//                row.append(contentsOf: "\n")
//            }
//        }
        return world
    }
}


