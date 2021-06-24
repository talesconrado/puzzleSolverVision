//
//  Puzzle.swift
//  Eight Puzzle Solver
//
//

import Foundation

enum Direction {
    case up, down, left, right
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
            boardCopy[piece.0][piece.1] = boardCopy[piece.0][piece.1 - 1]
            boardCopy[piece.0][piece.1 - 1] = tmp
            movements.append(boardCopy)
        }

        return movements
    }
/*
 def move(tab_original):
     """
     Checa possíveis movimentos (os nós)
     da árvore
     """
     movimentos = []
     tab = eval(tab_original)
     i = 0
     j = 0
     while 0 not in tab[i]: i += 1
     j = tab[i].index(0)


     if i<2:         #mover o 0 para baixo
         tab[i][j], tab[i+1][j] = tab[i+1][j], tab[i][j]
         movimentos.append(str(tab))
         tab[i][j], tab[i+1][j] = tab[i+1][j], tab[i][j]

     if i>0:         #mover o 0 para cima
         tab[i][j], tab[i-1][j] = tab[i-1][j], tab[i][j]
         movimentos.append(str(tab))
         tab[i][j], tab[i-1][j] = tab[i-1][j], tab[i][j]

     if j<2:         #mover o 0 para a direita
         tab[i][j], tab[i][j+1] = tab[i][j+1], tab[i][j]
         movimentos.append(str(tab))
         tab[i][j], tab[i][j+1] = tab[i][j+1], tab[i][j]

     if j>0:         #mover o 0 para a esquerda
         tab[i][j], tab[i][j-1] = tab[i][j-1], tab[i][j]
         movimentos.append(str(tab))
         tab[i][j], tab[i][j-1] = tab[i][j-1], tab[i][j]

     return movimentos
*/

    func bfs() -> [[[String]]] {
        let end = [["1", "2", "3"], ["4", "5", "6"], ["7", "8", "0"]]
        var explored: [[[String]]] = []
        var bank = [[state]]
        var path: [[[String]]] = []
        while true {
            path = bank[0]
            bank = Array(bank[0...0]) + Array(bank[1...])
            let final = path.last!

            if explored.contains(final) {
                continue
            }

            for move in availableMoves(state: final) {
                if explored.contains(move) {
                    continue
                }
                let array = path + [move]
                bank.append(array)
            }
            explored.append(final)
            if final == end {
                break
            }
        }

        return path
    }
/*

 def bfs(start,end):
     """
     Usa busca em largura para
     resolver o quebra-cabeça
     """
     explorado = []
     banco = [[start]]
     while banco:
         i = 0
         caminho = banco[i]
         banco = banco[:i] + banco[i+1:]
         final = caminho[-1]
         if final in explorado:
             continue
         for movimento in move(final):
             if movimento in explorado:
                 continue
             banco.append(caminho + [movimento])
         explorado.append(final)
         if final == end: break
     return caminho

 def h_misplaced(tabuleiro):
     """
     Implementa a heurística de
     checar quantas peças estão
     fora do lugar
     """
     misplaced = 0
     comparador = 1
     tab = eval(tabuleiro)
     for i in range(0,3):
         for j in range(0,3):
             if tab[i][j] != comparador:
                 misplaced += 1
             comparador += 1
     return misplaced

 def a_estrela(start,end):
     """
     Usa o A* para resolver
     o quebra-cabeça
     """
     explorado = []
     banco = [[h_misplaced(start),start]]
     while banco:
         i = 0
         for j in range(1,len(banco)):
             if (banco[i][0]) > (banco[j][0]):
                i = j
         caminho = banco[i]
         banco = banco[:i] + banco[i+1:]
         final = caminho[-1]
         if final in explorado: continue
         for movimento in move(final):
             if movimento in explorado: continue
             novo = [caminho[0] + h_misplaced(movimento) + h_misplaced(final)] + caminho[1:] + [movimento]
             banco.append(novo)
         explorado.append(final)
         if final == end: break
     return caminho


 tabuleiro = str([
                 [4,3,6],
                 [8,7,1],
                 [0,5,2]
             ])

 obj_final = str([
                 [1,2,3],
                 [4,5,6],
                 [7,8,0]
             ])

 print("Usando Busca em Largura:")
 for i in bfs(tabuleiro,obj_final):
     print(i, end="\n")

 print("Usando A*:")
 for i in a_estrela(tabuleiro,obj_final):
     print(i, end="\n")
 */
}
