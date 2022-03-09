//
//  OnboardingViewController.swift
//  House
//
//  Created by Yurij on 08.03.2022.
//

import UIKit

class OnboardingViewController: BaseViewController {

    // MARK: - @IBOutlets
    
    // Buttons
    @IBOutlet weak var continueButton: MainButton!
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.BMainColor
    }

}
