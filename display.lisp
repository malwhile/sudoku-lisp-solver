;;; display.lisp
;;; Display utilities for live board visualization

;; ANSI escape codes for cursor control
(defvar *clear-screen* (format nil "~c[2J" #\ESC) "Clear screen")
(defvar *move-home* (format nil "~c[H" #\ESC) "Move cursor to home")
(defvar *hide-cursor* (format nil "~c[?25l" #\ESC) "Hide cursor")
(defvar *show-cursor* (format nil "~c[?25h" #\ESC) "Show cursor")

;; Format a single cell value
(defun format-cell (cell)
  "Format a single cell for display"
  (cond
    ((null cell) " . ")
    ((listp cell) " ? ")
    ((= cell 0) " . ")
    (t (format nil " ~a " cell))))

;; Print a single board
(defun print-board (board)
  "Print a formatted sudoku board"
  (format t "~%")
  (loop for x from 0 below maxx do
    (when (and (> x 0) (= (mod x xblocks) 0))
      (format t "~%"))
    (loop for y from 0 below maxy do
      (when (and (> y 0) (= (mod y yblocks) 0))
        (format t " "))
      (format t (format-cell (aref board x y))))
    (format t "~%")))

;; Display current solving state with statistics
(defun display-state (board node-count queue-size depth expanded-nodes)
  "Display the current board state with statistics"
  (clear-display)
  (print-board board)
  (format t "~%Stats:~%")
  (format t "  Nodes created: ~a~%" node-count)
  (format t "  Current depth: ~a~%" depth)
  (format t "  Queue size: ~a~%" queue-size)
  (format t "  Nodes expanded: ~a~%" expanded-nodes)
  (force-output))

;; Clear the display (move cursor up and clear lines)
(defun clear-display ()
  "Move cursor to home and prepare for update"
  ;; This uses ANSI codes to move cursor up and clear
  ;; Format: ~[...~] creates a vertical scrollback
  nil)

;; Simpler version: just print with spacing
(defun update-board-display (board node-count queue-size depth expanded-nodes)
  "Update display of board and stats (simpler version without escape codes)"
  (format t "~c[H~c[J" #\ESC #\ESC) ;; ANSI: move home and clear screen
  (print-board board)
  (format t "~%═══════════════════════════════════════~%")
  (format t "Nodes created: ~a | Queue: ~a | Depth: ~a | Expanded: ~a~%"
          node-count queue-size depth expanded-nodes)
  (force-output))

;; Progress indicator
(defun display-searching (algorithm test-num)
  "Display searching progress"
  (format t "Searching with ~a on test ~a...~%" algorithm test-num)
  (force-output))

;; Display final result
(defun display-result (success board nodes-created depth nodes-expanded time-taken)
  "Display the final result of a search"
  (if success
    (format t "~%✓ Solution found!~%")
    (format t "~%✗ No solution found.~%"))
  (format t "~%Final board:~%")
  (print-board board)
  (format t "~%Results:~%")
  (format t "  Nodes created: ~a~%" nodes-created)
  (format t "  Solution depth: ~a~%" depth)
  (format t "  Nodes expanded: ~a~%" nodes-expanded)
  (format t "  Time taken: ~,3f seconds~%~%" time-taken)
  (force-output))
