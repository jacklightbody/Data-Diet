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
		"script"
	]
	let dataKey = "blocked"
	
	init(){
		let defaults = UserDefaults.standard
		if !defaults.bool(forKey: "openedBefore"){
			// If we don't have any user defaults
			// ie its the first time we opened it
			// just block everything
			defaults.set(true, forKey: "openedBefore")
			defaults.set(possibleResources, forKey: dataKey)
			defaults.synchronize()
		}
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
		let fileLocation = Bundle.main.path(forResource: "datalist", ofType: "json")
		// need to figure out how to get path to file in diff target
		let fileHandle = FileHandle(forWritingAtPath:fileLocation!)
		var outputJson = JSON(blockedResources as Any).rawString(String.Encoding.utf8)
		outputJson = "[{'action': {'type': 'block'},'trigger': {'url-filter': '.*','resource-type':"+outputJson!
		outputJson = outputJson! + "}}]"
		let data = Data(base64Encoded: outputJson!, options: [])
		fileHandle!.write(data!)
		fileHandle?.closeFile()
		SFContentBlockerManager.reloadContentBlocker(withIdentifier: "com.jacklightbody.data-diet.DataBlocker", completionHandler: nil)
	}
}
