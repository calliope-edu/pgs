import UIKit
import PlaygroundSupport

let dashBoardController: ApiCalliopeDashboardViewController = ApiCalliopeDashboardViewController("4-1", [.Display], [.Pin, .ButtonA, .ButtonB], [.Thermometer])
PlaygroundPage.current.liveView = dashBoardController
