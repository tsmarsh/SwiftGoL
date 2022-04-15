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
    
    convenience init(height: Int, width: Int, state: [[Int]]) {
        self.init(height: height, width: width)
        for coord in state {
            SwiftGoLArray.bringToLife(world: self, coords: coord)
        }
    }
    
}

public struct SwiftGoLArray {
    
    static func toIndex(world: World, coord: [Int]) -> Int {
        return coord[0] + coord[1] * world.width
    }
    
    static func inBounds(world: World, coord: [Int]) -> Bool {
        return coord[0] < world.width && coord[0] >= 0 && coord[1] < world.height && coord[1] >= 0
    }
    
    static func isAlive(world: World, coords: [Int]) -> Bool{
        return inBounds(world: world, coord: coords) ? world.world[toIndex(world: world, coord: coords)] : false
    }

    @discardableResult
    static func bringToLife(world: World, coords: [Int]) -> World{
        if inBounds(world: world, coord: coords){
            world.world[toIndex(world: world, coord: coords)] = true
        }
        return world
    }
    
    @discardableResult
    static func kill(world: World, coords: [Int]) -> World{
        if inBounds(world: world, coord: coords){
            world.world[toIndex(world: world, coord: coords)] = false
        }
        return world
    }
    
    static func getNeighbours(coords: [Int]) -> Set<[Int]> {
        let vec_coords = simd_long2(coords[0], coords[1])
        
        return Set(NEIGHBOURS.map {
            let neighbour = $0 &+ vec_coords
            return [neighbour[0], neighbour[1]]
        })
    }
    
    static func countLivingNeighbours(world: World, coords: [Int]) -> Int {
        let neighbours = getNeighbours(coords: coords)
        return neighbours.filter {
            isAlive(world: world, coords: $0)
        }.count
    }
    
    static func toCoords(world: World, index: Int) -> [Int] {
        return [index % world.width, index / world.width]
    }
    
    static func next(world: World) -> World{
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
                    bringToLife(world: new_world, coords: coords[i])
                }
            }
            if neighbours[i] == 3 {
                bringToLife(world: new_world, coords: coords[i])
            }
        }
        
        return new_world
    }
}
