import simd

public class World {
    public var height: Int
    public var width: Int
    
    public var world: [Bool]
    
    init(height: Int, width: Int){
        self.height = height
        self.width = width
        self.world = Array(repeating: false, count: height * width)
    }
    
    convenience init(height: Int, width: Int, state: [Coord]) {
        self.init(height: height, width: width)
        for coord in state {
            _ = SwiftGoLArray.bringToLife(world: self, coords: coord)
        }
    }
    
}

public struct SwiftGoLArray : Gol{
    
    public typealias T = World
    
    static func toIndex(world: World, coord: Coord) -> Int {
        return coord.x + coord.y * world.width
    }
    
    static func inBounds(world: World, coord: Coord) -> Bool {
        return coord.x >= 0 && coord.x < world.width && coord.y >= 0 && coord.y < world.height && coord.y >= 0
    }
    
    public static func isAlive(world: World, coords: Coord) -> Bool{
        return inBounds(world: world, coord: coords) ? world.world[toIndex(world: world, coord: coords)] : false
    }


    public static func bringToLife(world: World, coords: Coord) -> World{
        if inBounds(world: world, coord: coords){
            world.world[toIndex(world: world, coord: coords)] = true
        }
        return world
    }
    
    public static func kill(world: World, coords: Coord) -> World{
        if inBounds(world: world, coord: coords){
            world.world[toIndex(world: world, coord: coords)] = false
        }
        return world
    }
    
    static func getNeighbours(coords: Coord) -> [Coord] {
        let vec_coords = simd_long2(coords.x, coords.y)
        
        return NEIGHBOURS.map { n in
            let neighbour = n &+ vec_coords
            return Coord(neighbour.x, neighbour.y)
        }
    }
    
    public static func countLivingNeighbours(world: World, coords: Coord) -> Int {
        let neighbours = getNeighbours(coords: coords)
        return neighbours.filter {
            isAlive(world: world, coords: $0)
        }.count
    }
    
    static func toCoords(world: World, index: Int) -> Coord {
        return Coord(index % world.width, index / world.width)
    }
    
    public static func next(world: World) -> World{
        let new_world = World(height: world.height, width: world.width)
        
        let coords = world.world.enumerated().map{
            (index, _) in toCoords(world: world, index: index)
        }
        
        let neighbours = coords.map{
            (coord) in countLivingNeighbours(world: world, coords: coord)
        }
        
        
        for i in 0..<world.world.count {
            if isAlive(world: world, coords: coords[i]) {
                if ((neighbours[i] >= 2) && (neighbours[i] <= 3)) {
                    _ = bringToLife(world: new_world, coords: coords[i])
                }
            }
            if neighbours[i] == 3 {
                _ = bringToLife(world: new_world, coords: coords[i])
            }
        }
        
        return new_world
    }
}
