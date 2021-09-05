//
//  MultilineTextfield.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 15/08/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import Foundation
import SwiftUI
import AppKit

// Wraps the NSTextView in a frame that can interact with SwiftUI
struct MultilineTextField: View {

    var placeholder: NSAttributedString
    @State private var dynamicHeight: CGFloat // MARK TODO: - Find better way to stop initial view bobble (gets bigger)
    @State private var textViewInset: CGFloat = 9 // MARK TODO: - Calculate insetad of magic number
    var nsFont: NSFont

    init (_ placeholder: NSAttributedString,
          nsFont: NSFont) {
        self.placeholder = placeholder
        self.nsFont = nsFont
        _dynamicHeight = State(initialValue: nsFont.pointSize)
    }

    var body: some View {
        NSTextViewWrapper(dynamicHeight: $dynamicHeight,
                          realString: placeholder,
                          textViewInset: $textViewInset,
                          nsFont: nsFont)
            // Adaptive frame applied to this NSViewRepresentable
            .frame(minHeight: dynamicHeight, maxHeight: dynamicHeight)
    }
}

// Creates the NSTextView
fileprivate struct NSTextViewWrapper: NSViewRepresentable {

    @Binding var dynamicHeight: CGFloat
    var realString : NSAttributedString
    // Hoping to get this from NSTextView,
    // but haven't found the right parameter yet
    @Binding var textViewInset: CGFloat
    var nsFont: NSFont

    func makeCoordinator() -> Coordinator {
        return Coordinator(height: $dynamicHeight,
                           nsFont: nsFont,
                           realString: realString)
    }

    func makeNSView(context: NSViewRepresentableContext<NSTextViewWrapper>) -> NSTextView {
        return context.coordinator.textView
    }

    func updateNSView(_ textView: NSTextView, context: NSViewRepresentableContext<NSTextViewWrapper>) {
        textView.textStorage?.setAttributedString(realString)
        textView.textStorage?.font = nsFont
        textView.isAutomaticLinkDetectionEnabled = true
        textView.isAutomaticDataDetectionEnabled = true
        
        //Apple doesn't tell you but checkTextInDocument(nil) which allows NSTextView to detect data only works if the NSTextView is editable
        //so we toggle, check and toggle off
        textView.isEditable = true
        textView.checkTextInDocument(nil)
        textView.isEditable = false
        NSTextViewWrapper.recalculateHeight(view: textView, result: $dynamicHeight, nsFont: nsFont)
    }

    fileprivate static func recalculateHeight(view: NSView, result: Binding<CGFloat>, nsFont: NSFont) {
        // Uses visibleRect as view.sizeThatFits(CGSize())
        // is not exposed in AppKit, except on NSControls.
        let latestSize = view.visibleRect
        if result.wrappedValue != latestSize.height &&
            // MARK TODO: - The view initially renders slightly smaller than needed, then resizes.
            // I thought the statement below would prevent the @State dynamicHeight, which
            // sets itself AFTER this view renders, from causing it. Unfortunately that's not
            // the right cause of that redawing bug.
            latestSize.height > (nsFont.pointSize + 1) {
            DispatchQueue.main.async {
                result.wrappedValue = latestSize.height
                //print(#function, latestSize.height)
            }
        }
    }
}

// Maintains the NSTextView's persistence despite redraws
fileprivate final class Coordinator: NSObject, NSTextViewDelegate, NSControlTextEditingDelegate {
    var textView: NSTextView
    @Binding var dynamicHeight: CGFloat
    var nsFont: NSFont
    var realString : NSAttributedString

    init(height: Binding<CGFloat>,
         nsFont: NSFont, realString: NSAttributedString) {

       _dynamicHeight = height
        self.nsFont = nsFont
        self.realString = realString

        textView = NSTextView(frame: .zero)
        textView.isEditable = false
        textView.isSelectable = true

        // Appearance
        textView.usesAdaptiveColorMappingForDarkAppearance = true
        textView.font = nsFont
        textView.textColor = NSColor.textColor
        textView.drawsBackground = false
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        super.init()
        // Load data from binding and set font
        textView.textStorage?.setAttributedString(realString)
        textView.textStorage?.font = nsFont
        
        // Functionality (more available)
        textView.isAutomaticLinkDetectionEnabled = true
        textView.isAutomaticDataDetectionEnabled = true
        
        //Apple doesn't tell you but checkTextInDocument(nil) which allows NSTextView to detect data only works if the NSTextView is editable
        //so we toggle, check and toggle off
        textView.isEditable = true
        textView.checkTextInDocument(nil)
        textView.isEditable = false
        
        textView.delegate = self
    }

    func textDidChange(_ notification: Notification) {
        // Recalculate height after every input event
        NSTextViewWrapper.recalculateHeight(view: textView, result: $dynamicHeight, nsFont: nsFont)
    }
}

