//
//  ViewController.swift
//  Runner
//
//  Created by Konstantin Snegov on 01/09/16.
//  Copyright © 2016 Konstantin Snegov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

	@IBOutlet weak var displayLabel: UILabel!
	@IBOutlet weak var lapDisplayLabel: UILabel!
	@IBOutlet weak var fireButton: UIButton!
	@IBOutlet weak var lapButton: UIButton!
	@IBOutlet weak var lapsTableView: UITableView!
	
	var timer : NSTimer?
	var interval : NSTimeInterval = 0.0
	var lapInterval : NSTimeInterval = 0.0
	let tick = 0.05
	var laps = [String]()
	
	var timerIsRunning = false
	
	@IBAction func tapFireButton() {
		if timerIsRunning {
			stop()
		} else {
			start()
		}
		timerIsRunning = !timerIsRunning
	}
	
	@IBAction func tapLapButton() {
		if timerIsRunning {
			addLap()
		} else {
			reset()
		}
	}
	
	func start() {
		fireButton.setTitle("Stop", forState: .Normal)
		lapButton.setTitle("Lap", forState: .Normal)
		
		timer = NSTimer.scheduledTimerWithTimeInterval(tick, target: self, selector: #selector(timerChanged), userInfo: nil, repeats: true)
		timer?.fire()
	}
	
	func stop() {
		fireButton.setTitle("Start", forState: .Normal)
		lapButton.setTitle("Reset", forState: .Normal)
		
		timer?.invalidate()
	}
	
	func reset() {
		interval = 0.0
		lapInterval = 0.0
		
		laps.removeAll()
		lapsTableView.reloadData()
		
		lapButton.setTitle("Lap", forState: .Normal)
		displayLabel.text = "00:00.00"
		lapDisplayLabel.text = "00:00.00"
	}
	
	func addLap() {
		if !timerIsRunning {
			return;
		}
		
		let lapTime = splitInterval(lapInterval)
		let lapString = String(format: "%02d:%02d.%.02d", lapTime.minutes, lapTime.seconds, lapTime.miliseconds)
		
		laps.append(lapString)
		lapsTableView.reloadData()
		
		lapInterval = 0.0
		lapDisplayLabel.text = "00:00.00"
	}
	
	func timerChanged() {
		
		interval += tick
		lapInterval += tick
		
		let time = splitInterval(interval)
		let lapTime = splitInterval(lapInterval)
		
		displayLabel.text = String(format: "%02d:%02d.%.02d", time.minutes, time.seconds, time.miliseconds)
		lapDisplayLabel.text = String(format: "%02d:%02d.%.02d", lapTime.minutes, lapTime.seconds, lapTime.miliseconds)
	}
	
	func splitInterval(interval : NSTimeInterval) -> (minutes: Int, seconds: Int, miliseconds : Int) {
	
		let minutes = Int(interval) / 60
		let seconds = Int(interval) - minutes * 60
		let miliseconds = Int(interval % 1 * 100)
	
		return (minutes, seconds, miliseconds)
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return laps.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("LapCell", forIndexPath: indexPath)
		
		cell.textLabel?.text = laps[indexPath.row]
		
		return cell
	}
}
