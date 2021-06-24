//
//  PuzzleView.swift
//  Eight Puzzle Solver
//
//  Created by Tales Conrado on 21/06/21.
//

import UIKit

class PuzzleView: UIView {
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(PieceView.self, forCellWithReuseIdentifier: PieceView.description())

        return collection
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setDelegates(delegate: UICollectionViewDelegate & UICollectionViewDataSource) {
        collectionView.delegate = delegate
        collectionView.dataSource = delegate
    }

    private func configureView() {
        backgroundColor = .white
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: centerYAnchor),
            collectionView.widthAnchor.constraint(equalToConstant: 240),
            collectionView.heightAnchor.constraint(equalToConstant: 240)
        ])
    }

    func setupBoard() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
