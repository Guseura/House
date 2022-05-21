//
//  Onboarding.swift
//  House
//
//  Created by Yurij on 09.03.2022.
//

import UIKit

struct Onboarding {
    
    let title: String
    let subtitle: String
    let image: UIImage
    
    static let onboardingItems: [Onboarding] = [
        Onboarding(title: localized("onboarding.first.title"), subtitle: localized("onboarding.first.description"), image: UIImage.Onboarding.first),
        Onboarding(title: localized("onboarding.second.title"), subtitle: localized("onboarding.second.description"), image: UIImage.Onboarding.second),
        Onboarding(title: localized("onboarding.third.title"), subtitle: localized("onboarding.third.description"), image: UIImage.Onboarding.third)
    ]
}

