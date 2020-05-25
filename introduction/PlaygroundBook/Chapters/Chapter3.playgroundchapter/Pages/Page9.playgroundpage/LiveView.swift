import UIKit
import PlaygroundSupport

let dashBoardController: DashBoardViewController = DashBoardViewController("3-9", [.Display, .RGB], [.ButtonA, .Pin], [])
PlaygroundPage.current.liveView = dashBoardController
