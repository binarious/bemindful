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
    var idleTime : Double = 0.0
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        // initially set status bar text
        statusBarItem = statusBar.statusItemWithLength(-1)
        statusBarItem.title = "0m"

        
        // check idle time every minute
        var idleTimer = NSTimer.scheduledTimerWithTimeInterval(
            1, // test with 1 sec
            target: self,
            selector: Selector("updateIdle"),
            userInfo: nil,
            repeats: true
        )
        
        // count every minute
        var activeTimer = NSTimer.scheduledTimerWithTimeInterval(
            1.2, // test with 1.2 sec
            target: self,
            selector: Selector("updateActive"),
            userInfo: nil,
            repeats: true
        )
        
    }
    
    /**
     * Determine active time and display it in the status bar
     */
    func updateActive () {
        
        if idleTime < 5.0 {
            active = active + 1
        }
        
        var activeMin  = active % 60
        var activeHour = floor(Double(active) / 60)
        var activeStr  = ""
        
        if activeHour > 0 {
            activeStr = NSString(format: "%.0f", activeHour) + "h "
        }
        
        activeStr += String(activeMin) + "m"
        statusBarItem.title = activeStr
    }
    
    /**
     * If idle time > 5 minutes then reset the active time
     */
    func updateIdle () {
        // collect mouse and keyboard events
        let idleTimeMouse    = CGEventSourceSecondsSinceLastEventType(0, kCGEventMouseMoved)
        let idleTimeKeyboard = CGEventSourceSecondsSinceLastEventType(0, kCGEventKeyDown)
        
        if idleTimeKeyboard > idleTimeMouse {
            idleTime = idleTimeMouse
        } else {
            idleTime = idleTimeKeyboard
        }
        
        if idleTime >= 5.0 {
            active = 0
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    }


}

