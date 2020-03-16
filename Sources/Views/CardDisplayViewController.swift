//
//  CardDisplayViewController.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2020/03/12.
//

import Foundation

@objcMembers @objc(PAYCardDisplayViewController)
public class CardDisplayViewController: UIViewController {

    private var formStyle: FormStyle?
    private var tenantId: String?

    /// CardDisplayViewController factory method.
    ///
    /// - Parameters:
    ///   - style: formStyle
    ///   - tenantId: identifier of tenant
    /// - Returns: CardDisplayViewController
    @objc(createCardDisplayViewControllerWithStyle: tenantId:)
    public static func createCardDisplayViewController(style: FormStyle = .defaultStyle,
                                                       tenantId: String? = nil) -> CardDisplayViewController {
        let stotyboard = UIStoryboard(name: "CardDisplay", bundle: .payjpBundle)
        let naviVc = stotyboard.instantiateInitialViewController() as? UINavigationController
        guard
            let cardDisplayVc = naviVc?.topViewController as? CardDisplayViewController
            else { fatalError("Couldn't instantiate CardDisplayViewController") }
        cardDisplayVc.formStyle = style
        cardDisplayVc.tenantId = tenantId
        return cardDisplayVc
    }

}
