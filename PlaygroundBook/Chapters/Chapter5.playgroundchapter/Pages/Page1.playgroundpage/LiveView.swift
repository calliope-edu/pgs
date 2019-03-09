import UIKit
import PlaygroundSupport

let dashBoardController: DashBoardViewController = DashBoardViewController("4-1", [.Display], [.Pin, .ButtonA, .ButtonB], [.Thermometer])
PlaygroundPage.current.liveView = dashBoardController
