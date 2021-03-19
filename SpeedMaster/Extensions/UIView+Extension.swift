//
//  UIView+Extension.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/17/21.
//

import UIKit

enum LINE_POSITION {
    case LINE_POSITION_TOP
    case LINE_POSITION_BOTTOM
}

// MARK: - UIView
extension UIView {
    var width: CGFloat { bounds.width }
    var height: CGFloat { bounds.height }
    
    static let loadingViewTag = 1938123987
    func showLoading(style: UIActivityIndicatorView.Style = .gray, color: UIColor? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            var loading = self.viewWithTag(UIView.loadingViewTag) as? UIActivityIndicatorView
            if loading == nil {
                loading = UIActivityIndicatorView(style: style)
            }
            if let color = color {
                loading?.color = color
            }
            loading?.translatesAutoresizingMaskIntoConstraints = false
            loading!.startAnimating()
            loading!.hidesWhenStopped = true
            loading?.tag = UIView.loadingViewTag
            self.addSubview(loading!)
            loading?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            loading?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        }
    }

    func stopLoading() {
        DispatchQueue.main.async {
            let loading = self.viewWithTag(UIView.loadingViewTag) as? UIActivityIndicatorView
            loading?.stopAnimating()
            loading?.removeFromSuperview()
        }
    }
    
    func circled() {
        let circle = self.layer.frame.size.width / 2
        self.cornerRadius(to: circle)
    }
    
    func addBorder(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func addBlurView(style: UIBlurEffect.Style, color: UIColor? = .clear) {
        self.backgroundColor = color
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        self.layer.masksToBounds = true
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: 0)
        //        addSubview(blurEffectView)
    }
    
    func pinAllEdges(to subview: UIView) {
        leadingAnchor.constraint(equalTo: subview.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: subview.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: subview.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: subview.bottomAnchor).isActive = true
    }
    
    func addShadowAndRadius(_ radius: CGFloat, _ opacity: Float, _ bool: Bool) {
        layer.cornerRadius = radius
        layer.masksToBounds = bool
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = 20
    }
    
    // CornerRadius
    func cornerRadius(to radius: CGFloat) {
        if self is UILabel || self is UITextField {
            self.layer.masksToBounds = true
        }
        self.layer.cornerRadius = radius
    }
    
    func addLine(position : LINE_POSITION, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lineView)
        
        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
        
        switch position {
        case .LINE_POSITION_TOP:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        case .LINE_POSITION_BOTTOM:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        }
    }
    
    /// A helper function to add multiple subviews.
    func addSubviews(_ subviews: UIView...) {
      subviews.forEach {
        addSubview($0)
      }
    }
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?.first as! T
    }
}

fileprivate let overlayViewTag: Int = 999
fileprivate let activityIndicatorViewTag: Int = 1000

// Public interface
extension UIView {
    func displayAnimatedActivityIndicatorView() {
        DispatchQueue.main.async {
            self.setActivityIndicatorView()
        }
    }

    func hideAnimatedActivityIndicatorView() {
        DispatchQueue.main.async {
            self.removeActivityIndicatorView()
        }
    }
}

// Private interface
extension UIView {
    private var activityIndicatorView: UIActivityIndicatorView {
        if #available(iOS 13.0, *) {
            let view: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
            view.color = .mainGrayAverage
            view.translatesAutoresizingMaskIntoConstraints = false
            view.tag = activityIndicatorViewTag
            return view
        } else {
            // Fallback on earlier versions
            let view: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
            view.color = .mainGrayAverage
            view.translatesAutoresizingMaskIntoConstraints = false
            view.tag = activityIndicatorViewTag
            return view
        }
    }

    private var overlayView: UIView {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0.5
        view.tag = overlayViewTag
        return view
    }

    private func setActivityIndicatorView() {
        guard !isDisplayingActivityIndicatorOverlay() else { return }
        let overlayView: UIView = self.overlayView
        let activityIndicatorView: UIActivityIndicatorView = self.activityIndicatorView

        //add subviews
        overlayView.addSubview(activityIndicatorView)
        overlayView.bringSubviewToFront(activityIndicatorView)
        addSubview(overlayView)
        bringSubviewToFront(activityIndicatorView)

        //add overlay constraints
        overlayView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        overlayView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true

        //add indicator constraints
        activityIndicatorView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor).isActive = true

        //animate indicator
        activityIndicatorView.startAnimating()
    }

    private func removeActivityIndicatorView() {
        guard let overlayView: UIView = getOverlayView(), let activityIndicator: UIActivityIndicatorView = getActivityIndicatorView() else {
            return
        }
        UIView.animate(withDuration: 0.2, animations: {
            overlayView.alpha = 0.0
            activityIndicator.stopAnimating()
        }) { _ in
            activityIndicator.removeFromSuperview()
            overlayView.removeFromSuperview()
        }
    }

    private func isDisplayingActivityIndicatorOverlay() -> Bool {
        getActivityIndicatorView() != nil && getOverlayView() != nil
    }

    private func getActivityIndicatorView() -> UIActivityIndicatorView? {
        viewWithTag(activityIndicatorViewTag) as? UIActivityIndicatorView
    }

    private func getOverlayView() -> UIView? {
        viewWithTag(overlayViewTag)
    }
}

