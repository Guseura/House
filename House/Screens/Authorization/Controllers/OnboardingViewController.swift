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
    
    // Collection Views
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Page Controls
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    // MARK: - Variables
    
    let screenWidth = UIScreen.main.bounds.width
    
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(collectionView, with: Cell.onboardingCell)
    }
    
    
    // MARK: - Custom functions
    
    override func configureUI() {
        self.view.backgroundColor = UIColor.BMainColor
    }
    
    
    // MARK: - @IBActions
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        if pageControl.currentPage != (Onboarding.onboardingItems.count - 1) {
            collectionView.scrollToItem(at: IndexPath(item: pageControl.currentPage + 1, section: 0), at: .centeredVertically, animated: true)
            pageControl.currentPage += 1
        } else {
            print("DEBUG PRINT | Message: { It`s the last page } ")
        }
    }
    

}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Onboarding.onboardingItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.onboardingCell.id, for: indexPath) as! OnboardingCollectionViewCell
        
        let item = Onboarding.onboardingItems[indexPath.row]
        cell.onboardingTitleLabel.text = item.title
        cell.onboardingSubtitleLabel.text = item.subtitle
        cell.onboardingImage.image = item.image
        
        cell.cellWidthConstraint.constant = screenWidth
        cell.cellHeightConstraint.constant = collectionView.frame.height
        
        return cell
    
    }
    
    // Delegate Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(((collectionView.contentOffset.x + 40) / collectionView.frame.width).rounded(.toNearestOrAwayFromZero))
    }
    
}
