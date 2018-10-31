//
//  SchedulesOptions.swift
//  Lynx
//
//  Created by Maxime Moison on 10/29/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class SchedulesOptionsModalView: UIViewController {
    
    typealias ExitClosure = (_ action: ExitAction, _ options: ScheduleSearchOptions) -> Void
    
    enum ExitAction {
        case save
        case build
        case dismiss
    }
    
    @IBOutlet weak var buildButton: UIButton!
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var darkView: UIView!
    @IBOutlet weak var hideClosedCourses: UISegmentedControl!
    @IBOutlet weak var minimizeGaps: UISegmentedControl!
    @IBOutlet weak var minimizeDays: UISegmentedControl!
    @IBOutlet weak var earliestPlusButton: UIButton!
    @IBOutlet weak var earliestMinusButton: UIButton!
    @IBOutlet weak var latestPlusButton: UIButton!
    @IBOutlet weak var latestMinusButton: UIButton!
    @IBOutlet weak var earliestLabel: UILabel!
    @IBOutlet weak var latestLabel: UILabel!
    
    var settings: ScheduleSearchOptions
    var completionHandler: ExitClosure
    
    var earliest: Double = 0
    var latest: Double = 0
    
    init(settings: ScheduleSearchOptions, completionHandler: @escaping ExitClosure) {
        self.settings = settings
        self.completionHandler = completionHandler
        super.init(nibName: "SchedulesOptionsModalView", bundle: Bundle.main)
        self.earliest = convertTime(settings.earliest)
        self.latest = convertTime(settings.latest)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOut))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
        earliestPlusButton.setCornerRadius(at: 5)
        earliestMinusButton.setCornerRadius(at: 5)
        latestPlusButton.setCornerRadius(at: 5)
        latestMinusButton.setCornerRadius(at: 5)
        buildButton.setCornerRadius(at: 5)
        view.layoutIfNeeded()
        view.layoutSubviews()
        darkView.alpha = 0
        hideClosedCourses.alpha = 0
        modalView.layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        modalView.transform = CGAffineTransform(translationX: 0,
                                                y: modalView.frame.height - 86 - view.safeAreaInsets.bottom)
        displayInitialSettings()
    }
    
    private func displayInitialSettings() {
        hideClosedCourses.selectedSegmentIndex = settings.searchFullCourses ? 0 : 1
        minimizeGaps.selectedSegmentIndex = settings.gapOrder == .asc ? 0 : 1
        minimizeDays.selectedSegmentIndex = settings.dayOrder == .asc ? 0 : 1
        updateTimeLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.layoutIfNeeded()
        self.view.layoutSubviews()
        self.darkView.alpha = 0
        modalView.transform = CGAffineTransform(translationX: 0,
                                                y: modalView.frame.height - 86 - view.safeAreaInsets.bottom)
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.darkView.alpha = 1
            self?.hideClosedCourses.alpha = 1
            self?.modalView.setCornerRadius(at: 15)
            self?.modalView.transform = CGAffineTransform.identity
        }
    }
    
    // MARK: change times +/-
    @IBAction func earliestMinusTap() {
        earliest -= 0.5
        updateTimeLabels()
    }
    @IBAction func earliestPlusTap() {
        earliest += 0.5
        updateTimeLabels()
    }
    
    @IBAction func latestMinusTap() {
        latest -= 0.5
        updateTimeLabels()
    }
    @IBAction func latestPlusTap() {
        latest += 0.5
        updateTimeLabels()
    }
    
    // MARK: Time conversion
    private func convertTime(_ time: Int) -> Double {
        return Double(time/100) + Double(time%100)/60
    }
    private func convertTime(_ time: Double) -> Int {
        return Int(time) * 100 + Int(60 * (time - Double(Int(time))))
    }
    private func timeString(_ time: Double) -> String {
        let isAM = Int(time) / 12 == 0
        let hours = "\(isAM || Int(time) == 12 ? Int(time) : Int(time) - 12)"
        let minutes = "\(convertTime(time)%100)".padding(toLength: 2, withPad: "0", startingAt: 0)
        return "\(hours):\(minutes) \(isAM ? "am" : "pm")"
    }
    
    private func updateTimeLabels() {
        updateButtons()
        earliestLabel.text = "Earliest: \(timeString(earliest))"
        latestLabel.text = "Latest: \(timeString(latest))"
    }
    
    private func updateButtons() {
        earliestPlusButton.isEnabled = earliest < 23.5
        earliestMinusButton.isEnabled = earliest > 6.5
        latestPlusButton.isEnabled = latest < 23.5
        latestMinusButton.isEnabled = latest > 6.5
    }
    
    @IBAction func buildTap() {
        close(.build)
    }
    
    @IBAction func savedSchedulesTap() {
        close(.save)
    }
    
    @IBAction func tappedOut() {
        close(.dismiss)
    }
    
    func close(_ action: ExitAction) {
        settings.searchFullCourses = hideClosedCourses.selectedSegmentIndex == 0
        settings.gapOrder = minimizeGaps.selectedSegmentIndex == 0 ? .asc : .desc
        settings.dayOrder = minimizeDays.selectedSegmentIndex == 0 ? .asc : .desc
        settings.earliest = convertTime(earliest)
        settings.latest = convertTime(latest)
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            guard let strongSelf = self else { return }
            self?.darkView.alpha = 0
            self?.hideClosedCourses.alpha = 0
            self?.modalView.setCornerRadius(at: 0)
            strongSelf.modalView.transform = CGAffineTransform(translationX: 0,
                                                                    y: strongSelf.modalView.frame.height - 86 - strongSelf.view.safeAreaInsets.bottom)
        }) { [weak self] _ in
            self?.dismiss(animated: false, completion: { [weak self] in
                guard let strongSelf = self else { return }
                self?.completionHandler(action, strongSelf.settings)
            })
        }
    }
}

extension SchedulesOptionsModalView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchedView = touch.view, !touchedView.isDescendant(of: modalView) else {
            return false
        }
        return true
    }
}

