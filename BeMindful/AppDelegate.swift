//
//  AppDelegate.swift
//  BeMindful
//
//  Created by Martin Bieder on 26.01.15.
//  Copyright (c) 2015 Martin Bieder. All rights reserved.
//

import Cocoa
import CoreGraphics

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    var statusBar = NSStatusBar.systemStatusBar()
    var statusBarItem : NSStatusItem = NSStatusItem()
    
    var active : Int = 0
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        statusBarItem = statusBar.statusItemWithLength(-1)
        
        var idleTimer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: Selector("updateIdle"), userInfo: nil, repeats: true)
        var activeTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateActive"), userInfo: nil, repeats: true)
        
    }
    
    func updateActive () {
        active = active + 1
        
        statusBarItem.title = "T: " + String(active)
    }
    
    func updateIdle () {
        let idleTimeMouse = CGEventSourceSecondsSinceLastEventType(0, kCGEventMouseMoved)
        let idleTimeKeyboard = CGEventSourceSecondsSinceLastEventType(0, kCGEventKeyDown)
        var idleTime = 0.0
        
        if idleTimeKeyboard > idleTimeMouse {
            idleTime = idleTimeMouse
        } else {
            idleTime = idleTimeKeyboard
        }
        
        if idleTime > 5.0 {
            active = 0
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

