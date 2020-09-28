//
//  VideoViewerViewController.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/15/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit
import VersaPlayer
import AVFoundation

class VideoViewerViewController: UIViewController, ViewControllerInterface {
    
    @IBOutlet weak var playerView: VersaPlayerView!
    @IBOutlet weak var controls: VersaPlayerControls!
    
    lazy var viewModel: VideoViewerViewModel = {
        return VideoViewerViewModel()
    }()
    
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var bottomNavigationView: BottomNavigationView!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var playImageView: UIImageView!
    
    lazy var headerViewModel: HeaderViewModel =  {
        return HeaderViewModel(nameLabel: "\(UserManager().user?.storeName ?? "")", displayImage: UIImage(data: UserManager().user?.displayImage ?? Data()) ?? UIImage(named: "profileplaceholder")!)
    }()
    
    lazy var bottomNavigationViewModel: BottomNavigationViewModel =  {
        return BottomNavigationViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        playerView.layer.backgroundColor = UIColor.black.cgColor
        playerView.use(controls: controls)
        
        viewModel.updatesContentHeader = { text in
            self.screenTitleLabel.text = text
        }
    
        viewModel.start { url in
            
            let item = VersaPlayerItem(asset: AVAsset(url: self.getDocumentsDirectory().appendingPathComponent(url)))

            self.playerView.player.automaticallyWaitsToMinimizeStalling = false
            self.playerView.set(item: item)
            self.playerView.use(controls: self.controls)
            
            self.controls.playPauseButton?.isUserInteractionEnabled = false
            
            self.thumbnailImageView.image = self.imagePreview(from: self.getDocumentsDirectory().appendingPathComponent(url), in: 60.0)
        }
        // Do any additional setup after loading the view.
        
        headerView.setup(viewModel: headerViewModel)
        bottomNavigationView.setup(viewModel: bottomNavigationViewModel)
        
        playerView.addTapGesture(target: self, action: #selector(playPause))
        
        initViewModel()
        
       // playerView.image
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.playerView.pause()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       // DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Change `2.0` to the desired number of seconds.
        //self.controls.playPauseButton?.set(active: false)
        
       // }
    }
    
    func imagePreview(from moviePath: URL, in seconds: Double) -> UIImage? {
        let timestamp = CMTime(seconds: seconds, preferredTimescale: 30)
        let asset = AVURLAsset(url: moviePath)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true

        guard let imageRef = try? generator.copyCGImage(at: timestamp, actualTime: nil) else {
            return nil
        }
        return UIImage(cgImage: imageRef)
    }
    
    func generateThumbnail(asset: AVAsset) -> UIImage? {
        do {
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            // Select the right one based on which version you are using
            // Swift 4.2
            let cgImage = try imageGenerator.copyCGImage(at: .init(seconds: 1, preferredTimescale: 30),
                                                         actualTime: nil)
            // Swift 4.0

            return UIImage(cgImage: cgImage)
        } catch {
            print(error.localizedDescription)

            return nil
        }
    }
    
    @objc func playPause() {
        if self.playerView.isPlaying {
           // self.controls.playPauseButton?.set(active: false)
            self.playerView.pause()
        }else {
            //self.controls.playPauseButton?.set(active: true)
            self.playerView.play()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.thumbnailImageView.isHidden = true
                self.playImageView.isHidden = true
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.playerView.pause()
    }
    
    func initViewModel() {
        bottomNavigationViewModel.backButtonPressed = {
            self.navigationController?.popViewController(animated: true)
        }
        
        bottomNavigationViewModel.nextButtonPressed = {
             self.playerView.pause()
            self.presentPopup(okButtonHandler: {
                self.navigationController?.popToRootViewController(animated: true)
            })
        }
        
        
        headerViewModel.logoButtonPressed = {
             self.playerView.pause()
            self.presentPopup(okButtonHandler: {
                self.navigationController?.popToRootViewController(animated: true)
            })
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
