;;; boardprocessing.lisp
;;; Functions for manipulating and analyzing sudoku board state

;; Check if a cell is empty (nil or 0 represents empty)
(defun empty-cell (cell)
  "Check if a cell value indicates emptiness"
  (or (null cell) (and (numberp cell) (= cell 0))))

;; Check if a specific position on the board is empty
(defun empty (board x y)
  "Check if a specific cell at (x, y) is empty"
  (empty-cell (aref board x y)))

;; Reorganize board into block groups for validation (returns list of lists)
(defun block-groups (board)
  "Reorganize the board into block groups for validation"
  (let ((result (list)))
    (loop for block-x from 0 below xblocks do
          (loop for block-y from 0 below yblocks do
                (let ((block-list (list)))
                  (loop for local-x from 0 below (truncate maxx xblocks) do
                        (loop for local-y from 0 below (truncate maxy yblocks) do
                              (let ((global-x (+ (* block-x (truncate maxx xblocks)) local-x))
                                    (global-y (+ (* block-y (truncate maxy yblocks)) local-y)))
                                (push (aref board global-x global-y) block-list))))
                  (push block-list result))))
    result))

;; Reorganize board into row groups for validation (returns list of lists)
(defun row-groups (board)
  "Reorganize the board into row groups for validation"
  (loop for x from 0 below maxx collect
        (loop for y from 0 below maxy collect (aref board x y))))

;; Reorganize board into column groups for validation (returns list of lists)
(defun column-groups (board)
  "Reorganize the board into column groups for validation"
  (loop for y from 0 below maxy collect
        (loop for x from 0 below maxx collect (aref board x y))))

;; Compare two arrays for equality
(defun array-equal (arr1 arr2)
  "Check if two arrays are equal"
  (if (or (null arr1) (null arr2))
      (and (null arr1) (null arr2))
      (and (equal (array-dimensions arr1) (array-dimensions arr2))
           (loop for i from 0 below (array-dimension arr1 0)
                 always (loop for j from 0 below (array-dimension arr1 1)
                              always (equal (aref arr1 i j) (aref arr2 i j)))))))
