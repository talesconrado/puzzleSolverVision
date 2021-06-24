//
//  PieceView.swift
//  Eight Puzzle Solver
//
//  Created by Tales Conrado on 21/06/21.
//

import UIKit

class PieceView: UICollectionViewCell {
    var value: String?

    let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)

        return label
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        value = nil
        valueLabel.text = ""
    }

    func setupView(value: String?) {
        self.value = value
        layer.borderWidth = 1
        layer.borderColor = UIColor.red.cgColor

        value == nil ? configureEmptyView() : configureValueView()
    }

    private func configureValueView() {
        backgroundColor = .white

        valueLabel.text = value
        contentView.addSubview(valueLabel)

        NSLayoutConstraint.activate([
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            valueLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }

    private func configureEmptyView() {
        backgroundColor = .lightGray
    }
}
