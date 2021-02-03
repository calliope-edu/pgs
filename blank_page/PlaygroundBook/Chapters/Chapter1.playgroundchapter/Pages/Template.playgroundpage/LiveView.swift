import UIKit
import PlaygroundSupport

let dashBoardController: ApiCalliopeDashboardViewController = ApiCalliopeDashboardViewController("5-2", [.Display, .RGB, .Sound], [.Pin, .ButtonA, .ButtonB, .Shake], [.Thermometer, .Brightness, .Noise])
PlaygroundPage.current.liveView = dashBoardController
