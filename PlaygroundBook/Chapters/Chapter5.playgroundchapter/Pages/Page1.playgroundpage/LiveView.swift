import UIKit
import PlaygroundSupport

let dashBoardController: ApiCalliopeDashboardViewController = ApiCalliopeDashboardViewController("4-1", [.Display, .RGB, .Sound], [.Pin, .ButtonA, .ButtonB], [.Thermometer, .Brightness, .Noise])
PlaygroundPage.current.liveView = dashBoardController
