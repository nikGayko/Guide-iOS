import Foundation
import SwiftyBeaver

class URLBuilder {
    
    private let baseURL = "https://en.wikipedia.org/w/api.php?"
    private var currentURL: String
    
    //Contains parameters with multiple values
    private var parameters = [String: [String]]()
    
    init() {
        currentURL = baseURL
    }
    
    convenience init(action: String, format: String, generator: String) {
        self.init()
        var _ = buildAction(action)
                .buildFormat(format)
//                .buildList(list)
                .buildGenerator(generator)
    }
    
    convenience init(action: String, format: String, generator: String, options: [WikipediaAPIOptions]) {
        self.init(action: action, format: format, generator: generator)
        var _ = buildWithOptions(options)
    }
    
    final func buildWithOptions(_ options: [WikipediaAPIOptions]) -> URLBuilder {
        var builder: URLBuilder = self
        for option in options {
            switch option {
            case .radius(let value):
                builder = buildRadius(value)
            case .responseCount(let value):
                builder = buildLimit(value)
            case .original:
                builder = builder.buildPiprop("original")
            case .thumbnail(let maxWidth):
                builder = builder.buildPiprop("thumbnail")
                    .buildPithumbsize(maxWidth)
            }
        }
        return builder
    }
    
    func buildAction(_ action: String) -> URLBuilder {
        currentURL += "action=" + action
        return self
    }
    
    func buildFormat(_ format: String) -> URLBuilder {
        currentURL += "&format=" + format
        return self
    }
    
//    func buildList(_ list: String) -> URLBuilder {
//        currentURL += "&list=" + list
//        return self
//    }
    
    func buildGenerator(_ generator: String) -> URLBuilder {
        currentURL += "&generator=" + generator
        return self
    }
    
    func buildCoord(_ location: Location) -> URLBuilder {
        guard let latitude = location.latitude, let longtitude = location.longtitude else {
            SwiftyBeaver.warning("Location object is not correct")
            return self
        }
        
        currentURL += "&ggscoord=\(latitude)|\(longtitude)"
        return self
    }
    
    func buildRadius(_ radius: Int) -> URLBuilder {
        currentURL += "&ggsradius=\(radius)"
        return self
    }
    
    /** Set maximum pages count in response */
    func buildLimit(_ count: Int) -> URLBuilder {
        currentURL += "&ggslimit=\(count)"
        return self
    }
    
    /** Maximum width of thumbnail image */
    func buildPithumbsize(_ width: Int) -> URLBuilder {
        currentURL += "&pithumbsize=\(width)"
        return self
    }
    
    /** Include image urls in response */
    func buildPiprop(_ piprop: String) -> URLBuilder{
        if parameters["piprop"] != nil {
            parameters["piprop"]! += [piprop]
        } else {
            parameters["piprop"] = [piprop]
        }
        return self
    }
    
    func buildProp(_ prop: String) -> URLBuilder {
        if parameters["prop"] != nil {
            parameters["prop"]! += [prop]
        } else {
            parameters["prop"] = [prop]
        }
        return self
    }
//
//    func buildRvprop(_ rvprop: String) -> URLBuilder {
//        currentURL += "&rvprop=" + rvprop
//        return self
//    }
//
//    func buildTitle(_ title: String) -> URLBuilder {
//        currentURL += "&title=" + title
//        return self
//    }
//
//    func buildPageId(_ id: Int64) -> URLBuilder {
//        currentURL += "&pageids=\(id)"
//        return self
//    }
//
//    func buildInprop(_ inprop: String) -> URLBuilder {
//        currentURL += "&inprop=" + inprop
//        return self
//    }
    
    func getURL() -> String {
        
        for (key, valueArray) in parameters {
            currentURL += "&\(key)="
            for value in valueArray {
                currentURL += value + "|"
            }
            currentURL.removeLast()
        }
        return currentURL
    }
}
