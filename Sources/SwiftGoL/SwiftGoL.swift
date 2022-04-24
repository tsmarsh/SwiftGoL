import simd


let NEIGHBOURS: Set<simd_long2> = [simd_long2(x: -1, y: -1),
                                     simd_long2(x: -1, y: 0),
                                     simd_long2(x: -1, y: 1),
                                     simd_long2(x: 0, y: -1),
                                     simd_long2(x: 0, y: 1),
                                     simd_long2(x: 1, y: -1),
                                     simd_long2(x: 1, y: 0),
                                     simd_long2(x: 1, y: 1)]

public protocol Gol {
    associatedtype T
    
    static func isAlive(world: T, coords: Coord) -> Bool

    static func bringToLife(world: T, coords: Coord) -> T
    
    static func kill(world: T, coords: Coord) -> T
    
    static func next(world: T) -> T
}

public struct Coord : Hashable{
    var x: Int
    var y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

public class WorldMap {

    var world = Set<Coord>()
    var min_x: Int = 0
    var max_x: Int = 0
    var min_y: Int = 0
    var max_y: Int = 0
    
    convenience init(state: [Coord]) {
        self.init()
        for coord in state {
            _ = SwiftGoL.bringToLife(world: self, coords: coord)
        }
    }
}

public struct SwiftGoL: Gol {
    
    public typealias T = WorldMap
    
    public static func isAlive(world: WorldMap, coords: Coord) -> Bool{
        return world.world.contains(coords)
    }

    static func checkMinMax(world: WorldMap, coords: Coord) {
        world.min_x = (world.min_x < coords.x) ? world.min_x : coords.x
        world.max_x = (world.max_x > coords.x) ? world.max_x : coords.x
        
        world.min_y = (world.min_y < coords.y) ? world.min_y : coords.y
        world.max_y = (world.max_y > coords.y) ? world.max_y : coords.y
    }
    
    public static func bringToLife(world: WorldMap, coords: Coord) -> WorldMap{

        checkMinMax(world: world, coords: coords)
        world.world.insert(coords)
        return world
    }
    
    public static func kill(world: WorldMap, coords: Coord) -> WorldMap {
        world.world.remove(coords)
        
        let xs = world.world.map {$0.x}
        world.max_x = xs.max() ?? 0
        world.min_x = xs.min() ?? 0
        
        let ys = world.world.map {$0.y}
        world.max_y = ys.max() ?? 0
        world.min_y = ys.min() ?? 0
        
        return world
    }
    
    static func getNeighbours(coords: Coord) -> [Coord] {
        let vec_coords = simd_long2(simd_long1(coords.x), simd_long1(coords.y))
        
        return NEIGHBOURS.map {
            let neighbour = $0 &+ vec_coords
            return Coord(neighbour[0], neighbour[1])
        }
    }
    
    static func countLivingNeighbours(world: WorldMap, coords: Coord) -> Int {
        let neighbours = getNeighbours(coords: coords)
        return neighbours.filter {
            world.world.contains($0)
        }.count
    }
    
    public static func next(world: WorldMap) -> WorldMap{
        let new_world = WorldMap()
        
        for i in (world.min_x - 1)...(world.max_x + 1) {
            for j in (world.min_y - 1)...(world.max_y + 1){
                let coord = Coord(i, j)
                let neighbours = countLivingNeighbours(world: world, coords: coord)
                
                if isAlive(world: world, coords: coord) {
                    if ((neighbours >= 2) && (neighbours <= 3)) {
                        _ = bringToLife(world: new_world, coords: coord)
                    }
                }
                if neighbours == 3 {
                    _ = bringToLife(world: new_world, coords: coord)
                }
            }
        }
        
        return new_world
    }
}


