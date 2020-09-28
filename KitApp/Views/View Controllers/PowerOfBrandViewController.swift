//
//  PowerOfBrandViewController.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 8/12/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit
import AVFoundation

enum PobState {
    case suggestedSellingPricePressed
    case mataasNaPresyoPressed
    case nonPressed
}

enum RackState {
    case rackItemsFull
    case rackItemsEmpty
}

enum BarAnimationState {
    case none
    case half
    case full
    case halfToFull
    case fullToHalf
}

class PowerOfBrandViewController: UIViewController, ViewControllerInterface, AudioPlayerController {
    var player: AVAudioPlayer?
    

    @IBOutlet weak var barImageView: UIImageView!
    @IBOutlet weak var headerView: HeaderView!
    
    @IBOutlet weak var moveItemsButton: UIButton!
    
    @IBOutlet weak var boxWhiteImageView: UIImageView!
    @IBOutlet weak var rackImageView: UIImageView!
    
    @IBOutlet weak var bottomNavigationView: BottomNavigationView!
    
    @IBOutlet weak var sellingPriceButton: UIButton!
    @IBOutlet weak var mataasPresyoButton: UIButton!
    
    
    var barAnimationState: BarAnimationState = .none {
        didSet {
            barImageView.stopAnimating()
            switch barAnimationState {
            case .full:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.animateToFull()
                    self.playAudioFile(resource: "pob-sound-bar-increase")
                }
            case .halfToFull:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.animateHalfToFull()
                    self.playAudioFile(resource: "pob-sound-bar-increase")
                }
            case .half:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.animateToHalf()
                    self.playAudioFile(resource: "pob-sound-bar-increase")
                }
            case .fullToHalf:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.animateFullToHalf()
                    self.playAudioFile(resource: "pob-sound-descending")
                }
            default:
                return
            }
        }
    }
    
    var pobState: PobState = .nonPressed {
        didSet {
            switch pobState {
            case .suggestedSellingPricePressed:
                sellingPriceButton.setImage(UIImage(named: "button-suggested-clicked"), for: .normal)
                mataasPresyoButton.setImage(UIImage(named: "button-mataaspresyo-disabled"), for: .normal)
            case .mataasNaPresyoPressed:
                sellingPriceButton.setImage(UIImage(named: "button-suggested-disabled"), for: .normal)
                mataasPresyoButton.setImage(UIImage(named: "button-mataaspresyo-clicked"), for: .normal)
            case .nonPressed:
                sellingPriceButton.setImage(UIImage(named: "button-suggested-unclick"), for: .normal)
                mataasPresyoButton.setImage(UIImage(named: "button-mataaspresyo-unclick"), for: .normal)
            }
        }
    }
    
    var rackState: RackState  = .rackItemsEmpty {
        didSet {
            switch rackState {
            case .rackItemsEmpty:
                pobState = .nonPressed
                self.playAudioFile(resource: "pob-sound-descending")
                sellingPriceButton.isUserInteractionEnabled = false
                mataasPresyoButton.isUserInteractionEnabled = false
                boxWhiteImageView.image = UIImage(named: "icon-box-white-products")
                rackImageView.image = UIImage(named: "icon-rack-noproducts")
                moveItemsButton.setImage(UIImage(named: "button-green"), for: .normal)
                
                barImageView.image = UIImage(named: "bar")
            case .rackItemsFull:
                sellingPriceButton.isUserInteractionEnabled = true
                mataasPresyoButton.isUserInteractionEnabled = true
                
                barImageView.image = UIImage(named: "bar-0")
                
                boxWhiteImageView.image = UIImage(named: "icon-box-white-noproducts")
                rackImageView.image = UIImage(named: "icon-rack-products")
                moveItemsButton.setImage(UIImage(named: "button-red"), for: .normal)
                
                
                sellingPriceButton.setImage(UIImage(named: "button-suggested-disabled"), for: .normal)
                mataasPresyoButton.setImage(UIImage(named: "button-mataaspresyo-disabled"), for: .normal)
            }
        }
    }
    
    lazy var headerViewModel: HeaderViewModel =  {
        return HeaderViewModel(nameLabel: "\(UserManager().user?.storeName ?? "")", displayImage: UIImage(data: UserManager().user?.displayImage ?? Data()) ?? UIImage(named: "profileplaceholder")!)
    }()
    
    lazy var bottomNavigationViewModel: BottomNavigationViewModel =  {
        return BottomNavigationViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
        headerView.setup(viewModel: headerViewModel)
        bottomNavigationView.setup(viewModel: bottomNavigationViewModel)
        
        barImageView.animationDuration = 1.0
        barImageView.animationRepeatCount = 1
       // initAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //initAnimation()
    }
    
    func animateHalfToFull() {
        barImageView.image = UIImage(named: "bar-10")
        barImageView.animationImages = animatedImagesFromHalfToFull(for: "bar")
        barImageView.startAnimating()
    }
    
    func animateToFull() {
        barImageView.image = UIImage(named: "bar-10")
        barImageView.animationImages = animatedImagesFull(for: "bar")
        barImageView.startAnimating()
    }
    
    func animateToHalf() {
        barImageView.image = UIImage(named: "bar-5")
        barImageView.animationImages = animatedImagesToHalfFull(for: "bar")
        barImageView.startAnimating()
    }
    
    func animateFullToHalf() {
        barImageView.image = UIImage(named: "bar-5")
        barImageView.animationImages = animatedImagesFromFullToHalf(for: "bar")
        barImageView.startAnimating()
    }
    
    func animatedImagesFull(for name: String) -> [UIImage] {
        
        var i = 0
        var images = [UIImage]()
        
        while let image = UIImage(named: "\(name)-\(i)") {
            images.append(image)
            i += 1
        }
        return images
    }
    
    func animatedImagesFromHalfToFull(for name: String) -> [UIImage] {
        
        var i = 5
        var images = [UIImage]()
        
        while let image = UIImage(named: "\(name)-\(i)") {
            images.append(image)
            i += 1
        }
        return images
    }
    
    func animatedImagesFromFullToHalf(for name: String) -> [UIImage] {
        
        var i = 10
        var images = [UIImage]()
        
        while i > 4, let image = UIImage(named: "\(name)-\(i)") {
            images.append(image)
            i -= 1
        }
        return images
    }
    
    func animatedImagesToHalfFull(for name: String) -> [UIImage] {
        
        var i = 0
        var images = [UIImage]()
        
        while let image = UIImage(named: "\(name)-\(i)"), i <= 5 {
            images.append(image)
            i += 1
        }
        return images
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        

        if let vc = segue.destination as? PriceDisplayViewController {
            vc.viewModel.userType = UserManager().user?.userType == "retailer" ? .retailer : .wholeSaler
           // vc.totalPmftcProfit = viewModel.totalProfitPmftc
           // vc.totalOtherBrandsProfit = viewModel.totalProfitOthers
        }
    }
    
    
    func setupView() {
        bottomNavigationViewModel.backButtonPressed = {
                 self.navigationController?.popViewController(animated: true)
            
            
           
        }
        
        bottomNavigationViewModel.nextButtonPressed = {

                 self.performSegue(withIdentifier: "PobToPriceDisplaySegue", sender: nil)
        
        }
        
        
        headerViewModel.logoButtonPressed = {
            self.presentPopup(okButtonHandler: {
                self.navigationController?.popToRootViewController(animated: true)
            })
        }
        
        sellingPriceButton.isUserInteractionEnabled = false
        mataasPresyoButton.isUserInteractionEnabled = false
    }
    
    @IBAction func suggestedSellingPricePressed(_ sender: UIButton) {
        if pobState == .nonPressed || pobState == .suggestedSellingPricePressed {
            barAnimationState = .full
        }else if pobState == .mataasNaPresyoPressed {
            barAnimationState = .halfToFull
        }
        
        pobState = .suggestedSellingPricePressed
    }
    
    @IBAction func mataasNaPresyoPressed(_ sender: UIButton) {
        
        
        if pobState == .nonPressed || pobState == .mataasNaPresyoPressed{
            barAnimationState = .half
        }else if pobState == .suggestedSellingPricePressed {
            barAnimationState = .fullToHalf
        }
        
        pobState = .mataasNaPresyoPressed
    }
    
    
    @IBAction func moveItemsPressed(_ sender: UIButton) {
        rackState = rackState == .rackItemsEmpty ? .rackItemsFull : .rackItemsEmpty
    }
}
