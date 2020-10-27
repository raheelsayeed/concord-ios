//
//  MasterViewController.swift
//  Concord
//
//  Created by Raheel Sayeed on 12/12/19.
//  Copyright © 2019 Medical Gear. All rights reserved.
//

import UIKit
import SMARTMarkers
import SMART
import ResearchKit
import SafariServices

class MasterViewController: UITableViewController {

    var taskController: TaskController?
    var sessionController: SessionController?
    var instruments = [Instrument]()
    var btnPatientSelector: UIBarButtonItem?
    var healthRecords: [[Report]]?
    var codes: [String]?
    var patient: Patient? {
        didSet {

        }
    }
    


	override func viewDidLoad() {
		super.viewDidLoad()
		
		let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String

		btnPatientSelector = UIBarButtonItem(title: "PPMG #\(appVersionString)", style: .plain, target: self, action: #selector(openReleaseNotes(_:)))
		

		
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Import HealthRecords", style: .plain, target: self, action: #selector(fetchHealthRecords(_:)))
		
		toolbarItems = [
			btnPatientSelector!,
			UIBarButtonItem(title: "Github", style: .plain, target: self, action: #selector(openLink(_:)))
		]

	}
	
	@objc func openLink(_ sender: Any?) {
		let view = SFSafariViewController(url: URL(string: "https://github.com/raheelsayeed/concord-ios")!)
		present(view, animated: true, completion: nil)
	}
	
	@objc func openReleaseNotes(_ sender: Any?) {
		let view = SFSafariViewController(url: URL(string: "https://github.com/raheelsayeed/concord-ios/blob/master/ReleaseNotes.md")!)
		present(view, animated: true, completion: nil)

	}

	override func viewWillAppear(_ animated: Bool) {
		clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
		super.viewWillAppear(animated)
	}

	// MARK: - Table View

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return healthRecords?.count ?? 0
	}
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "LabCell", for: indexPath) as! LabCell
        let records = healthRecords![indexPath.row]
        let title = records.first?.rp_title
        let recent = records.last!
        let chartPoints = records.map { Double($0.rp_observation!)! }

        cell.graphView.title = title
        cell.graphView.subtitle = "Most Recent: \(recent.rp_observation!) | Code: LOINC \(recent.rp_code?.code?.string ?? "$")"
        let (start, end) = colors(for: indexPath.row)
        cell.graphView.startColor = start
        cell.graphView.endColor = end
        cell.graphView.graphPoints = chartPoints
            
		return cell
	}
    
    func colors(for idx: Int) -> (UIColor, UIColor) {
        switch idx {
        case 0:
            return (UIColor(red:0.01, green:0.67, blue:0.69, alpha:1.0), UIColor(red:0.00, green:0.80, blue:0.67, alpha:1.0))
        case 1:
            return (UIColor(red:0.00, green:0.71, blue:0.86, alpha:1.0), UIColor(red:0.00, green:0.51, blue:0.69, alpha:1.0))
        case 2:
            return (UIColor(red: 1, green:  0.493272, blue: 0.473998, alpha: 1), UIColor(red: 1, green:  0.57810, blue: 0, alpha: 1))
        case 4:
            return (.lightGray, .gray)
        case 3:
            return (UIColor(red:1.00, green:0.25, blue:0.42, alpha:1.0), UIColor(red:1.00, green:0.29, blue:0.17, alpha:1.0))

        default:
            return (.lightGray, .gray)
        }
    }
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if let listView = (segue.destination as? UINavigationController)?.topViewController as? LabsTableViewController {
			listView.reports = healthRecords![tableView.indexPathForSelectedRow!.item]
		}
		
		super.prepare(for: segue, sender: sender)
		
	}

    
	
    


}



// Patient Selection

extension MasterViewController {
    
    @objc func fetchHealthRecords(_ sender: Any?) {
        
		let instrument = Instruments.HealthKit.HealthRecords.instance
        
        taskController = TaskController(instrument: instrument)
        
        taskController?.prepareSession(callback: { (task, error) in
            if let controller = task {
                self.present(controller, animated: true, completion: nil)
            }
        })
        
        taskController?.onTaskCompletion = { [unowned self] submissionBundle, error in
            
			// Only get the lab resources:
			
			if let fhir_reports = submissionBundle?.bundle.entry?.filter({ $0.resource is Observation})
				.map({ $0.resource as! Report })
			{
				
				
				let arranged = fhir_reports.reduce(into: [:]) { dict, report in
					dict[report.rp_code!.code!.string, default: [Report]()].append(report)
				}
				self.healthRecords = Array(arranged.values)
			}
			

			
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
