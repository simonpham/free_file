//
//  DraggableStatusBarButton.swift
//  Runner
//
//  Created by Simon Pham on 7/1/26.
//

import AppKit

/// A transparent overlay for the status bar button that detects when files are dragged over it.
/// When a drag enters the view, it triggers a callback to show the popover.
/// This overlay passes through click events to the underlying button.
class DraggableStatusBarButton: NSView {

    /// Called when a drag enters the view
    var onDragEntered: (() -> Void)?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupDragAndDrop()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDragAndDrop()
    }

    private func setupDragAndDrop() {
        // Register for file URL drags
        registerForDraggedTypes([.fileURL])
    }

    // MARK: - Event Handling

    // Return self so we can receive drag events
    override func hitTest(_ point: NSPoint) -> NSView? {
        return bounds.contains(point) ? self : nil
    }

    // Forward mouse events to the underlying button
    override func mouseDown(with event: NSEvent) {
        superview?.mouseDown(with: event)
    }

    override func mouseUp(with event: NSEvent) {
        superview?.mouseUp(with: event)
    }

    // MARK: - NSDraggingDestination

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        // Check if the drag contains file URLs
        guard
            sender.draggingPasteboard.canReadObject(
                forClasses: [NSURL.self], options: [.urlReadingFileURLsOnly: true])
        else {
            return []
        }

        // Show the popover when drag enters
        onDragEntered?()

        // Return copy to indicate we accept the drag (even though we don't handle the drop here)
        return .copy
    }

    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        // Continue to accept the drag
        return .copy
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        // We don't handle the drop here - the popover's Flutter content will handle it
        return false
    }
}
