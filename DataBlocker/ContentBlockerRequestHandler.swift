//
//  ContentBlockerRequestHandler.swift
//  DataBlocker
//
//  Created by Jack lightbody on 3/24/17.
//  Copyright © 2017 Jack lightbody. All rights reserved.
//

import UIKit
import MobileCoreServices
import SystemConfiguration
import SafariServices
class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
		let groupRoot = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.jacklightbody.datadiet")
		let item = NSExtensionItem()
		let blockerURL = groupRoot!.appendingPathComponent("data.json")
		item.attachments = [ NSItemProvider(contentsOf: blockerURL)! ]
        context.completeRequest(returningItems: [item], completionHandler: nil)
    }
	func onWifi() -> Bool{
		let defaults = UserDefaults(suiteName: "group.com.jacklightbody.datadiet")
		print("test")
		print(defaults!.string(forKey: "connectionMethod"))
		return defaults!.string(forKey: "connectionMethod")! == "wifi"
	}
	
}
