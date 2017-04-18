//
//  BlockedResources.swift
//  data diet
//
//  Created by Jack lightbody on 4/14/17.
//  Copyright © 2017 Jack lightbody. All rights reserved.
//
//  This class serves as the model for the class
//	Providing operations to add and remove the resources that are blocked
//

import Foundation
import SafariServices
class BlockedResources{
	let possibleResources: [String]  = [
		"image",
		"font",
		"svg-document",
		"media",
		"popup",
		"style-sheet",
		"script",
		"raw"
	]
	let dataKey = "blockedResources"
	func setDefaultResources(){
		let defaults = UserDefaults.standard
		defaults.set(true, forKey: "setDefaults")
		defaults.set(possibleResources, forKey: dataKey)
		defaults.synchronize()
	}
	func getBlockedResources() -> [String]?{
		let defaults = UserDefaults.standard
		return defaults.stringArray(forKey: dataKey)
	}
	func toggleResource(_ resource: String){
		let blockedResources = getBlockedResources()
		if blockedResources!.index(of: resource) == nil{
			// we aren't blocking it currently, so start doing so
			addBlockedResource(resource: resource)
		}else{
			// we are blocking it, so stop it
			removeBlockedResource(resource: resource)
		}
	}
	func addBlockedResource(resource: String){
		let defaults = UserDefaults.standard
		var blockedResources = getBlockedResources()
		if blockedResources!.index(of: resource) == nil{
			blockedResources?.append(resource)
			defaults.set(blockedResources, forKey: dataKey)
			defaults.synchronize()
			writeBlockedResources()
		}
		// already being blocked, don't need to do anything
	}
	func removeBlockedResource(resource: String){
		let defaults = UserDefaults.standard
		var blockedResources = getBlockedResources()
		let index = blockedResources!.index(of: resource)
		if index != nil{
			blockedResources?.remove(at: index!)
			defaults.set(blockedResources, forKey: dataKey)
			defaults.synchronize()
			writeBlockedResources()
		}
		// already not being blocked, don't need to do anything
		
	}
	func writeBlockedResources(){
		let blockedResources = getBlockedResources()
		//let bundle = Bundle.init(for: NSClassFromString("ContentBlockerRequestHandler")!)
		let fileLocation = Bundle.main.path(forResource: "datalist", ofType: "json")
		// need to figure out how to get path to file in diff target
		let fileHandle = FileHandle(forWritingAtPath:fileLocation!)
		fileHandle?.truncateFile(atOffset: 0)
		var outputJson = JSON(blockedResources as Any).rawString(String.Encoding.utf8)
		outputJson = "[\n\t{\n\t\t'action': {\n\t\t\t'type': 'block'\n\t\t},\n\t\t'trigger': {\n\t\t\t'url-filter': '.*',\n\t\t\t'resource-type':"+outputJson!
		outputJson = outputJson! + "\n\t\t}\n\t}\n]"
		let data = outputJson!.data(using: String.Encoding.utf8)!
		fileHandle!.write(data)
		fileHandle?.closeFile()
		SFContentBlockerManager.reloadContentBlocker(withIdentifier: "com.jacklightbody.data-diet.DataBlocker"){error in
			guard error == nil else{
				print(error)
				return
			}
		}
	}
}
