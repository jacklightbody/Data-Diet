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
		let defaults = UserDefaults(suiteName: "group.com.jacklightbody.datadiet")
		defaults!.set(true, forKey: "setDefaults")
		defaults!.set(possibleResources, forKey: dataKey)
		defaults!.set("wifi", forKey: "connectionMethod")
		defaults!.synchronize()
		let groupRoot = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.jacklightbody.datadiet")
		let blockerURL = groupRoot!.appendingPathComponent("data.json")
		let defaultJson = "[{\"action\": {\"type\": \"block\"},\"trigger\": {\"url-filter\": \".*\",\"resource-type\": [\"image\",\"font\",\"svg-document\",\"media\",\"popup\",\"style-sheet\",\"script\",\"raw\"]}}]"
		do{
			try defaultJson.write(to: blockerURL, atomically: false, encoding: String.Encoding.utf8)
		} catch let error as NSError {
			print("error writing to url \(blockerURL)")
			print(error.localizedDescription)
		}
		
		writeBlockedResources()
	}
	func onWifi() -> Bool{
		let defaults = UserDefaults(suiteName: "group.com.jacklightbody.datadiet")
		defaults!.synchronize()
		return defaults!.string(forKey: "connectionMethod")! == "wifi"
	}
	func getBlockedResources() -> [String]?{
		let defaults = UserDefaults(suiteName: "group.com.jacklightbody.datadiet")
		defaults!.synchronize()
		return defaults!.stringArray(forKey: dataKey)
	}
	func toggleResource(_ resource: String){
		let blockedResources = getBlockedResources()
		if blockedResources!.index(of: resource) == nil{
			// we aren\"t blocking it currently, so start doing so
			addBlockedResource(resource: resource)
		}else{
			// we are blocking it, so stop it
			removeBlockedResource(resource: resource)
		}

	}
	func addBlockedResource(resource: String){
		let defaults = UserDefaults(suiteName: "group.com.jacklightbody.datadiet")
		var blockedResources = getBlockedResources()
		if blockedResources!.index(of: resource) == nil{
			blockedResources?.append(resource)
			defaults!.set(blockedResources, forKey: dataKey)
			defaults!.synchronize()
			writeBlockedResources()
		}
		// already being blocked, don\"t need to do anything
	}
	func removeBlockedResource(resource: String){
		let defaults = UserDefaults(suiteName: "group.com.jacklightbody.datadiet")
		var blockedResources = getBlockedResources()
		let index = blockedResources!.index(of: resource)
		if index != nil{
			blockedResources?.remove(at: index!)
			defaults!.set(blockedResources, forKey: dataKey)
			defaults!.synchronize()
			writeBlockedResources()
		}
		// already unblocked, don\"t need to do anything
		
	}
	func writeBlockedResources(){
		let blockedResources = getBlockedResources()
		//let bundle = Bundle.init(for: NSClassFromString("ContentBlockerRequestHandler")!)
		// need to figure out how to get path to file in diff target
		var outputJson = JSON(blockedResources as Any).rawString(String.Encoding.utf8)
		outputJson = "[{\"action\": {\"type\": \"block\"},\"trigger\": {\"url-filter\": \".*\",\"resource-type\":"+outputJson!
		outputJson = outputJson! + "}}]"
		if onWifi(){
			outputJson = "[{\"action\": {\"type\": \"block\"},\"trigger\": {\"url-filter\": \"nkjsadnfkjsdnafkjsdnkfjsnd\",\"resource-type\":[]}}]"
		}
		print(outputJson)
		let groupRoot = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.jacklightbody.datadiet")
		let blockerURL = groupRoot!.appendingPathComponent("data.json")
		
		do{
			try outputJson?.write(to: blockerURL, atomically: true, encoding: String.Encoding.utf8)
		} catch let error as NSError {
			print("error writing to url \(blockerURL)")
			print(error.localizedDescription)
		}
		reloadBlocker()
	}
	func reloadBlocker(){
		SFContentBlockerManager.reloadContentBlocker(withIdentifier: "com.jacklightbody.data-diet.DataBlocker"){error in
			guard error == nil else{
				print(error?.localizedDescription)
				print(error)
				print("error")
				return
			}
			print("success")
		}
	}
}
