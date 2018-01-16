import Foundation
import SwiftyBeaver

class ConcurentWikipediaAPI {
    
    private var maxConcurentOperationCount: Int
    
    init(maxConcurentOperationCount: Int = OperationQueue.defaultMaxConcurrentOperationCount) {
        self.maxConcurentOperationCount = maxConcurentOperationCount
    }
    
    public func loadThumbnailImages(for sightArray: [Sight], callback: (() -> Void)?) {
        OperationQueue().addOperation {
            let loadingQueue = OperationQueue()
            loadingQueue.maxConcurrentOperationCount = self.maxConcurentOperationCount
            
            for sight in sightArray {
                let loader = ImageLoader(sight: sight)
                loadingQueue.addOperation(loader)
            }

            SwiftyBeaver.info("Start loading thumbnail images")
            loadingQueue.waitUntilAllOperationsAreFinished()
            SwiftyBeaver.info("Complete loading thumbnail images")
            callback?()
        }
    }
}

fileprivate class ImageLoader: AsyncOperation {
    
    var sight: Sight
    
    init(sight: Sight) {
        self.sight = sight
        super.init()
    }
    
    override func main() {
        WikipediaAPI.loadThumbnailImage(for: sight) {[unowned self] result in
            self.state = .finished
        }
    }
}
