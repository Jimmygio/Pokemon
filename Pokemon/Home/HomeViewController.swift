//
//  HomeViewController.swift
//  Pokemon
//
//  Created by Chang Chin-Ming on 2024/3/5.
//

import UIKit

class HomeViewController: UIViewController {

    private var viewModel: HomeViewModelProtocol = HomeViewModel()
    
    @IBOutlet weak var navListButton: UIButton!
    @IBOutlet weak var navOwnedButton: UIButton!
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        listCollectionView.accessibilityIdentifier = AccessibilityId.listCollectionView.rawValue
        setupViewModel()
        changeCollectionViewLayout()
    }
    
    private func setupViewModel() {
        viewModel.updateUIClosure = { [weak self] in
            guard let tSelf = self else { return }
            tSelf.listCollectionView.reloadData()
        }
        viewModel.lockOwnedButtonClosure = { [weak self] isLock in
            guard let tSelf = self else { return }
            tSelf.navOwnedButton.isUserInteractionEnabled = !isLock
        }
        viewModel.loadPokemonList()
    }
    
    private enum CollectionViewLayoutType {
        case list
        case grid
        
        func getSize() -> CGSize {
            let screenWidth = UIScreen.main.bounds.width
            switch self {
            case .list:
                return CGSizeMake(screenWidth, 105)
                
            case .grid:
                return CGSizeMake(screenWidth/2-5, 225)
            }
        }
    }
    private var collectionViewLayoutType: CollectionViewLayoutType = .list
    
    private func changeCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        layout.minimumLineSpacing = 0
        layout.itemSize = collectionViewLayoutType.getSize()
        layout.headerReferenceSize = .zero
        layout.footerReferenceSize = .zero
        listCollectionView.setCollectionViewLayout(layout, animated: false) { [weak self] _ in
            guard let tSelf = self else { return }
            tSelf.listCollectionView.reloadData()
        }
    }

    // MARK: - Click button
    @IBAction func clieckNavListButton(_ sender: Any) {
        switch collectionViewLayoutType {
        case .list:
            collectionViewLayoutType = .grid
            navListButton.setTitle("Show list", for: .normal)
            
        case .grid:
            collectionViewLayoutType = .list
            navListButton.setTitle("Show grid", for: .normal)
        }
        changeCollectionViewLayout()
    }

    @IBAction func clieckNavOwnedButton(_ sender: Any) {
        switch viewModel.changeOwnedMode() {
        case .disable:
            navOwnedButton.setTitle("Show owned", for: .normal)
            
        case .enable:
            navOwnedButton.setTitle("Show all", for: .normal)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.showedDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionViewLayoutType {
        case .list:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionViewCell",
                                                             for: indexPath) as? ListCollectionViewCell {
                let row = indexPath.row
                cell.updateUI(data: viewModel.showedDatas[row])
                viewModel.checkIfNeedloadNextPage(row: row)
                return cell
            }

        case .grid:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCollectionViewCell",
                                                             for: indexPath) as? GridCollectionViewCell {
                let row = indexPath.row
                cell.updateUI(data: viewModel.showedDatas[row])
                viewModel.checkIfNeedloadNextPage(row: row)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        Task { @MainActor in
            if  let cell = collectionView.cellForItem(at: indexPath) as? ListCollectionViewCell,
                let detailData = await cell.viewModel.loadDetailData(data: viewModel.showedDatas[row]),
                let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
                vc.viewModel.detailData = detailData
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
