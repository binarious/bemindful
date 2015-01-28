//
//  AppDelegate.swift
//  BeMindful
//
//  Created by Martin Bieder on 26.01.15.
//  Copyright (c) 2015 Martin Bieder. All rights reserved.
//

import Cocoa
import CoreGraphics
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    var statusBar = NSStatusBar.systemStatusBar()
    var statusBarItem : NSStatusItem = NSStatusItem()
    var active : Int = 0
    var idleTime : Double = 0.0
    var lastHour :Double = 0.0
    var menu: NSMenu = NSMenu()
    var loginHandler: LoginHandler = LoginHandler()
    var menuItemStartup : NSMenuItem = NSMenuItem()
    
    
    func quitApp(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    func resetActive() {
        active = 0
        lastHour = 0.0
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        initMenu();

        // check idle time every minute
        var idleTimer = NSTimer.scheduledTimerWithTimeInterval(
            60,
            target: self,
            selector: Selector("updateIdle"),
            userInfo: nil,
            repeats: true
        )
        
        // count every minute
        var activeTimer = NSTimer.scheduledTimerWithTimeInterval(
            60.2,
            target: self,
            selector: Selector("updateActive"),
            userInfo: nil,
            repeats: true
        )
        
    }
    
    func setItemStartupText() {
        var startOnLogin = loginHandler.applicationIsInStartUpItems()
        menuItemStartup.title = startOnLogin ? "Don't start on login" : "Start on login"
    }
    
    func toggleLogin() {
        loginHandler.toggleLaunchAtStartup()
        setItemStartupText()
    }
    
    func initMenu() {
        // initially set status bar text
        statusBarItem = statusBar.statusItemWithLength(-1)
        statusBarItem.title = "0m"
        statusBarItem.menu = menu
        
        var menuItemReset : NSMenuItem = NSMenuItem()
        
        // Add quit item
        menuItemReset.title = "Reset"
        menuItemReset.action = Selector("resetActive")
        menuItemReset.keyEquivalent = ""
        menu.addItem(menuItemReset)
        
        
        // Add startup item
        menuItemStartup.action = Selector("toggleLogin")
        setItemStartupText()
        menuItemStartup.keyEquivalent = ""
        menu.addItem(menuItemStartup)
        
        
        var menuItemQuit : NSMenuItem = NSMenuItem()
        
        // Add quit item
        menuItemQuit.title = "Quit"
        menuItemQuit.action = Selector("quitApp:")
        menuItemQuit.keyEquivalent = ""
        menu.addItem(menuItemQuit)
    }
    
    /**
     * Determine active time and display it in the status bar
     */
    func updateActive () {
        
        // only active when not idle for a minute
        if idleTime < 60.0 {
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
        
        // check change in hours
        if (activeHour != lastHour) {
            activeHour = lastHour
            
            // show notification every active hour
            var notification:NSUserNotification = NSUserNotification()
            notification.title = "Be mindful!"
            notification.subtitle = "You've been active for an hour."
            var notificationcenter:NSUserNotificationCenter = NSUserNotificationCenter.defaultUserNotificationCenter()
            notificationcenter.scheduleNotification(notification)
        }
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
        
        if idleTime >= 5.0 * 60.0 {
            resetActive()
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    }
}

