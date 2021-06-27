//
//  DetailViewDataSource.swift
//  MoviesDemo
//
//  Created by RYAN GREENBURG on 6/11/21.
//

import UIKit

class DetailViewDataSource: UICollectionViewDiffableDataSource<DetailViewModel.Section,
                                                               DetailViewModel.CellType> {
    
    var sections: [DetailViewModel.Section] = []
    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView) { collectionView, indexPath, cellType -> UICollectionViewCell? in
            switch cellType {
            case .hero(let movie):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroDetailCollectionViewCell.reuseID, for: indexPath) as? HeroDetailCollectionViewCell
                
                cell?.configure(with: movie)
                
                return cell
                
            case .overview(let text):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionViewCell.reuseID, for: indexPath) as? TextCollectionViewCell
                
                cell?.configure(with: text)
                return cell
            case .cast(let castMember):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastMemberCollectionViewCell.reuseID, for: indexPath) as? CastMemberCollectionViewCell
                
                cell?.configure(with: castMember)
                return cell
            case .crew(let crewMember):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastMemberCollectionViewCell.reuseID, for: indexPath) as? CastMemberCollectionViewCell
                
                cell?.configure(crewMember: crewMember)
                return cell

            case .recommendation(let movie):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieOverviewCollectionViewCell.reuseID, for: indexPath) as? MovieOverviewCollectionViewCell
                cell?.configure(with: movie)
                return cell
            }
        }
        
        supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            let section = self.sections[indexPath.section]
            switch kind {
            case HeaderCollectionReusableView.kind:
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.reuseID, for: indexPath) as? HeaderCollectionReusableView
                view?.titleLabel.text = section.sectionTitle
                return view
            default:
                return nil
            }
        }
        
        collectionView.collectionViewLayout = collectionViewLayout
        registerCells(for: collectionView)
    }
    
    func updateData(with sections: [DetailViewModel.Section]) {
        self.sections = sections
        var snapshot = NSDiffableDataSourceSnapshot<DetailViewModel.Section, DetailViewModel.CellType>()
        snapshot.appendSections(sections)
        sections.forEach { snapshot.appendItems($0.items, toSection: $0) }
        apply(snapshot)
    }
    
    private func registerCells(for collectionView: UICollectionView) {
        collectionView.register(HeroDetailCollectionViewCell.nib, forCellWithReuseIdentifier: HeroDetailCollectionViewCell.reuseID)
        collectionView.register(TextCollectionViewCell.nib, forCellWithReuseIdentifier: TextCollectionViewCell.reuseID)
        collectionView.register(CastMemberCollectionViewCell.nib, forCellWithReuseIdentifier: CastMemberCollectionViewCell.reuseID)
        collectionView.register(MovieOverviewCollectionViewCell.nib, forCellWithReuseIdentifier: MovieOverviewCollectionViewCell.reuseID)
        collectionView.register(HeaderCollectionReusableView.nib, forSupplementaryViewOfKind: HeaderCollectionReusableView.kind, withReuseIdentifier: HeaderCollectionReusableView.reuseID)
    }
    
    private var collectionViewLayout: UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment -> NSCollectionLayoutSection? in
            let section = self.sections[sectionIndex]
            
            let sectionInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
            
            switch section.items.first {
            case .hero:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.4))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                return section
                
            case .overview:
                let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: size, elementKind: HeaderCollectionReusableView.kind, alignment: .top)
                let item = NSCollectionLayoutItem(layoutSize: size)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [header]
                section.contentInsets = sectionInsets
                
                return section
            case .cast, .crew:
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: HeaderCollectionReusableView.kind, alignment: .top)
                let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: size)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalHeight(0.33))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3)
                group.interItemSpacing = .fixed(12)
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 12
                section.contentInsets = sectionInsets
                section.boundarySupplementaryItems = [header]
                return section
            case .recommendation:
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
                
                
                return section
            default:
                return nil
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 24
        layout.configuration = config
        layout.register(BackgroundCollectionReusableView.nib, forDecorationViewOfKind: BackgroundCollectionReusableView.kind)
        
        return layout
    }
}
