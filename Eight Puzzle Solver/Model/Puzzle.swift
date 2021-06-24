//
//  Puzzle.swift
//  Eight Puzzle Solver
//
//

import Foundation

enum Direction {
    case up, down, left, right
}

struct AStarPuzzle {
    var heuristics: Int
    var state: [[[String]]]
}

class Puzzle {
    var state: [[String]] = []

    func availableMoves(state: [[String]]) -> [[[String]]] {
        var movements: [[[String]]] = []
        let tmpState = state

        if let i = tmpState.firstIndex(where: { $0.contains("0") }),
           let j = tmpState[i].firstIndex(of: "0") {
            if i < 2 {
                movements += (movePieceInDirection(.down, board: state, piece: (i, j)))
            }

            if i > 0 {
                movements += (movePieceInDirection(.up, board: state, piece: (i, j)))
            }

            if j < 2 {
                movements += (movePieceInDirection(.right, board: state, piece: (i, j)))
            }

            if j > 0 {
                movements += (movePieceInDirection(.left, board: state, piece: (i, j)))
            }
        }

        return movements
    }

    func movePieceInDirection(_ direction: Direction, board: [[String]], piece: (Int, Int)) -> [[[String]]] {
        var movements: [[[String]]] = []
        switch direction {
        case .up:
            var boardCopy = board
            let tmp = boardCopy[piece.0][piece.1]
            boardCopy[piece.0][piece.1] = boardCopy[piece.0 - 1][piece.1]
            boardCopy[piece.0 - 1][piece.1] = tmp
            movements.append(boardCopy)
        case .down:
            var boardCopy = board
            let tmp = boardCopy[piece.0][piece.1]
            boardCopy[piece.0][piece.1] = boardCopy[piece.0 + 1][piece.1]
            boardCopy[piece.0 + 1][piece.1] = tmp
            movements.append(boardCopy)
        case .left:
            var boardCopy = board
            let tmp = boardCopy[piece.0][piece.1]
            boardCopy[piece.0][piece.1] = boardCopy[piece.0][piece.1 - 1]
            boardCopy[piece.0][piece.1 - 1] = tmp
            movements.append(boardCopy)
        case .right:
            var boardCopy = board
            let tmp = boardCopy[piece.0][piece.1]
            boardCopy[piece.0][piece.1] = boardCopy[piece.0][piece.1 + 1]
            boardCopy[piece.0][piece.1 + 1] = tmp
            movements.append(boardCopy)
        }

        return movements
    }

    func h_misplaced(state: [[String]]) -> Int {
        var misplaced = 0
        var comparator = 1
        for line in state {
            for number in line {
                if number != "\(comparator)" {
                    misplaced += 1
                }
                comparator += 1
            }
        }

        return misplaced
    }

    func a_estrela(start: [[String]], completion: @escaping (() -> Void)) -> AStarPuzzle {
        let end = [["1","2","3"],
                   ["4","5","6"],
                   ["7","8","0"]]
        var explored = [[[String]]]()
        var bank = [AStarPuzzle(heuristics: h_misplaced(state: start), state: [start])]
        var path: AStarPuzzle = AStarPuzzle(heuristics: 1, state: [])
        while true {
            var i = 0
            for (j, _) in bank.enumerated() {
                if bank[i].heuristics > bank[j].heuristics {
                    i = j
                }
            }
            path = bank.remove(at: i)
            let final = path.state.last!
            if explored.contains(final) { continue }
            for movement in availableMoves(state: final) {
                if explored.contains(movement) { continue }
                let heuristic = path.heuristics + h_misplaced(state: movement) + h_misplaced(state: final)
                let new = path.state + [movement]
                bank.append(AStarPuzzle(heuristics: heuristic, state: new))
            }
            explored.append(final)
            if final == end {
                break
            }
        }
        completion()
        return path
    }
}
