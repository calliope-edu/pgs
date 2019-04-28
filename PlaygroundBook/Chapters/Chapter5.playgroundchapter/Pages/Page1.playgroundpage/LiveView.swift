import UIKit
import PlaygroundSupport

let dashBoardController: ApiCalliopeDashboardViewController = ApiCalliopeDashboardViewController("5-1", [.Display, .RGB, .Sound], [.Pin, .ButtonA, .ButtonB], [.Thermometer, .Brightness, .Noise])
PlaygroundPage.current.liveView = dashBoardController
