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
    
    @IBOutlet weak var mainWindow: NSWindow!
    @IBOutlet weak var mainToolBar: NSToolbar!
    var today : Date = Date()
    let dateHelper = DateHelper()
    
    var baseViewModel = BaseViewModel()
    
    override func windowWillLoad() {
        
        let hostingView = NSHostingView(rootView:
            HStack{
                Button(action: {print("balls")}) {
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
            }.padding([.trailing, .leading], 12)
        )
        hostingView.frame.size = hostingView.fittingSize

        let titlebarAccessory = NSTitlebarAccessoryViewController()
        titlebarAccessory.view = hostingView
        titlebarAccessory.layoutAttribute = .trailing
        //mainWindow.isMovableByWindowBackground = true
        mainWindow.titlebarAppearsTransparent = true
        mainWindow.addTitlebarAccessoryViewController(titlebarAccessory)
        mainWindow.backgroundColor = NSColor.init(named: "GhostBlue")
        mainWindow.appearance = NSAppearance(named: .darkAqua)
        //mainWindow.subtitle = dateHelper.formatDateToBeauty(thisDate: today, type: "month_year")
    }
}
