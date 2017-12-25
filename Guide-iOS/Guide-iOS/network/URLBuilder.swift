import Foundation
import SwiftyBeaver

class URLBuilder {
    
    private let baseURL = "https://en.wikipedia.org/w/api.php?"
    private var currentURL: String
    
    init() {
        currentURL = baseURL
    }
    
    init(action: String, format: String, list: String) {
        currentURL = baseURL
        var _ = buildAction(action)
                .buildFormat(format)
                .buildList(list)
    }
    
    func buildAction(_ action: String) -> URLBuilder {
        currentURL += "action=" + action
        return self
    }
    
    func buildFormat(_ format: String) -> URLBuilder {
        currentURL += "&format=" + format
        return self
    }
    
    func buildList(_ list: String) -> URLBuilder {
        currentURL += "&list=" + list
        return self
    }
    
    func buildCoord(_ location: Location) -> URLBuilder {
        guard let latitude = location.latitude, let longtitude = location.longtitude else {
            SwiftyBeaver.warning("Location object is not correct")
            return self
        }
        
        currentURL += "&gscoord=\(latitude)|\(longtitude)"
        return self
    }
    
    func buildRadius(_ radius: Int) -> URLBuilder {
        currentURL += "&gsradius=\(radius)"
        return self
    }
    
    func buildLimit(_ count: Int) -> URLBuilder {
        currentURL += "&gslimit=\(count)"
        return self
    }
    
    func buildProp(_ prop: String) -> URLBuilder {
        currentURL += "&prop=" + prop
        return self
    }
    
    func buildRvprop(_ rvprop: String) -> URLBuilder {
        currentURL += "&rvprop=" + rvprop
        return self
    }
    
    func buildTitle(_ title: String) -> URLBuilder {
        currentURL += "&title=" + title
        return self
    }
    
    func buildPageId(_ id: Int64) -> URLBuilder {
        currentURL += "&pageids=\(id)"
        return self
    }
    
    func buildInprop(_ inprop: String) -> URLBuilder {
        currentURL += "&inprop=" + inprop
        return self
    }
    
    func getURL() -> String{
        return currentURL
    }
}
