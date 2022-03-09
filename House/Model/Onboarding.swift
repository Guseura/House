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
        Onboarding(title: "Communicate", subtitle: "Chat between residents of the house in a convenient chat room.", image: UIImage.Onboarding.first),
        Onboarding(title: "Solve problems", subtitle: "Put forward problems that you would like to eliminate in your area.", image: UIImage.Onboarding.second),
        Onboarding(title: "Payments", subtitle: "Make your payments conveniently. Do it with comfort in our App.", image: UIImage.Onboarding.third)
    ]
}

