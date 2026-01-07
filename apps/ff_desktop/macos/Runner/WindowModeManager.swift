import Cocoa
import FlutterMacOS
import Foundation
import macos_window_utils

class WindowModeManager: NSObject {
    private weak var mainFlutterWindow: MainFlutterWindow?
    private weak var popover: NSPopover?
    private weak var statusBarController: StatusBarController?
    private weak var flutterViewController: FlutterViewController?

    init(
        mainFlutterWindow: MainFlutterWindow?,
        popover: NSPopover,
        statusBarController: StatusBarController?
    ) {
        self.mainFlutterWindow = mainFlutterWindow
        self.popover = popover
        self.statusBarController = statusBarController
    }

    func setup(with flutterViewController: FlutterViewController) {
        self.flutterViewController = flutterViewController

        popover?.contentSize = NSSize(width: 800, height: 600)

        // Move content view controller to popover initially
        if let wrapper = mainFlutterWindow?.contentViewController {
            popover?.contentViewController = wrapper
        } else {
            popover?.contentViewController = flutterViewController
        }

        setupMethodChannel()

        // Read persisted window mode (shared_preferences uses "flutter." prefix)
        let isWindowMode =
            UserDefaults.standard.object(forKey: "flutter.settings.window_mode") as? Bool ?? true

        if isWindowMode {
            // Window Mode: move content back to window
            if let controller = popover?.contentViewController {
                mainFlutterWindow?.contentViewController = controller
                popover?.contentViewController = nil
            }

            mainFlutterWindow?.makeKeyAndOrderFront(nil)
            NSApp.setActivationPolicy(.regular)
            statusBarController?.setStatusItemVisible(false)

        } else {
            // Popover Mode
            mainFlutterWindow?.orderOut(nil)
            mainFlutterWindow?.contentViewController = nil

            NSApp.setActivationPolicy(.accessory)
            statusBarController?.setStatusItemVisible(true)

            DispatchQueue.main.async {
                self.statusBarController?.showPopover(self)
            }
        }
    }

    private func setupMethodChannel() {
        guard let binaryMessenger = flutterViewController?.engine.binaryMessenger else { return }

        let channel = FlutterMethodChannel(
            name: "flutter/window_mode",
            binaryMessenger: binaryMessenger
        )

        channel.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "toggleWindowMode" {
                self?.toggleWindowMode()
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }

    func toggleWindowMode() {
        guard self.flutterViewController != nil else { return }
        guard let popover = self.popover else { return }

        // Determine current mode based on popover content
        let isPopoverMode = popover.contentViewController != nil

        if isPopoverMode {
            // Switch to Window Mode (Dock Icon Visible, Menu Icon Hidden)
            let controllerToMove = popover.contentViewController!
            popover.close()
            popover.contentViewController = nil

            if let window = mainFlutterWindow {
                window.contentViewController = controllerToMove
                window.makeKeyAndOrderFront(nil)

                NSApp.setActivationPolicy(.regular)
                statusBarController?.setStatusItemVisible(false)

                DispatchQueue.main.async {
                    NSApp.activate(ignoringOtherApps: true)
                }
            }
        } else {
            // Switch to Popover Mode (Dock Icon Hidden, Menu Icon Visible)
            if let window = mainFlutterWindow, let controller = window.contentViewController {
                window.orderOut(nil)
                window.contentViewController = nil
                popover.contentViewController = controller

                NSApp.setActivationPolicy(.accessory)
                statusBarController?.setStatusItemVisible(true)

                DispatchQueue.main.async {
                    self.statusBarController?.showPopover(self)
                }
            }
        }
    }
}
