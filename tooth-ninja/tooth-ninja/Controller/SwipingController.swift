//
//  SwipingController.swift
//  autolayout_lbta

import UIKit

extension UIColor
{
    static var mainPink = UIColor(red: 232/255, green: 68/255, blue: 133/255, alpha: 1)
}

class SwipingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let pages =
        [
        Page(imageName: "brush", headerText: "Did you know?", bodyText: "Children should only start using toothpaste after 18 months of age? Before 6 years of age, children should use a pea-sized amount of children’s toothpaste, which has a lower concentration of fluoride (500-600 ppm) compared to adult toothpaste (>1000 ppm)"),
        Page(imageName: "notification", headerText: "Did you know?", bodyText: "Snacking in between meals can increase your chances of tooth decay? Sugary foods eaten during meal times have a smaller negative impact on your teeth compared to when eaten in-between meal times."),
        Page(imageName: "notification", headerText: "Did you know?", bodyText: "Your toothbrush should be replaced when the bristles start to fray? This is usually around 3 months after you start using a new toothbrush (or toothbrush head)."),
        Page(imageName: "notification", headerText: "Did you know?", bodyText: "Tooth decay is caused by bacteria that stick to tooth surfaces and produce acids after digesting sugars from the food you eat?"),
        Page(imageName: "notification", headerText: "Swipe to eliminate the bacteria and protect the teeth from tooth decay!", bodyText: "")
        ]
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("PREV", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        return button
    }()
    
    @objc private func handlePrev() {
        let nextIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleNext() {
        print("\(pageControl.currentPage) - \(pageControl.numberOfPages)")
        if (pageControl.currentPage == pageControl.numberOfPages - 1) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "GameViewController")
            self.present(controller, animated: true, completion: nil)
        }
        let nextIndex = min(pageControl.currentPage + 1, pages.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.currentPageIndicatorTintColor = .red
        pc.pageIndicatorTintColor = UIColor(red: 249/255, green: 207/255, blue: 224/255, alpha: 1)
        return pc
    }()
    
    fileprivate func setupBottomControls() {
        let bottomControlsStackView = UIStackView(arrangedSubviews: [previousButton, pageControl, nextButton])
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.distribution = .fillEqually
        
        view.addSubview(bottomControlsStackView)
        
        NSLayoutConstraint.activate([
            bottomControlsStackView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomControlsStackView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomControlsStackView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomControlsStackView.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let x = targetContentOffset.pointee.x
        
        pageControl.currentPage = Int(x / view.frame.width)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBottomControls()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(PageCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.isPagingEnabled = true
    }
}
