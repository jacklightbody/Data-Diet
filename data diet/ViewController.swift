//
//  ViewController.swift
//  data diet
//
//  Created by Jack lightbody on 3/24/17.
//  Copyright © 2017 Jack lightbody. All rights reserved.
//

import UIKit
import SafariServices
import SystemConfiguration
class ViewController: UITableViewController{
	let br: BlockedResources = BlockedResources()
	@IBOutlet weak var imageSwitch: UISwitch!
	@IBOutlet weak var stylingSwitch: UISwitch!
	@IBOutlet weak var jsSwitch: UISwitch!
	@IBOutlet weak var fontsSwitch: UISwitch!
	@IBOutlet weak var popupsSwitch: UISwitch!
	@IBOutlet weak var mediaSwitch: UISwitch!
	let reachability = Reachability()
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
		do{
			try reachability?.startNotifier()
		}catch{
			print("could not start reachability notifier")
		}
		
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		let resources = br.getBlockedResources()
		SFContentBlockerManager.reloadContentBlocker(withIdentifier: "com.jacklightbody.data-diet.DataBlocker", completionHandler: nil)
		// Set all our switches to the appropriate values
		jsSwitch.setOn((resources?.contains("script"))!, animated: false)
		imageSwitch.setOn((resources?.contains("image"))!, animated: false)
		stylingSwitch.setOn((resources?.contains("style-sheet"))!, animated: false)
		fontsSwitch.setOn((resources?.contains("font"))!, animated: false)
		popupsSwitch.setOn((resources?.contains("popup"))!, animated: false)
		mediaSwitch.setOn((resources?.contains("media"))!, animated: false)
		self.navigationItem.hidesBackButton = true
	
		let _ = BlockedResources()
		// Do any additional setup after loading the view, typically from a nib.
	}
	@IBAction func imagesInfo(_ sender: Any) {
		let alert = UIAlertController(title: "Images", message: "Blocking images will save a large amount of data.", preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	@IBAction func stylingInfo(_ sender: Any) {
		let alert = UIAlertController(title: "Styling", message: "Blocking styling will make many sites layouts break, but will save a small-moderate amount of data", preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	@IBAction func jsInfo(_ sender: Any) {
		let alert = UIAlertController(title: "Javascript", message: "Blocking javascript will make some sites unusable by disabling user interation, but will save a moderate amount of data", preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	@IBAction func mediaInfo(_ sender: Any) {
		let alert = UIAlertController(title: "Media", message: "Blocking media will mean that videos and songs are blocked, but will save a huge amount of data", preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	@IBAction func popupsInfo(_ sender: Any) {
		let alert = UIAlertController(title: "Popups", message: "Blocking popups will mean that you may miss important information, but will save a small amount of data", preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	@IBAction func fontsInfo(_ sender: Any) {
		let alert = UIAlertController(title: "Fonts", message: "Blocking fonts may decrease readability, but will save a moderate amount of data", preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	@IBAction func imagesToggled(_ sender: Any) {
		br.toggleResource("image")
		br.toggleResource("svg-document")
	}
	@IBAction func stylingToggled(_ sender: Any) {
		br.toggleResource("style-sheet")
	}
	@IBAction func jsToggled(_ sender: Any) {
		br.toggleResource("script")
	}
	@IBAction func fontsToggled(_ sender: Any) {
		br.toggleResource("font")
	}
	@IBAction func popupsToggled(_ sender: Any) {
		br.toggleResource("popup")
	}
	@IBAction func mediaToggled(_ sender: Any) {
		br.toggleResource("media")
		br.toggleResource("raw")
	}
	func reachabilityChanged() {
		let defaults = UserDefaults.standard
		let reach = Reachability()!
		if reach.isReachable {
			if reach.isReachableViaWiFi {
				defaults.set("wifi", forKey: "connectionMethod")
				SFContentBlockerManager.reloadContentBlocker(withIdentifier: "com.jacklightbody.data-diet.DataBlocker", completionHandler: nil)
			} else {
				defaults.set("data", forKey: "connectionMethod")
				SFContentBlockerManager.reloadContentBlocker(withIdentifier: "com.jacklightbody.data-diet.DataBlocker", completionHandler: nil)
			}
		}
	}
}

