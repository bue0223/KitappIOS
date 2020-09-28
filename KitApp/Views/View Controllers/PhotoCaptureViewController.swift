//
//  PhotoCaptureViewController.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/9/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit
import SVProgressHUD

class PhotoCaptureViewController: UIViewController, ViewControllerInterface {

    lazy var viewModel: PhotoCaptureViewModel = {
        return PhotoCaptureViewModel()
    }()
    
    var imagePicker: ImagePicker!

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var ownerType: UILabel!
    
    @IBOutlet weak var userType: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initBinding()
    }

    func initView() {
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(ButtonTableViewCell.self)
        tableView.register(TitleWithSubTitleTemplateTableViewCell.self)
        tableView.register(TextFieldTableViewCell.self)
        tableView.register(ImageTableViewCell.self)
        tableView.register(ProfileImageTableViewCell.self)
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        userType.text = UserManager().user?.categoryType ?? ""
        ownerType.text = UserManager().user?.userType == "retailer" ? "RT" : "WS"
    }

    func initBinding() {
        viewModel.sectionViewModels.addObserver(fireNow: false) { [weak self] (sectionViewModels) in
            self?.tableView.reloadData()
        }
        
        viewModel.captureButtonPressed = {
            self.imagePicker.present(from: self.tableView)
        }
        
        viewModel.proceed = {
                let items: [PriceProgramItemEntity] = (CoreDataManager().fetch(isPriceProgram: true) ?? []).filter { (priceProgramEntity) -> Bool in
                    
                    // NOTE: TO update
                     return priceProgramEntity.ownerType == "wholesaler"
    //                return priceProgramEntity.ownerType == UserManager().user?.userType
                }
                let item = items.first
                
                if item?.is_shown == 1 {
                    self.performSegue(withIdentifier: "PhotoCaptureToPsspSegue", sender: nil)
                }else {
                    if UserManager().user?.isVsmLuzonUser == true {
                        self.performSegue(withIdentifier: "PhotoCaptureToPriceDisplaySegue", sender: nil)
                    }else {
                        self.performSegue(withIdentifier: "PhotoCaptureToTradeProgramsSegue", sender: nil)
                    }
                }
        }
        
        
        viewModel.isLoading.addObserver(fireNow: false) { (isLoading) in
            if isLoading == true {
                self.view.isUserInteractionEnabled = false
                SVProgressHUD.show()
            }else {
                self.view.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
            }
        }

        viewModel.start()
    }
    
    @IBAction func goToHomeButtonPressed(_ sender: Any) {
        self.presentPopup(okButtonHandler: {
            self.navigationController?.popToRootViewController(animated: true)
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let vc = segue.destination as? InputViewController {
//            vc.viewModel.userType = UserManager().user?.userType == "retailer" ? .retailer : .wholeSaler
//            vc.viewModel.inputType = .offtake
//            //vc.bottomNavigationViewModel = bottomNavigationViewModel
//        }
//
//        if let vc = segue.destination as? PriceDisplayViewController {
//            vc.viewModel.userType = UserManager().user?.userType == "retailer" ? .retailer : .wholeSaler
//           // vc.totalPmftcProfit = viewModel.totalProfitPmftc
//           // vc.totalOtherBrandsProfit = viewModel.totalProfitOthers
//        }
        
        if let priceVc = segue.destination as? PriceDisplayViewController {
            priceVc.viewModel.userType = UserManager().user?.userType == "retailer" ? .retailer : .wholeSaler
        }
        if let vc = segue.destination as? PsspViewController {
            vc.viewModel.userType = UserManager().user?.userType == "retailer" ? .retailer : .wholeSaler
        }
    }
}

extension PhotoCaptureViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionViewModels.value.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionViewModel = viewModel.sectionViewModels.value[section]
        return sectionViewModel.rowViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionViewModel = viewModel.sectionViewModels.value[indexPath.section]
        let rowViewModel = sectionViewModel.rowViewModels[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellIdentifier(for: rowViewModel), for: indexPath)

        if let cell = cell as? CellConfigurable {
            cell.setup(viewModel: rowViewModel)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionViewModel = viewModel.sectionViewModels.value[indexPath.section]
        let rowViewModel = sectionViewModel.rowViewModels[indexPath.row]
    
        return CGFloat(rowViewModel.rowHeight)
    }
}

extension PhotoCaptureViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
       // self.imageView.image = image
        
        for rowViewModel in (viewModel.sectionViewModels.value.first?.rowViewModels ?? []) {
            if let imageViewModel = rowViewModel as? ImageCellViewModel, imageViewModel.imageType == .profile {
                if let image = image  {
                    imageViewModel.image?.value = image
                }
            }
        }
    }
}
