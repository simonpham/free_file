//
//  StatusBarController.swift
//  Runner
//
//  Created by Simon Pham on 7/1/26.
//

import AppKit

class StatusBarController {
    // Instance of the status bar
    private var appStatusBar: NSStatusBar

    // Instance of the status bar item
    private var statusBarMenuItem: NSStatusItem

    // Instance of the popover that will display the Flutter UI
    private var flutterUIPopover: NSPopover

    // Initializer for the StatusBarController class
    init(_ popover: NSPopover) {
        self.flutterUIPopover = popover
        appStatusBar = NSStatusBar.system
        statusBarMenuItem = appStatusBar.statusItem(withLength: 28.0)

        // Configure the status bar item's button
        if let statusBarMenuButton = statusBarMenuItem.button {
            // Set the button's image
            statusBarMenuButton.image = #imageLiteral(resourceName: "MenuBarIcon")
            statusBarMenuButton.image?.size = NSSize(width: 18.0, height: 18.0)
            statusBarMenuButton.image?.isTemplate = true

            // Set the button's action to toggle the popover when clicked
            statusBarMenuButton.action = #selector(togglePopover(sender:))
            statusBarMenuButton.target = self

            // Add a transparent overlay to handle drag-and-drop
            let draggableOverlay = DraggableStatusBarButton(frame: statusBarMenuButton.bounds)
            draggableOverlay.onDragEntered = { [weak self] in
                guard let self = self else { return }
                if !self.flutterUIPopover.isShown {
                    self.showPopover(draggableOverlay)
                }
            }

            statusBarMenuButton.addSubview(draggableOverlay)
            draggableOverlay.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                draggableOverlay.leadingAnchor.constraint(
                    equalTo: statusBarMenuButton.leadingAnchor),
                draggableOverlay.trailingAnchor.constraint(
                    equalTo: statusBarMenuButton.trailingAnchor),
                draggableOverlay.topAnchor.constraint(equalTo: statusBarMenuButton.topAnchor),
                draggableOverlay.bottomAnchor.constraint(equalTo: statusBarMenuButton.bottomAnchor),
            ])
        }
    }

    // Function to toggle the popover when the status bar item's button is clicked
    @objc func togglePopover(sender: AnyObject) {
        if flutterUIPopover.isShown {
            hidePopover(sender)
        } else {
            showPopover(sender)
        }
    }

    // Function to show the popover
    func showPopover(_ sender: AnyObject) {
        if let statusBarMenuButton = statusBarMenuItem.button {
            flutterUIPopover.show(
                relativeTo: statusBarMenuButton.bounds, of: statusBarMenuButton,
                preferredEdge: NSRectEdge.maxY)
        }
    }

    // Function to hide the popover
    func hidePopover(_ sender: AnyObject) {
        flutterUIPopover.performClose(sender)
    }

    // Function to set status item visibility
    func setStatusItemVisible(_ visible: Bool) {
        statusBarMenuItem.isVisible = visible
    }
}
