//
//  AppDelegate.swift
//  Jira
//
//  Created by Ryan Popa on 6/20/17.
//  Copyright © 2017 MovSoft. All rights reserved.
//

import Cocoa
import WebKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  fileprivate let jiraTeamUrl = "openbay.atlassian.net"
  fileprivate let homepage = "/browse/MOBILE"
  
  @IBOutlet weak var webView: WKWebView!
  @IBOutlet weak var window: NSWindow!

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    self.window.titlebarAppearsTransparent = true
    self.window.backgroundColor = NSColor.background
    
    self.window.setFrameUsingName("mainWindow")
    self.window.setFrameAutosaveName("mainWindow")
    self.window.windowController?.shouldCascadeWindows = false
    self.window.isReleasedWhenClosed = false
    
    let jiraUrl = URL(string: "https://\(self.jiraTeamUrl)\(self.homepage)")!
    self.webView.load(URLRequest(url: jiraUrl))
    self.webView.navigationDelegate = self
    self.webView.wantsLayer = true
    self.webView.setValue(false, forKey: "drawsBackground")
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }

  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }
  
  func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    self.window.setIsVisible(true)
    return true
  }
  
  @IBAction func newWindow(_ sender: NSMenuItem) {
    self.window.makeKeyAndOrderFront(sender)
  }
  
  @IBAction func reloadPage(_ sender: NSMenuItem) {
    self.webView.reload()
  }
}

//Mark: - WKNavigationDelegate Methods

extension AppDelegate: WKNavigationDelegate {
  
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    guard let clickedUrl = navigationAction.request.url, let clickedUrlHost = clickedUrl.host, navigationAction.navigationType == .linkActivated else {
      decisionHandler(.allow)
      return
    }
    
    //Open clicked links in external browser
    if !clickedUrlHost.contains(self.jiraTeamUrl) {
      NSWorkspace.shared().open(clickedUrl)
      decisionHandler(.cancel)
    } else {
      decisionHandler(.allow)
    }
  }
}

