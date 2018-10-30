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
    
    var settings: ScheduleSearchOptions
    var completionHandler: ExitClosure
    
    init(settings: ScheduleSearchOptions, completionHandler: @escaping ExitClosure) {
        self.settings = settings
        self.completionHandler = completionHandler
        super.init(nibName: "SchedulesOptionsModalView", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOut))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
        buildButton.setCornerRadius(at: 5)
        self.view.layoutIfNeeded()
        self.view.layoutSubviews()
        self.darkView.alpha = 0
        modalView.transform = CGAffineTransform(translationX: 0,
                                                y: modalView.frame.height - 86 - view.safeAreaInsets.bottom)
        displayInitialSettings()
    }
    
    private func displayInitialSettings() {
        hideClosedCourses.selectedSegmentIndex = settings.searchFullCourses ? 0 : 1
        minimizeGaps.selectedSegmentIndex = settings.gapOrder == .asc ? 0 : 1
        minimizeDays.selectedSegmentIndex = settings.dayOrder == .asc ? 0 : 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.layoutIfNeeded()
        self.view.layoutSubviews()
        self.darkView.alpha = 0
        modalView.transform = CGAffineTransform(translationX: 0,
                                                y: modalView.frame.height - 86 - view.safeAreaInsets.bottom)
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.darkView.alpha = 1
            self?.modalView.layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
            self?.modalView.setCornerRadius(at: 5)
            self?.modalView.transform = CGAffineTransform.identity
        }
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
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let strongSelf = self else { return }
            self?.darkView.alpha = 0
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

