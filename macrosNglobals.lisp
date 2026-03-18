;;; macrosNglobals.lisp
;;; Global variables and constants for the sudoku solver

;; Board dimensions - these are set dynamically during tests
(defvar maxx 9 "Maximum x dimension of the board")
(defvar maxy 9 "Maximum y dimension of the board")

;; Block dimensions - these are set dynamically during tests
(defvar xblocks 3 "Number of blocks in x direction")
(defvar yblocks 3 "Number of blocks in y direction")

;; Helper constant for accessing internal time
(defvar internal-time-units-per-second nil "Set by Lisp implementation")
