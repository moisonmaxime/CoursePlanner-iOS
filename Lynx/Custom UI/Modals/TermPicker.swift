//
//  TermPicker.swift
//  Lynx
//
//  Created by Maxime Moison on 10/28/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class TermPicker: UIViewController {
    @IBOutlet weak var currentTermButton: UIButton!
    
    private var currentTerm: String
    private var terms: [String]
    private var completionHandler: (String?) -> Void
    
    init(currentTerm: String, terms: [String], completionHandler: @escaping (String?) -> Void) {
        self.currentTerm = currentTerm
        self.terms = terms
        self.completionHandler = completionHandler
        super.init(nibName: "TermPicker", bundle: Bundle.main)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentTermButton.setTitle(currentTerm.readableTerm(), for: .normal)
        view.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var offset = currentTermButton.frame.height + 16
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOut))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.view.alpha = 1
        }
        
        for term in terms {
            let button = UIButton(frame: currentTermButton.frame)
            button.setTitle(term.readableTerm(), for: .normal)
            button.setTitleColor(#colorLiteral(red: 0.3490196078, green: 0.6470588235, blue: 0.8470588235, alpha: 1), for: .normal)
            button.setCornerRadius(at: 5)
            button.backgroundColor = .white
            if let font = currentTermButton.titleLabel?.font {
                button.titleLabel?.font = font
            }
            button.addTarget(nil, action: #selector(didSelect), for: .touchUpInside)
            view.insertSubview(button, at: 0)
            UIView.animate(withDuration: 0.5) {
                button.transform = CGAffineTransform(translationX: 0, y: offset)
            }
            offset *= 2
        }
    }
    
    @IBAction func tappedOut() {
        close(with: nil)
    }
    
    @objc @IBAction private func didSelect(_ sender: UIButton) {
        guard let newTerm = sender.titleLabel?.text else { return }
        close(with: newTerm)
    }
    
    private func close(with term: String?) {
        currentTermButton.setTitle(term, for: .normal)
        let term = term?.termID() ?? nil
        completionHandler(term == currentTerm ? nil : term)
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            for button in self?.view.subviews ?? [] {
                self?.view.alpha = 0
                button.transform = CGAffineTransform.identity
            }
        }) { [weak self] _ in
            self?.dismiss(animated: false, completion: nil)
        }
    }
}
