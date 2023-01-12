//
//  ListViewController.swift
//  ATMs
//
//  Created by Karina Kovaleva on 27.12.22.
//

import UIKit

protocol ListViewControllerDelegate: AnyObject {
    func selectAnnotation(_ id: String)
}

final class ListViewController: UIViewController {

    private lazy var viewModel = {
        ViewModel()
    }()

    private var dataSource: UICollectionViewDiffableDataSource<SectionViewModel, CellModel>?

    weak var delegate: ListViewControllerDelegate?

    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseId)
        collectionView.register(SectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeader.reuseId)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        collectionView.delegate = self
        initViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupCollectionView()
        setupDataSource()
        createSnapshot()
    }
    
    private func initViewModel() {
        // Get atms data
        self.viewModel.getInfoFromApi()
        // Reload CollectionView closure
        self.viewModel.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func setupCollectionView() {
        self.view.addSubview(self.collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionViewModel, CellModel>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, _ -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseId,
                                                              for: indexPath) as? CollectionViewCell
                let cellViewModel = self.viewModel.getCellViewModel(at: indexPath)
                cell?.cellViewModel = cellViewModel
                return cell }
        )
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeader.reuseId,
                for: indexPath
            ) as? SectionHeader else { return nil }
            guard let firstAtm = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
            guard let section = self?.dataSource?.snapshot().sectionIdentifier(
                containingItem: firstAtm) else { return nil }
            var city = section.city
            city.isEmpty ? city = "Нет информации" : nil
            sectionHeader.headerLabel.text = city
            return sectionHeader
        }
    }
    
    private func createSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionViewModel, CellModel>()
        snapshot.appendSections(self.viewModel.sectionViewModels)
        for section in self.viewModel.sectionViewModels {
            snapshot.appendItems(section.infoForModel, toSection: section)
        }
        dataSource?.apply(snapshot)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize:
                                            NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                                                   heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize:
                                                        NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                               heightDimension: .estimated(130)),
                                                       repeatingSubitem: item, count: 3)
        
        let spacing = CGFloat(4)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let header = createSectionHeader()
        header.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [header]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeader = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                         heightDimension: .estimated(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeader,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        return header
    }
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let viewController = navigationController?.viewControllers.first as? MainViewController else { return }
//        viewController.chooseMapViewController()
//        let atmId = viewModel.atmSectionViewModels[indexPath.section].atm[indexPath.row].id
//        delegate?.selectAnnotation(atmId)
    }
}
