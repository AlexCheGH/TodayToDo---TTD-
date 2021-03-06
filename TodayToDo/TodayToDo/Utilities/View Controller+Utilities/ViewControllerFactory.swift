//
//  ViewControllerFactory.swift
//  TodayToDo
//
//  Created by Alex Chekushkin on 1/13/22.
//

import Foundation
import UIKit

struct StoryboardRepresentation {
    let bundle: Bundle?
    let storyboardName: String
    let viewControllerID: String
}


enum TypeOfViewController {
    case main
    case detailedCard
    case settings
}

extension TypeOfViewController {
    func storyboardRepresentation() -> StoryboardRepresentation {
        let mainStoryboard = "Main"
        
        switch self {
        case .main:
            return StoryboardRepresentation(bundle: nil, storyboardName: mainStoryboard, viewControllerID: ViewControllerID.main.rawValue)
        case .detailedCard:
            return StoryboardRepresentation(bundle: nil, storyboardName: mainStoryboard, viewControllerID: ViewControllerID.detailedCard.rawValue)
        case .settings:
            return StoryboardRepresentation(bundle: nil, storyboardName: mainStoryboard, viewControllerID: ViewControllerID.settings.rawValue)
        }
    }
}

class ViewControllerFactory: NSObject {
    static func viewController(for typeOfVC: TypeOfViewController) -> UIViewController {
        let metadata = typeOfVC.storyboardRepresentation()
        let storyboard = UIStoryboard(name: metadata.storyboardName, bundle: metadata.bundle)
        let viewController = storyboard.instantiateViewController(withIdentifier: metadata.viewControllerID)
        
        return viewController
    }
}

fileprivate enum ViewControllerID: String {
    case main = "ViewController"
    case detailedCard = "DetailedCardViewController"
    case settings = "SettingsViewController"
}
