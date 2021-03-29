//
//  UIViewController+Extension.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/17/21.
//

import UIKit

// MARK: - Storyboard Names Enumeration
enum Storyboards: String {
    case Main = "Main"
    case Weather = "Weather"
    case Onboarding = "Onboarding"
    case Premium = "Premium"
}

enum BulletSize: CGFloat {
    case mainBullet = 16.0
}

// MARK: - DispatchQueue
extension DispatchQueue {
    func after(_ delay: TimeInterval, execute closure: @escaping () -> Void) {
        asyncAfter(deadline: .now() + delay, execute: closure)
    }
}

// MARK: - UIViewController
extension UIViewController: UIGestureRecognizerDelegate {
    // MARK: - Controller Instantiation
    /// Providing any type of Controllers from any Storyboard
    /// - Parameter identifier: The Identifier of the Controller
    /// - Parameter name: The Storyboard Name
    static func instantiateFromStoryboard(_ name: Storyboards.RawValue = Storyboards.Main.rawValue, with identifier: String) -> Self {
        func instantiateFromStoryboardHelper<T>(_ name: String, with identifier: String) -> T {
            let storyboard = UIStoryboard(name: name, bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: identifier) as! T
            return controller
        }
        return instantiateFromStoryboardHelper(name, with: identifier)
    }
    
    static func instantiate(from storyboard: Storyboards, with identifier: String) -> Self {
        return instantiateFromStoryboard(storyboard.rawValue, with: identifier)
    }
    
    // MARK: - Haptic Touches
    /// Providing haptic touches
    /// - Parameter i: Integer which switches between cases
    func provideHaptic(i: Int = 1, after: TimeInterval = 0) {
        print("Running \(i)")
        DispatchQueue.main.asyncAfter(deadline: .now() + after) {
            
            switch i {
            case 0:
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
            case 1:
                var generator = UIImpactFeedbackGenerator()
                if #available(iOS 13.0, *) {
                    generator = UIImpactFeedbackGenerator(style: .rigid)
                } else {
                    // Fallback on earlier versions
                    generator = UIImpactFeedbackGenerator(style: .light)
                }
                generator.impactOccurred()
            case 4:
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            case 5:
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
            default:
                let generator = UISelectionFeedbackGenerator()
                generator.selectionChanged()
            }
        }
    }
    
    // Type Level
    static var typeName: String {
        return String(describing: self)
    }
    
    /// A helper function to add child view controller.
    func add(childViewController: UIViewController) {
      childViewController.willMove(toParent: self)
      addChild(childViewController)
      view.addSubview(childViewController.view)
      childViewController.didMove(toParent: self)
    }
    
    func addChild(controller: UIViewController, pinned: Bool = true, viewBack: Bool = true) {
        addChild(controller)
        view.addSubview(controller.view)
        controller.didMove(toParent: self)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        if pinned {
            view.pinAllEdges(to: controller.view)
            view.layoutIfNeeded()
        }
        if viewBack {
            view.sendSubviewToBack(controller.view)
        } else {
            view.bringSubviewToFront(controller.view)
        }
    }
    
    func removeChild(controller: UIViewController) {
        controller.view.removeFromSuperview()
        controller.removeFromParent()
    }
    
    func removeAllChildren() {
        children.forEach { removeChild(controller: $0) }
    }
    
    func alert(
        title: String? = "Warning",
        message: String? = nil,
        preferredStyle: UIAlertController.Style = .alert,
        cancelTitle: String? = nil,
        cancelHandler: (() -> Void)? = nil,
        actionTitle: String? = nil,
        actionHandler: (() -> Void)? = nil,
        actions: (UIAlertAction)...)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        if !actions.isEmpty {
            actions.forEach { alert.addAction($0) }
            
        } else {
            if let cancelTitle = cancelTitle {
                alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: { _ in
                    cancelHandler?()
                }))
            }
            
            if let actionTitle = actionTitle {
                alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (_) in
                    actionHandler?()
                }))
            }
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    private func present(_ viewControllerToPresent: UIViewController, style: UIModalPresentationStyle = .fullScreen, animated flag: Bool, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            viewControllerToPresent.modalPresentationStyle = style
            self.present(viewControllerToPresent, animated: flag, completion: completion)
        }
    }
    
    func push(_ viewControllerToPush: UIViewController, animated flag: Bool) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(viewControllerToPush, animated: true)
        }
    }
    
    func pop(animated flag: Bool) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: flag)
        }
    }
    
    func presentOverFullScreen(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        present(viewControllerToPresent, style: .overFullScreen, animated: flag, completion: completion)
    }
    
    func presentPopover(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        present(viewControllerToPresent, style: .popover, animated: flag, completion: completion)
    }
    
    func bulletedList(strings: [String], textColor: UIColor, font: UIFont, bulletColor: UIColor, bulletSize: BulletSize) -> NSAttributedString {
        let textAttributesDictionary = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor]
        
        let bulletAttributesDictionary = [NSAttributedString.Key.font: font.withSize(bulletSize.rawValue), NSAttributedString.Key.foregroundColor:bulletColor]
        let fullAttributedString = NSMutableAttributedString.init()
        
        for string: String in strings {
            let bulletPoint: String = "\u{2022}"
            let formattedString: String = "\(bulletPoint)     \(string)\n"
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString)
            let paragraphStyle = createParagraphAttribute()
            
            attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributedString.length))
            attributedString.addAttributes(textAttributesDictionary, range: NSMakeRange(0, attributedString.length))
            
            let string: NSString = NSString(string: formattedString)
            let rangeForBullet: NSRange = string.range(of: bulletPoint)
            
            attributedString.addAttributes(bulletAttributesDictionary, range: rangeForBullet)
            fullAttributedString.append(attributedString)
        }
        return fullAttributedString
    }
    
    private func createParagraphAttribute() -> NSParagraphStyle {
        
        var paragraphStyle: NSMutableParagraphStyle
        paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15, options: NSDictionary() as! [NSTextTab.OptionKey : AnyObject])]
        paragraphStyle.defaultTabInterval = 0
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.lineSpacing = 3
        paragraphStyle.headIndent = 30
        paragraphStyle.paragraphSpacing = 10
        return paragraphStyle
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    func generateBarcode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
}


extension UIViewController {
    private var overlayContainerView: UIView {
        if let navigationView: UIView = navigationController?.view {
            return navigationView
        }
        return view
    }

    func displayAnimatedActivityIndicatorView() {
        DispatchQueue.main.async {
            self.overlayContainerView.displayAnimatedActivityIndicatorView()
        }
    }

    func hideAnimatedActivityIndicatorView() {
        DispatchQueue.main.async {
            self.overlayContainerView.hideAnimatedActivityIndicatorView()
        }
    }
}

