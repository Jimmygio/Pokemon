//
//  DetailViewController.swift
//  Pokemon
//
//  Created by Chang Chin-Ming on 2024/3/7.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var maleImageView: UIImageView!
    @IBOutlet weak var maleUILabel: UILabel!
    @IBOutlet weak var femaleImageView: UIImageView!
    @IBOutlet weak var femaleUILabel: UILabel!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    @IBOutlet weak var baseStatsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var evolution1Button: CustomButton!
    @IBOutlet weak var rightArrowImageView: UIImageView!
    @IBOutlet weak var evolution2Button: CustomButton!
    @IBOutlet weak var rightArrow2ImageView: UIImageView!
    @IBOutlet weak var evolution3Button: CustomButton!
    
    @IBOutlet weak var ownedButton: UIButton!
    
    var viewModel: DetailViewModelProtocol = DetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ownedButton.addCorner(true, radius: 22, width: 1, color: .red)
        ownedButton.accessibilityIdentifier = AccessibilityId.detailViewController_OwnedButton.rawValue
        
        if let detailData = viewModel.detailData {
            maleImageView.sd_setImage(with: detailData.frontImageURL())
            if let femaleImageURL = detailData.frontFemaleImageURL() {
                maleUILabel.text = "Male"
                femaleUILabel.isHidden = false
                femaleImageView.sd_setImage(with: femaleImageURL)
            } else {
                maleUILabel.text = "Male and female look the same"
            }
            nameLabel.text = detailData.nameMessage()
            idLabel.text = detailData.idMessage()
            typesLabel.text = detailData.typesMessage()
            baseStatsLabel.text = detailData.baseStatsMessage()
            
            updateDescriptionAndEvolutionUI()
            updateOwnedButtonUI()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func updateDescriptionAndEvolutionUI() {
        viewModel.loadDescriptionAndEvolution { [weak self] flavorText in
            guard let tSelf = self else { return }
            DispatchQueue.main.async {
                tSelf.descriptionLabel.text = flavorText
            }
        } evolutionCompletion: { @MainActor [weak self] detailDatas in
            guard let tSelf = self else { return }
            DispatchQueue.main.async {
                for i in 0..<detailDatas.count {
                    let detailData = detailDatas[i]
                    if i == 0 {
                        tSelf.evolution1Button.sd_setImage(with: detailData.frontImageURL(), for: .normal)
                        tSelf.evolution1Button.pressedBtnCallback = {
                            tSelf.goToNextDetailViewController(detailData: detailData)
                        }
                    } else if i == 1 {
                        tSelf.rightArrowImageView.isHidden = false
                        tSelf.evolution2Button.sd_setImage(with: detailData.frontImageURL(), for: .normal)
                        tSelf.evolution2Button.pressedBtnCallback = {
                            tSelf.goToNextDetailViewController(detailData: detailData)
                        }
                    } else if i == 2 {
                        tSelf.rightArrow2ImageView.isHidden = false
                        tSelf.evolution3Button.sd_setImage(with: detailData.frontImageURL(), for: .normal)
                        tSelf.evolution3Button.pressedBtnCallback = {
                            tSelf.goToNextDetailViewController(detailData: detailData)
                        }
                    }
                }
            }
        }
    }

    private func goToNextDetailViewController(detailData: DetailData) {
        if viewModel.detailData?.id == detailData.id {
            showAlert(title: "No need change page",
                      itemsArray: [.init(actionTitle: "OK",
                                         actionStyle: .default)],
                      viewController: self)
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController{
            vc.viewModel.detailData = detailData
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func updateOwnedButtonUI() {
        Task {
            if await viewModel.isOwned() {
                ownedButton.setTitle(OwnedButtonTitle.owned.rawValue, for: .normal)
                ownedButton.setTitleColor(.green, for: .normal)
                ownedButton.layer.borderColor = UIColor.green.cgColor
            } else {
                ownedButton.setTitle(OwnedButtonTitle.Unowned.rawValue, for: .normal)
                ownedButton.setTitleColor(.red, for: .normal)
                ownedButton.layer.borderColor = UIColor.red.cgColor
            }
        }
    }

    @IBAction func clickedOwnedButton(_ sender: Any) {
        Task {
            await viewModel.changeOwnedStatus()
            updateOwnedButtonUI()
        }
    }
}
