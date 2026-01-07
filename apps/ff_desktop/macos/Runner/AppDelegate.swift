import Cocoa
import FlutterMacOS
import macos_window_utils

@main
class AppDelegate: FlutterAppDelegate {
    var statusBarController: StatusBarController?
    var flutterUIPopover = NSPopover.init()
    var flutterViewController: FlutterViewController?
    var windowModeManager: WindowModeManager?

    override init() {
        flutterUIPopover.behavior = NSPopover.Behavior.transient
    }

    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }

    override func applicationDidFinishLaunching(_ aNotification: Notification) {
        guard let contentViewController = mainFlutterWindow?.contentViewController else {
            print("Could not find contentViewController")
            return
        }

        // Extract FlutterViewController (may be wrapped by MacOSWindowUtilsViewController)
        let flutterViewController: FlutterViewController
        if let controller = contentViewController as? FlutterViewController {
            flutterViewController = controller
        } else if let controller = contentViewController as? MacOSWindowUtilsViewController {
            flutterViewController = controller.flutterViewController
        } else {
            print("Unknown contentViewController type")
            return
        }

        self.flutterViewController = flutterViewController

        statusBarController = StatusBarController.init(flutterUIPopover)

        windowModeManager = WindowModeManager(
            mainFlutterWindow: mainFlutterWindow as? MainFlutterWindow,
            popover: flutterUIPopover,
            statusBarController: statusBarController
        )
        windowModeManager?.setup(with: flutterViewController)

        super.applicationDidFinishLaunching(aNotification)
    }

    override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}
