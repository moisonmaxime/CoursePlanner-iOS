//
//  Popup.swift
//  Lynx
//
//  Created by Maxime Moison on 10/29/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class Popup: UIViewController {
    @IBOutlet weak var icon: UIView!
    @IBOutlet weak var iconOutline: UIView!
    @IBOutlet weak var popup: UIView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    init() {
        super.init(nibName: "Popup", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        icon.setCornerRadius(at: 32)
        iconOutline.setCornerRadius(at: 36)
        popup.setCornerRadius(at: 5)
        button1.setCornerRadius(at: 5)
        button2.setCornerRadius(at: 5)
        button3.setCornerRadius(at: 5)
        
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
