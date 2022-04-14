
public class World {
    public var height: Int
    public var width: Int
    
    public var world: [Bool]
    
    init(height: Int, width: Int){
        self.world = Array(repeating: false, count: height * width)
    }
}

public struct SwiftGoLArray {
    static func isAlive(world: World, coords: [Int]) -> Bool{
        return false
    }

    static func bringToLife(world: World, coords: [Int]) -> World{
        return world
    }
    
    static func kill(world: World, coords: [Int]) -> World{
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
            isAlive(world, $0)
        }.count
    }
    
    static func next(world: Set<[Int]>) -> Set<[Int]>{
        let xs = world.map {$0[0]}
        let max_x = xs.max() ?? 0
        let min_x = xs.min() ?? 0
        
        let ys = world.map {$0[1]}
        let max_y = ys.max() ?? 0
        let min_y = ys.min() ?? 0
        
        var new_world = Set<[Int]>()
        
        for i in (min_x - 1)...(max_x + 1) {
            for j in (min_y - 1)...(max_y + 1){
                let coord = [i,j]
                let neighbours = countLivingNeighbours(world: world, coords: coord)
                
                if isAlive(world: world, coords: coord) {
                    if ((neighbours >= 2) && (neighbours <= 3)) {
                        new_world.insert(coord)
                    }
                }
                if neighbours == 3 {
                    new_world.insert(coord)
                }
            }
        }
        
        return new_world
    }
}
