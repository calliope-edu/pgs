//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  Implements the application delegate for LiveViewTestApp with appropriate configuration points.
//

import UIKit
import PlaygroundSupport
import LiveViewHost
import Book_Sources

@UIApplicationMain
class AppDelegate: LiveViewHost.AppDelegate {
    override func setUpLiveView() -> PlaygroundLiveViewable {

//        let dashBoardController: DashBoardViewController = DashBoardViewController(
//            "1-1",
//            [.Display, .RGB, .Sound],
//            [.ButtonA, .ButtonB, .Pin, .Shake],
//            [.Thermometer, .Noise, .Brightness]
//        )

		let dashBoardController: ApiCalliopeDashboardViewController = ApiCalliopeDashboardViewController(
		    "1-1",
		    [.Display, .RGB, .Sound],
		    [.ButtonA, .ButtonB, .Pin, .Shake],
		    [.Thermometer, .Noise, .Brightness]
		)

        return dashBoardController
    }

    override var liveViewConfiguration: LiveViewConfiguration {
        // Make this property return the configuration of the live view which you desire to test.
        //
        // Valid values are `.fullScreen`, which simulates when the user has expanded the live
        // view to fill the full screen in Swift Playgrounds, and `.sideBySide`, which simulates when
        // the live view is shown next to or above the source code editor in Swift Playgrounds.
        return .sideBySide
    }
}
