import UIKit
import PlaygroundSupport

let dashBoardController: DashBoardViewController = DashBoardViewController("2-6", [.Display, .RGB, .Sound], [.ButtonA, .ButtonB, .Shake], [])
PlaygroundPage.current.liveView = dashBoardController
