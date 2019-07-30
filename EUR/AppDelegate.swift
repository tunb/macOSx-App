//
//  AppDelegate.swift
//  EUR
//
//  Created by Ajai Nair on 7/27/19.
//  Copyright © 2019 mrb. All rights reserved.
//

import Cocoa
import SwiftSoup


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let popover = NSPopover()
    var eventMonitor: EventMonitor?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(sender: event)
            }
        }

        if let button = self.statusItem.button{
            button.frame = CGRect(x: 0, y: -1.2, width: button.frame.width, height: button.frame.height)
            button.action = #selector(togglePopover(_:))
        }
        
        let queue = DispatchQueue(label: "work-queue")
        
        queue.async {
            self.doFetch()
        }
    
        popover.contentViewController = EurViewController.freshController()
    }
    
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            eventMonitor?.start()

        }
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
        eventMonitor?.stop()
        (popover.contentViewController as! EurViewController).reset()
    }
    
    func doFetch() {
        while true {
            let url =  URL(string: "https://www.arionbanki.is")
            
            var currency = ""
            do {
                let htmlContent = try String(contentsOf: url!, encoding: .ascii)
                let doc: Document = try SwiftSoup.parse(htmlContent)
                let eurCur = try doc.select("td.currency-changer__sell").get(3)
                currency = try eurCur.text()
                let cur = Float(currency)
                SharedVar.sharedInstance.setCurrency(cur: cur!)
            } catch let error {
                print("Error: \(error)")
            }
            DispatchQueue.main.async {
                if let button = self.statusItem.button{
                    button.title = "€ " + currency
                }
            }
            usleep(1000000 * 60 * 5)
        }
    }
    

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    
}

