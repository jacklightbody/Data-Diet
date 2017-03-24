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

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        let emptyjson = NSItemProvider(contentsOf: Bundle.main.url(forResource: "emptylist", withExtension: "json"))!
		let datajson = NSItemProvider(contentsOf: Bundle.main.url(forResource: "datalist", withExtension: "json"))!
		let jsonlist = [datajson, emptyjson]
		let i = wifiConnected() ? 1 : 0
        
        let item = NSExtensionItem()
        item.attachments = [jsonlist[i]]
        
        context.completeRequest(returningItems: [item], completionHandler: nil)
    }
	
	func wifiConnected() -> Bool {
		let reachability = Reachability()
		return (reachability?.isReachableViaWiFi)!
	}
}
