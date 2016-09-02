//
//  ViewController.swift
//  Runner
//
//  Created by Konstantin Snegov on 01/09/16.
//  Copyright © 2016 Konstantin Snegov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var displayLabel: UILabel!
	@IBOutlet weak var fireButton: UIButton!
	
	var timer : NSTimer?
	var interval : NSTimeInterval = 0.0
	let tick = 0.05
	
	var timerIsRunning = false
	
	@IBAction func tapFireButton() {
		if timerIsRunning {
			stop()
		} else {
			start()
		}
		timerIsRunning = !timerIsRunning
	}
	
	func start() {
		fireButton.setTitle("Stop", forState: .Normal)
		
		timer = NSTimer.scheduledTimerWithTimeInterval(tick, target: self, selector: #selector(timerChanged), userInfo: nil, repeats: true)
		timer?.fire()
	}
	
	func stop() {
		fireButton.setTitle("Start", forState: .Normal)
		
		timer?.invalidate()
	}
	
	func timerChanged() {
		
		interval += tick
		
		let minutes = Int(interval) / 60
		let seconds = Int(interval) - minutes * 60
		let miliseconds = Int(interval % 1 * 100)
		
		displayLabel.text = String(format: "%02d:%02d.%.02d", minutes, seconds, miliseconds)
	}
}
