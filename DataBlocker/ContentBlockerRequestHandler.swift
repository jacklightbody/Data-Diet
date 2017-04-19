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

		let item = NSExtensionItem()
		var data = Data()
		data = "".data(using: String.Encoding.utf8)!
		/*if ViewController().onWifi(){
			data = "".data(using: String.Encoding.utf8)!
		}else{
			data = BlockedResources().getBlockedJSON()
		}*/
		let attachment = NSItemProvider(item: data as NSSecureCoding, typeIdentifier: kUTTypeJSON as String)
		item.attachments = [attachment]
        context.completeRequest(returningItems: [item], completionHandler: nil)
    }
	
}
