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
		let datajson = NSItemProvider(contentsOf: Bundle.main.url(forResource: "datalist", withExtension: "json"))!
		let item = NSExtensionItem()
		item.attachments = [datajson]
        context.completeRequest(returningItems: [item], completionHandler: nil)
    }
	
}
