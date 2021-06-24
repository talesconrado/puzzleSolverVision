//
//  MainView.swift
//  Eight Puzzle Solver
//
//

import UIKit

class MainView: UIView {

    var board: [[String?]] = [] {
        didSet {
            DispatchQueue.main.async {
                self.emptyLabel.isHidden = !self.board.isEmpty
            }
        }
    }

    let emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Faça o scan do estado atual do jogo."
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22)
        label.textColor = .white
        label.textAlignment = .center

        return label
    }()

    let scanButton: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Scan", for: .normal)
        bt.setTitleColor(.white, for: .normal)

        return bt
    }()

    let calculateButton: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Calcular próxima jogada", for: .normal)
        bt.setTitleColor(.white, for: .normal)

        return bt
    }()

    let puzzleView: PuzzleView = {
        let puzzle = PuzzleView()
        puzzle.translatesAutoresizingMaskIntoConstraints = false

        return puzzle
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configurePuzzleView()
        configureButton()
        configureEmptyLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupBoard() {
        puzzleView.setupBoard()
    }

    func setDelegates(delegate: UICollectionViewDelegate & UICollectionViewDataSource) {
        puzzleView.setDelegates(delegate: delegate)
    }

    private func configurePuzzleView() {
        addSubview(puzzleView)
        puzzleView.backgroundColor = .clear

        NSLayoutConstraint.activate([
            puzzleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            puzzleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            puzzleView.heightAnchor.constraint(equalToConstant: 240),
            puzzleView.widthAnchor.constraint(equalToConstant: 240)
        ])
    }

    private func configureButton() {
        addSubview(scanButton)
        addSubview(calculateButton)
        NSLayoutConstraint.activate([
            scanButton.topAnchor.constraint(equalTo: puzzleView.bottomAnchor, constant: 20),
            scanButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            calculateButton.topAnchor.constraint(equalTo: scanButton.bottomAnchor, constant: 12),
            calculateButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    private func configureEmptyLabel() {
        addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            emptyLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 50),
            emptyLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -50),
            emptyLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

}
