//
//  TrackView.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 31/07/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import Foundation
import AppKit
import SwiftUI


// just a helper to make using nicer by keeping #if os(macOS) in one place
extension View {
  @ViewBuilder func workaroundForVerticalScrollingBugInMacOS() -> some View {
    VerticalScrollingFixWrapper { self }
  }
}


// this is the NSView that implements proper `wantsForwardedScrollEvents` method
final class VerticalScrollingFixHostingView<Content>: NSHostingView<Content> where Content: View {

  override func wantsForwardedScrollEvents(for axis: NSEvent.GestureAxis) -> Bool {
    return axis == .horizontal
  }
}

// this is the SwiftUI wrapper for our NSView
struct VerticalScrollingFixViewRepresentable<Content>: NSViewRepresentable where Content: View {
  
  let content: Content
  
  func makeNSView(context: Context) -> NSHostingView<Content> {
    return VerticalScrollingFixHostingView<Content>(rootView: content)
  }

  func updateNSView(_ nsView: NSHostingView<Content>, context: Context) {}

}

// this is the SwiftUI wrapper that makes it easy to insert the view
// into the existing SwiftUI view builders structure
struct VerticalScrollingFixWrapper<Content>: View where Content : View {

  let content: () -> Content
  
  init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content
  }
  
  var body: some View {
    VerticalScrollingFixViewRepresentable(content: self.content())
  }
}
