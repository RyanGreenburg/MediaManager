//
//  MoviesHomeDataSource.swift
//  MoviesDemo
//
//  Created by RYAN GREENBURG on 6/9/21.
//

import UIKit

class MoviesHomeDataSource: UICollectionViewDiffableDataSource<MoviesHomeViewModel.Section,
                                                               MoviesHomeViewModel.WrappedMovie> {
    
    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieOverviewCollectionViewCell.reuseID, for: indexPath) as? MovieOverviewCollectionViewCell
            
            cell?.configure(with: item.movie)
            cell?.backgroundColor = .secondarySystemBackground
            return cell
        }
        
        supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            if kind == HeaderCollectionReusableView.kind {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.reuseID, for: indexPath) as? HeaderCollectionReusableView
                view?.setTitle(self.snapshot().sectionIdentifiers[indexPath.section].title)
                return view
            }
            return nil
        }
        
        collectionView.collectionViewLayout = collectionViewLayout
        registerCells(for: collectionView)
    }
    
    func setData(_ sections: [MoviesHomeViewModel.Section]) {
        var snapshot = NSDiffableDataSourceSnapshot<MoviesHomeViewModel.Section,
                                                    MoviesHomeViewModel.WrappedMovie>()
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
        apply(snapshot)
    }
    
    private var collectionViewLayout: UICollectionViewLayout {
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: HeaderCollectionReusableView.kind, alignment: .top)
        
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: size)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.45), heightDimension: .fractionalHeight(0.55))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundCollectionReusableView.kind)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [headerItem]
        section.decorationItems = [backgroundItem]
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        section.interGroupSpacing = 12
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 12
        
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: config)
        layout.register(BackgroundCollectionReusableView.nib, forDecorationViewOfKind: BackgroundCollectionReusableView.kind)
        
        return layout
    }
    
    private func registerCells(for collectionView: UICollectionView) {
        collectionView.register(MovieOverviewCollectionViewCell.nib, forCellWithReuseIdentifier: MovieOverviewCollectionViewCell.reuseID)
        collectionView.register(HeaderCollectionReusableView.nib, forSupplementaryViewOfKind: HeaderCollectionReusableView.kind, withReuseIdentifier: HeaderCollectionReusableView.reuseID)
    }
}
