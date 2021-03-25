//
//  OnboardingViewController.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/23/21.
//

import UIKit
import StoreKit

class OnboardingViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var snakePageControl: SnakePageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Properties
    var slides: [Slide] = []
    
    // MARK: - Override properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            // Fallback on earlier versions
            return .default
        }
    }
    
    // MARK: - View LyfeCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Functions
    private func configureView() {
        slides = Slide.slides
        
        scrollView.delegate = self
        
        setupSlideScrollView(slides: slides)
        
        nextButton.isEnabled = true
        nextButton.isHidden = false
        nextButton.cornerRadius(to: 10)
        
        snakePageControl.pageCount = slides.count
        snakePageControl.progress = 0
        snakePageControl.previousTint = .mainDarkGray
        
        view.bringSubviewToFront(snakePageControl)
    }
    
    /// Setting up Slide Scroll View
    func setupSlideScrollView(slides: [Slide]) {
        let viewWidth = view.frame.width
        let viewHeight = view.frame.height
        let slidesCount = slides.count
        
        scrollView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        scrollView.contentSize = CGSize(width: viewWidth * CGFloat(slidesCount), height: viewHeight)
        scrollView.isPagingEnabled = true
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: viewWidth * CGFloat(i), y: 0, width: viewWidth, height: viewHeight)
            scrollView.addSubview(slides[i])
        }
    }
    
    func setupScrollViewDidScroll(scrollView: UIScrollView, pageIndex: CGFloat) {
        snakePageControl.progress = pageIndex
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
        
        /*
         * below code changes the background color of view on paging the scrollview
         */
        //        self.scrollView(scrollView, didScrollToPercentageOffset: percentageHorizontalOffset)
        
        
        /*
         * below code scales the imageview on paging the scrollview
         */
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        
        
        
        if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
            snakePageControl.previousTint = .mainDarkGray
        } else if(percentOffset.x > 0.25 && percentOffset.x <= 0.50) {
            snakePageControl.previousTint = .mainYellow
        }
        
        if percentOffset.x > 0.7 {
            snakePageControl.isHidden = true
            nextButton.isHidden = true
            nextButton.isEnabled = false
        } else {
            nextButton.isHidden = false
            nextButton.isEnabled = true
            snakePageControl.isHidden = false
        }
    }
    
    // MARK: - IBActions
    @IBAction func nextTapped(_ sender: Any) {
        var frame = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat((snakePageControl.currentPage + 1))
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: true)
    }
}

// MARK: - UIScrollViewDelegate
extension OnboardingViewController: UIScrollViewDelegate {
    /*
     * default function called when view is scrolled. In order to enable callback
     * when scrollview is scrolled, the below code needs to be called:
     * slideScrollView.delegate = self or
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setupScrollViewDidScroll(scrollView: scrollView, pageIndex: scrollView.contentOffset.x/view.frame.width)
    }
    
    func scrollView(_ scrollView: UIScrollView, didScrollToPercentageOffset percentageHorizontalOffset: CGFloat) {
        print("here")
    }
}
