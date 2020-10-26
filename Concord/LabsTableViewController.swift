//
//  LabsTableViewController.swift
//  Concord
//
//  Created by Raheel Sayeed on 26/10/20.
//  Copyright © 2020 Medical Gear. All rights reserved.
//

import UIKit
import SMARTMarkers


class LabsTableViewController: UITableViewController {
	
	var reports: [Report]?

    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Labs"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return reports?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath)
		let report = reports![indexPath.item]
		cell.textLabel?.text = report.rp_title
		cell.detailTextLabel?.text = report.rp_observation
        return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let report = reports![indexPath.item]
		let viewer = ReportViewController(report)
		self.present(viewer, animated: true, completion: nil)

	}

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
