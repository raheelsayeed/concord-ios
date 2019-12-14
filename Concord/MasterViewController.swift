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

class MasterViewController: UITableViewController {

    var taskController: TaskController?
    var sessionController: SessionController?
    var instruments = [Instrument]()
    var btnPatientSelector: UIBarButtonItem?
    var healthRecords: [[Report]]?
    var codes: [String]?
    var patient: Patient? {
        didSet {
            DispatchQueue.main.async {
                self.btnPatientSelector?.title = self.patient?.humanName ?? "Select Patient"
            }
        }
    }
    


	override func viewDidLoad() {
		super.viewDidLoad()
        
        Patient.read("b85d7e00-3690-4e2a-87a0-f3d2dfc908b3", server: Server.Demo()) { [weak self] (p, e) in
            self?.patient = (p as? Patient)
        }
        
        btnPatientSelector = UIBarButtonItem(title: "Select Patient", style: .plain, target: self, action: #selector(selectPatient(_:)))
        navigationItem.leftBarButtonItem = btnPatientSelector
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(fetchHealthRecords(_:)))

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
        cell.graphView.subtitle = "Most Recent: \(recent.rp_observation!) | Code: LOINC \(recent.rp_code!.code!.string)"
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

    
	
    


}

extension SMART.Server {
    
    class func Demo() -> Server {
        let srv = Server(baseURL: URL(string: "https://r4.smarthealthit.org/")!)
        srv.name = "SMART Health IT"
        return srv
    }
}

// Patient Selection

extension MasterViewController {
    
    @objc func selectPatient(_ sender: Any?) {
        
        let patientSelect = PatientListAll()
        let patientSelectView = PatientListViewController(list: patientSelect, server: Server.Demo())
        patientSelectView.onPatientSelect = { (patient) in
            self.patient = patient
        }
        self.present(patientSelectView, animated: true, completion: nil)
        
    }
    
    @objc func fetchHealthRecords(_ sender: Any?) {
        
        let instrument = Instruments.HealthKit.HealthRecords.instance
        
        taskController = TaskController(instrument: instrument)
        
        taskController?.prepareSession(callback: { (task, error) in
            if let controller = task {
                self.present(controller, animated: true, completion: nil)
            }
        })
        
        taskController?.onTaskCompletion = { [unowned self] submissionBundle, error in
            
            let fhir_reports = submissionBundle?.bundle.entry?.map({ (bundleEntry) -> Report in
                return bundleEntry.resource as! Report
            })
            
            let arranged = fhir_reports?.reduce(into: [:]) { dict, report in
                dict[report.rp_code!.code!.string, default: [Report]()].append(report)
            }
            
            self.healthRecords = Array(arranged!.values)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
}
