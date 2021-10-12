//
//  MainWindowViewController.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 23/02/2020.
//  Copyright © 2020 Ephod. All rights reserved.
//

import Foundation
import AppKit
import SwiftUI

class MainWindowViewController: NSWindowController {
    
    @IBOutlet weak var mainToolbar: NSToolbar!
    @IBOutlet weak var mainWindow: NSWindow!
    @IBOutlet weak var mainToolBar: NSToolbar!
    var today : Date = Date()
    let dateHelper = DateHelper()
    
    var baseViewModel = BaseViewModel()
    
    override func windowWillLoad() {
        
        let hostingView = NSHostingView(rootView:
            HStack{
                Button(action: { postHideMonthSideBar() }) {
                    Image(systemName: "sidebar.left")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.white)
                }.padding([.trailing, .leading], 5)
                .buttonStyle(PlainButtonStyle())
                Spacer()
                Button(action: { postHideBackloghSideBar() }) {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.white)
                }.padding([.trailing, .leading], 5)
                .buttonStyle(PlainButtonStyle())
                Button(action: { reloadHomeScreenView() }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }.padding([.trailing, .leading], 5)
                .buttonStyle(PlainButtonStyle())
                Button(action: {self.baseViewModel.showPreferences()}) {
                    Image(systemName: "gear")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }.padding([.trailing, .leading], 5)
                .buttonStyle(PlainButtonStyle())
            }.padding([.trailing, .leading], 12).edgesIgnoringSafeArea(.all)
        )
        hostingView.frame.size = hostingView.fittingSize

        let titlebarAccessory = NSTitlebarAccessoryViewController()
        
        titlebarAccessory.view = hostingView
        titlebarAccessory.layoutAttribute = .top
        mainWindow.titlebarAppearsTransparent = true
        mainWindow.addTitlebarAccessoryViewController(titlebarAccessory)
        mainWindow.backgroundColor = NSColor.init(named: "GhostBlue")
    }
    
    override func windowDidLoad() {
        mainWindow.makeKeyAndOrderFront(nil)
    }
}

func reloadHomeScreenView(){
    NotificationCenter.default.post(Notification(name: .reload,
                                                       object: nil,
                                                       userInfo: nil))
}

func postHideMonthSideBar(){
    NotificationCenter.default.post(Notification(name: .hideMonthSidebar,
                                                       object: nil,
                                                       userInfo: nil))
}

func postHideBackloghSideBar(){
    NotificationCenter.default.post(Notification(name: .hideBacklogSidebar,
                                                       object: nil,
                                                       userInfo: nil))
}


extension Notification.Name {
    static var reload: Notification.Name { return .init("reload") }
    static var hideMonthSidebar: Notification.Name { return .init("hidemonthsidebar") }
    static var hideBacklogSidebar: Notification.Name { return .init("hideBacklogSidebar") }
}
