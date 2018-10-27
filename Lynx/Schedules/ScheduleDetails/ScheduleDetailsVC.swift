//
//  ScheduleDetailsVC.swift
//  Lynx
//
//  Created by Maxime Moison on 4/7/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

protocol ScheduleDetailsDelegate: class {
    func getSchedule() -> Schedule
    func getTerm() -> String
    func isSaved() -> Bool
    func removeScheduleLocally()
}

class ScheduleDetailsVC: UIViewController {

    @IBOutlet weak var coursesTable: UITableView!
    @IBOutlet weak var actionButton: UIButton!
    weak var detailDelegate: ScheduleDetailsDelegate!
    var loadingView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton.setTitle(detailDelegate.isSaved() ? "Remove" : "Save", for: .normal)

        let nib = UINib.init(nibName: "CourseCell", bundle: nil)
        self.coursesTable.register(nib, forCellReuseIdentifier: "CourseCell")
        // Do any additional setup after loading the view.
        coursesTable.dataSource = self
        coursesTable.delegate = self
        coursesTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveSchedule(_ sender: Any) {
        guard let delegate = detailDelegate else { return }
        if detailDelegate.isSaved() {
            self.didStartLoading()
            RestAPI.deleteSchedule(term: delegate.getTerm(),
                                   crns: delegate.getSchedule().crns,
                                   customEvents: delegate.getSchedule().customEvents,
                                   completionHandler: {
                self.didFinishLoading()
                delegate.removeScheduleLocally()
                self.dismiss(animated: true, completion: nil)
            }, errorHandler: { error in
                DispatchQueue.main.async { self.didFinishLoading() }
                self.handleError(error: error)
            })
        } else {
            RestAPI.saveSchedule(term: detailDelegate.getTerm(),
                                 crns: detailDelegate.getSchedule().crns,
                                 hasConflictingFinals: delegate.getSchedule().hasConflictingFinals,
                                 completionHandler: { [weak self] in
                                    self?.displayAlert(title: "Success", message: "This schedule was saved")
                                    self?.actionButton.isEnabled = false
                }, errorHandler: handleError)
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func didStartLoading(immediately: Bool=false) {
        let loadingView = UIView(frame: self.view.frame)

        let loadingLabel = UILabel(frame: CGRect(x: 32, y: self.view.frame.height/2-50, width: self.view.frame.width-64, height: 100))
        loadingLabel.text = "Loading..."
        loadingLabel.textColor = .lightGray
        loadingLabel.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
        loadingLabel.adjustsFontSizeToFitWidth = true
        loadingLabel.textAlignment = .center

        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        loadingView.addSubview(blurEffectView)
        loadingView.addSubview(loadingLabel)

        view.addSubview(loadingView)
        self.loadingView = loadingView

        if !immediately {
            loadingView.alpha = 0
            UIView.animate(withDuration: 0.5) {
                loadingView.alpha = 1
            }
        }
    }

    func didFinishLoading() {
        UIView.animate(withDuration: 0.5, animations: {
            self.loadingView?.alpha = 0
        }, completion: { _ in
            self.loadingView?.removeFromSuperview()
        })
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
