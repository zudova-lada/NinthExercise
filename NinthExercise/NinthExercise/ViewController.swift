//
//  ViewController.swift
//  NinthExercise
//
//  Created by Лада Зудова on 26.03.2023.
//

import UIKit

class ViewController: UIViewController {
    private lazy var layout: CustomLayout = {
        let layout = CustomLayout.init()
        layout.scrollDirection = .horizontal
        layout.itemSize.width = 200
        layout.itemSize.height = 300
        layout.sectionInset = UIEdgeInsets(top: 100, left: 0, bottom: 100, right: 0)
        return layout
    }()
    
    private lazy var collection: UICollectionView = {
        let view = UICollectionView(frame:.zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemTeal
        view.dataSource = self
        view.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseID)
        view.contentInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = "CollectionView"
        view.backgroundColor = .systemMint
        view.addSubview(collection)
        
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: view.topAnchor),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 57
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionViewCell.reuseID,
            for: indexPath
        ) as? CollectionViewCell else {
            fatalError("Wrong cell")
        }
        cell.backgroundColor = .green
        return cell
    }
}

final class CollectionViewCell: UICollectionViewCell {
    static let reuseID = "CollectionViewCell"
}

final class HeaderViewCell: UICollectionReusableView {
    static let reuseID = "HeaderViewCell"
    
    private lazy var title: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "Collection View"
        return view
    }()
    
    func configure(){
        backgroundColor = .systemBrown
        addSubview(title)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.frame = bounds
    }
}

final class CustomLayout: UICollectionViewFlowLayout {
    private var previouseOffset: CGFloat = 0
    private var currentPadge = 0
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collection = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }

        let itemCount = collection.numberOfItems(inSection: 0)

        if previouseOffset > collection.contentOffset.x && velocity.x < 0 {
            currentPadge = max(currentPadge - 2, 0)
        } else if previouseOffset < collection.contentOffset.x && velocity.x > 0 {
            currentPadge = min(currentPadge + 2, itemCount - 1)
        }

        let itemW = itemSize.width
        let sp = minimumLineSpacing
        let edge = collection.layoutMargins.left
        let offset = (itemW + sp) * CGFloat(currentPadge) - (edge + sp)
        previouseOffset = offset
        return CGPoint(x: offset, y: proposedContentOffset.y)
    }
}
