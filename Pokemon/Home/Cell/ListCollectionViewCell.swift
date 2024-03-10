//
//  listCollectionViewCell.swift
//  Pokemon
//
//  Created by Chang Chin-Ming on 2024/3/5.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var spriteImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    let viewModel: CollectionViewCellViewModePprotocol = CollectionViewCellViewModel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset or clean up cell content for reuse
        spriteImageView.image = nil
        nameLabel.text = ""
        idLabel.text = ""
        typesLabel.text = ""
    }

    @MainActor
    func updateUI(data: NameAndUrlData) {
        self.accessibilityIdentifier = AccessibilityId.loadListCollectionViewCell(name: data.name)
        
        Task {
            guard let detailData = await viewModel.loadDetailData(data: data) else { return }
            
            spriteImageView.sd_setImage(with: detailData.frontImageURL())
            nameLabel.text = detailData.nameMessage()
            idLabel.text = detailData.idMessage()
            typesLabel.text = detailData.typesMessage()
        }
    }
}
