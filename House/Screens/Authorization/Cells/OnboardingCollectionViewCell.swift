//
//  OnboardingCollectionViewCell.swift
//  House
//
//  Created by Yurij on 09.03.2022.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {

    // MARK: - @IBOutlets
    
    // Labels
    @IBOutlet weak var onboardingTitleLabel: UILabel!
    @IBOutlet weak var onboardingSubtitleLabel: UILabel!
    
    // Images
    @IBOutlet weak var onboardingImage: UIImageView!
    
    // Constraints
    @IBOutlet weak var cellHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cellWidthConstraint: NSLayoutConstraint!

}
