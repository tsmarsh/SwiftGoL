//
//  File.swift
//  
//
//  Created by Thomas Marsh on 4/23/22.
//
import simd

public class Game {
    public var width: Int = 0

    public var world: [UInt64]

    public var neighbours: [[Int]] = []

    init(moduleCount: Int) {
        self.width = moduleCount
        self.world = Array(repeating: 0, count: Int(truncatingIfNeeded: width * width))
        self.neighbours = SwiftGoLInt.generateNeighbourSets(world: self)
    }

    convenience init(moduleCount: Int, state: [Coord]) {
        self.init(moduleCount: moduleCount)
        for coord in state {
            _ = SwiftGoLInt.bringToLife(world: self, coords: coord)
        }
    }

}

public struct SwiftGoLInt: Gol {
    public typealias T = Game

    static let mask: UInt64 = 7 + (5 << 8) + (7 << 16)

    struct Location: Equatable {
        var bucket: Int
        var bit: Int
    }

    static func toIndex(width: Int, coord: Coord) -> Int {
        return coord.x + coord.y * width
    }

    public static func moduleToString(module: UInt64) -> String{
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

        return row
    }

    public static func worldToString(world: Game) -> String{
        world.world.map(moduleToString(module:)).reduce("", {
            (s, cell) in
            s + "\n--------\n" + cell
        })
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

        let bucket = world.world[loc.bucket]
        let mask: UInt64 = 1 << loc.bit

        return bucket & mask >= 1
    }


    public static func bringToLife(world: Game, coords: Coord) -> Game {
        let loc = toLocation(world: world, coord: coords)

        let bucket = world.world[loc.bucket]
        let mask: UInt64 = 1 << loc.bit

        world.world[loc.bucket] = bucket | mask

        return world
    }

    public static func kill(world: Game, coords: Coord) -> Game {
        let loc = toLocation(world: world, coord: coords)

        let bucket = world.world[loc.bucket]
        let mask: UInt64 = 1 << loc.bit
        world.world[loc.bucket] = bucket & ~mask

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


    public static func translateNeighbours(module: UInt64, neighbours: [UInt64]) -> UInt64 {
        let cleaned = cleanModule(module: module)
        let translations:[Int8] = [-54,-48,-42,-6,6,42,48,54]

        let neigh_mask = zip(NEIGHBOUR_MASKS, neighbours)

        let masked_neighbours = neigh_mask.map { (mask: UInt64, neighbour: UInt64) in
            mask & neighbour
        }

        let trans_neighbours = zip(translations, masked_neighbours)

        let translated: [UInt64] = trans_neighbours.map { (shift: Int8, original: UInt64) in
            original << shift
        }

        return translated.reduce(cleaned, {(result: UInt64, translated: UInt64) in
            result | translated
        })
    }

    public static func processModule(module: UInt64) -> UInt64 {
        var newMod: UInt64 = 0
        var i: Int = 0

        for y in 1...6 {
            for x in 1...6 {
                let offset = toIndex(width: 8, coord: Coord(x, y))

                let fence = (mask << (offset - 9))

                let alive = module & (1 << offset) >= 1
                let neighbours = (module & fence).nonzeroBitCount

                if alive && neighbours >= 2 && neighbours <= 3 {
                    newMod |= 1 << offset
                }

                if neighbours == 3 {
                    newMod |= 1 << offset
                }
                i += 1
            }
        }
        return newMod
    }


    public static func indexToCoord(world: Game, index: Int) -> Coord {
        Coord(index % world.width, index / world.width)
    }

    static func toIndex(world: Game, coord: Coord) -> Int {
        return coord.x + coord.y * world.width
    }

    static func inBounds(world: Game, coord: Coord) -> Bool {
        return coord.x >= 0 && coord.x < world.width && coord.y >= 0 && coord.y < world.width && coord.y >= 0
    }

    public static func cleanModule(module: UInt64) -> UInt64 {
        module & 0x7E7E7E7E7E7E00
    }

    public static func generateNeighbourSets(world: Game) -> [[Int]] {
        let neighbours: [[Coord]] = world.world.enumerated().map { (i, _) in
            SwiftGoLArray.getNeighbours(coords: indexToCoord(world: world, index: i))
        }

        return neighbours.map { (n: [Coord]) in
            n.map { (c: Coord) in
                inBounds(world: world, coord: c) ?
                        toIndex(world: world, coord: c)
                        :
                        -1
            }
        }
    }

    public static func next(world: Game) -> Game {

        let modules: [[UInt64]] = world.neighbours.map{ ns in
            ns.map{i in i >= 0 ? world.world[i] : 0}
        }

        let edged_world = zip(world.world, modules).map{ module, neighbours in
            translateNeighbours(module: module , neighbours: neighbours)
        }

        let ew = Game(moduleCount: 2)
        ew.world = edged_world

        world.world = edged_world.map(processModule(module:))

        return world
    }
}


