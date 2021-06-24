//
//  ViewController.swift
//  Eight Puzzle Solver
//
//

import UIKit
import Vision
import VisionKit

class MainViewController: UIViewController {

    let contentView = MainView()

    var orderedNumbers = [String?]()
    var board: [[String?]] = []

    override func loadView() {
        view = contentView
        contentView.scanButton.addTarget(self, action: #selector(presentDocumentCamera), for: .touchUpInside)
        contentView.setDelegates(delegate: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    }

    func doRequest(img: UIImage) {
        self.orderedNumbers = []
        self.board = []
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                fatalError("Received invalid observations")
            }

            for observation in observations {
                guard let bestCandidate = observation.topCandidates(1).first else {
                    print("No candidate")
                    continue
                }

                var row: [String?] = bestCandidate.string.compactMap{ $0.wholeNumberValue }.map({ "\($0)" })

                if row.count < 3 {
                    row.append(nil)
                }

                self.orderedNumbers.append(contentsOf: row)

                print("Found this candidate: \(bestCandidate.string)")
            }
            
            self.correctBoard()
        }

        let requests = [request]
        request.recognitionLevel = .accurate

        DispatchQueue.global(qos: .userInitiated).async {
            guard let img = img.cgImage else {
                fatalError("Missing image to scan")
            }

            let handler = VNImageRequestHandler(cgImage: img, options: [:])
            try? handler.perform(requests)
        }
    }

    private func correctBoard() {
        let neededNumbers = ["1", "2", "3", "4", "5", "6", "7", "8"]
        for number in neededNumbers {
            if !orderedNumbers.contains(number) {
                orderedNumbers.append(number)
            }
        }

        while orderedNumbers.count > 9 {
            orderedNumbers.removeLast()
        }

        while orderedNumbers.count < 9 {
            orderedNumbers.append(nil)
        }

        if orderedNumbers.count == 9 {
            self.board = [Array(orderedNumbers[0...2]), Array(orderedNumbers[3...5]), Array(orderedNumbers[6...8])]
        }

        self.contentView.board = self.board
        self.contentView.setupBoard()
    }

    private func showAlert(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Corrigir valor", message: "Digite o valor correto ou 0 se for vazio.", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.keyboardType = .numberPad
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            self.board[indexPath.section][indexPath.row] = textField?.text == "0" ? nil : textField?.text
            self.contentView.setupBoard()
        }))

        present(alert, animated: true, completion: nil)
    }
}

extension MainViewController: VNDocumentCameraViewControllerDelegate {
    @objc func presentDocumentCamera() {
        let vc = VNDocumentCameraViewController()
        vc.delegate = self
        present(vc, animated: true)
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        print("Found \(scan.pageCount)")

        for i in 0 ..< scan.pageCount {
            let img = scan.imageOfPage(at: i)
            doRequest(img: img)
        }
        dismiss(animated: true)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        board.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        board[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PieceView.description(), for: indexPath) as? PieceView else {
            return PieceView()
        }

        let value = board[indexPath.section][indexPath.row]
        cell.setupView(value: value)
        print(value)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showAlert(indexPath: indexPath)
    }
}
