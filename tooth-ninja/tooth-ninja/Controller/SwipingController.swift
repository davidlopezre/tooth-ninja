//
//  SwipingController.swift
//  autolayout_lbta

import UIKit
import AVFoundation

extension UIColor
{
    static var mainPink = UIColor(red: 232/255, green: 68/255, blue: 133/255, alpha: 1)
}

let niceBlue = UIColor(red: 24/255, green: 67/255, blue: 140/255, alpha: 1)
let niceRed = UIColor(red: 252/255, green: 117/255, blue: 118/255, alpha: 1)

class SwipingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var audioPlayer = AVAudioPlayer()
    
    let pages =
        [
        Page(imageName: "brush", headerText: "Did you know?", bodyText: "Children should only start using toothpaste after 18 months of age? Before 6 years of age, children should use a pea-sized amount of children’s toothpaste, which has a lower concentration of fluoride (500-600 ppm) compared to adult toothpaste (>1000 ppm)"),
        Page(imageName: "notification", headerText: "Did you know?", bodyText: "Snacking in between meals can increase your chances of tooth decay? Sugary foods eaten during meal times have a smaller negative impact on your teeth compared to when eaten in-between meal times."),
        Page(imageName: "notification", headerText: "Did you know?", bodyText: "Your toothbrush should be replaced when the bristles start to fray? This is usually around 3 months after you start using a new toothbrush (or toothbrush head)."),
        Page(imageName: "notification", headerText: "Did you know?", bodyText: "Tooth decay is caused by bacteria that stick to tooth surfaces and produce acids after digesting sugars from the food you eat?"),
        Page(imageName: "notification", headerText: "Did you know?", bodyText: """
            You should remove the baby bottle from the child when feeding is finished.
            Leaving your child to sleep with a bottle of baby formula (which contains sugar), or
            anything else containing sugar, can greatly increase their risk of tooth decay.
 """),
        Page(imageName: "notification", headerText: "Did you know?", bodyText: "Some parents sweeten pacifiers/dummies (e.g. with honey) before giving it to their child. This increases the risk of tooth decay and should not be done."),
        Page(imageName: "notification", headerText: "Did you know?", bodyText: "It is recommended that you take your child to see the dentist when they reach 12 months of age."),
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
        button.setTitleColor(niceBlue, for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleNext() {
        let nextIndex = min(pageControl.currentPage + 1, pages.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.currentPageIndicatorTintColor = niceRed
        pc.pageIndicatorTintColor = niceBlue
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
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Off Limits", ofType: "wav")!))
            audioPlayer.prepareToPlay()
            audioPlayer.pause()
            print("Music Player Paused in SwipingController")
        }
        catch
        {
            print(error)
        }
//        if(audioPlayer.isPlaying)
//        {
//            audioPlayer.pause()
//            print("Music Player Paused in SwipingController")
//        }
        
        setupBottomControls()
               
        collectionView?.backgroundColor = .white
        collectionView?.register(PageCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.isPagingEnabled = true
        
    }
}
