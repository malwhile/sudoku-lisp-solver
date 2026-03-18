;;; datastructures.lisp
;;; Core data structures for the sudoku solver

;; Define the game class using CLOS (Common Lisp Object System)
(defclass game ()
  ((board :initarg :board
          :initform nil
          :accessor game-board
          :documentation "The sudoku board state (2D array)")
   (depth :initarg :depth
          :initform 0
          :accessor game-depth
          :documentation "The depth level in the search tree")
   (fitness :initarg :fitness
            :initform nil
            :accessor game-fitness
            :documentation "Fitness value for best-first search"))
  (:documentation "Represents a game state node in the search tree"))
