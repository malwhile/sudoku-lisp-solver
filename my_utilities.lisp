;; goaltest
;; purpose:        To test if the goal has been reached
;; preconditions:  The board is a valid sudoku game board
;; postconditions: None
;; perameters:     A valid sudoku game board
;; returns:        T if a valid solution
;;                 0 if not a valid solution
(defun goal-test (board)
	;; Check if the board doesn't contain sub lists
	;; If so return 0
	;; Check if board is filled
	;; If not return 0
	(loop for x from 0 to (- maxx 1) do
		(loop for y from 0 to (- maxy 1) do
	    	(if (empty board x y)
				(return-from goal-test nil)
	    	)
	    	(if (listp (aref board x y))
				(return-from goal-test nil)
	    	)
		)
	)

	;; Check that the blocks contain all unique numbers
	;; from 1 to xblocks*yblocks
	(setq boardcopy (block-groups board))
	(if (not (check-no-repeat boardcopy))
    	(return-from goal-test nil)
	)

	;; Check that the rows contain all unique numbers
	;; from 1 to xblocks*yblocks
	(setq boardcopy (row-groups board))
	(if (not (check-no-repeat boardcopy))
		(return-from goal-test nil)
	)

	;; Check that the columns contain all unique numbers
	;; from 1 to xblocks*yblocks
	(setq boardcopy (column-groups board))
	(if (not (check-no-repeat boardcopy))
		(return-from goal-test nil)
	)

	;; If all conditions pass return true
	(return-from goal-test t)
)

;;
;;
;;
;;
;;
(defun is-valid-board (board)
	;; Check that the blocks contain all unique numbers
	;; from 1 to xblocks*yblocks
	(setq boardcopy (block-groups board))
	(if (not (check-no-repeat boardcopy))
    	(return-from is-valid-board nil)
	)

	;; Check that the rows contain all unique numbers
	;; from 1 to xblocks*yblocks
	(setq boardcopy (row-groups board))
	(if (not (check-no-repeat boardcopy))
		(return-from is-valid-board nil)
	)

	;; Check that the columns contain all unique numbers
	;; from 1 to xblocks*yblocks
	(setq boardcopy (column-groups board))
	(if (not (check-no-repeat boardcopy))
		(return-from is-valid-board nil)
	)

	;; If all conditions pass return true
	(return-from is-valid-board t)
)

;; checkconsecutive
;; purpose:        To check if the numbers are consecutive from 1 to maxx
;; preconditions:  The copy of the board is a valid sudoku board
;; postconditions: The lists are sorted numerically
;; parameters:     A copy of a sudoku board
;; returns:        0 if the goal-test fails
;;                 nothing if the goal-test is achieved
(defun check-no-repeat (board-copy)
	(loop for x from 0 to (- maxx 1) do
		(loop for y from 0 to (- maxy 1) do
			(if (and (not (empty-cell (nth y (nth x board-copy)))) (not (listp (nth y (nth x board-copy))))) (progn
				(if (not (nth y (nth x board-copy)))
					(return-from check-no-repeat nil)
				)
				(loop for z from (+ y 1) to (- maxy 1) do
					(if (and (not (empty-cell (nth z (nth x board-copy)))) (not (listp (nth z (nth x board-copy))))) 
						(if (= (nth y (nth x board-copy)) (nth z (nth x board-copy)))
							(return-from check-no-repeat nil)
						)
					)
				)
			))
		)
	)

	(return-from check-no-repeat t)
)

;;
;;
;;
;;
;;
(defun find-next-blank (board)
	(loop for x from 0 to (- maxx 1) do
		(loop for y from 0 to (- maxy 1) do
			(if (empty-cell (aref board x y))
				(return-from find-next-blank (list x y))
			)
		)
	)
	(return-from find-next-blank nil)
)

;;
;;
;;
;;
;;
(defun fewest-cell-coords (board)

	(setf fewest-x -1)
	(setf fewest-y -1)
	(setf fewest-list (+ maxx 1))

	(loop for x from 0 to (- maxx 1) do
		(loop for y from 0 to (- maxy 1) do
			(if (not (aref board x y)) (progn
				(print (aref board x y))
				(return-from fewest-cell-coords nil)
			))
			(if (listp (aref board x y)) (progn
				(if (< (list-length (aref board x y)) fewest-list) (progn
					(setf fewest-x x)
					(setf fewest-y y)
					(setf fewest-list (list-length (aref board x y)))
	;;				(return-from fewest-cell-coords (list fewest-x fewest-y))
				)) 
			))
		)
	)

	(if (< fewest-list (+ maxx 1))
		(return-from fewest-cell-coords (list fewest-x fewest-y))
		(return-from fewest-cell-coords nil)
	)
)

;; fillblankslist
;; purpose:        To fill all the blank nodes with a list of possible values
;; preconditions:  Must be a valid sudoku board
;; postconditions: The array of the board that is passed in is updated
;; parameters:     The valid sudoku board to be updated, this must be a 2D array
;; returns:        The filled sudoku board
(defun fillblanks (initial-board)
	(setf fillist ())
	(setf counter maxy)
	(loop while (> counter 0) do
		(push counter fillist)
		(setf counter (- counter 1))
	)

	;; loop through all of the blocks of the board
	(setf board (copy-array initial-board))
	(loop for x from 0 to (- maxx 1) do
		(loop for y from 0 to (- maxy 1) do
			(if (empty-cell (aref board x y))
				(setf (aref board x y) (copy-list fillist))
			)
		)
	)

	(return-from fillblanks board)
)

(defun remove-from-sublists (initial-board)
	(setf board (copy-array initial-board))
	(if board
		(setf board (remove-from-row-sublist (copy-array board)))
	)
	(if board
		(setf board (remove-from-column-sublist (copy-array board)))
	)
	(if board
		(setf board (remove-from-block-sublist (copy-array board)))
	)

	(return-from remove-from-sublists board)
)

;; remove-from-block-sublist
;; purpose:        To remove values from the sublists
;;				   	  according to which block it is in
;; preconditions:  The board must be a valid sudoku board
;;                    and all blanks must be filled
;; postconditions: The board that is pased in is updated
;;                    Removes extra numbers from sublists
;;                    If only one number is left sets it as the value of the node
;; parameters:     A valid sudoku board
;;                    In either block row or column form
;; returns:        t if a single value is found
(defun remove-from-block-sublist (board)
	;; Loop through all values
	;; if a sublist is found then loop through its block
	;; remove any numbers that are found
	(loop for global-x from 0 to (- maxx 1) do
		(loop for global-y from 0 to (- maxy 1) do
			(if (listp (aref board global-x global-y)) (progn
				(setf tmplist (copy-list (aref board global-x global-y)))
				(setf row-block (truncate global-x xblocks))
				(setf col-block (truncate global-y yblocks))
				;; loop through block
				(loop for local-x from (* xblocks row-block) to	(- (+ (* row-block xblocks) xblocks) 1) do
					(loop for local-y from (* yblocks col-block) to	(- (+ (* col-block yblocks) yblocks) 1) do
						(if (not (listp (aref board local-x local-y)))
							(setf tmplist (delete (aref board local-x local-y) tmplist))
						)
					)
				)
				(if tmplist
					(setf (aref board global-x global-y) (copy-list tmplist))
					(return-from remove-from-block-sublist nil)
				)
			))
		)
	)
	
	(return-from remove-from-block-sublist board)
)

;; remove-from-row-sublist
;; purpose:
;; preconditions:
;; postconditions:
;; parameters:
;; returns:
(defun remove-from-row-sublist (initial-board)
	(let (board global-x global-y local-y tmplist)
	(setf board (copy-array initial-board))
	;; loop through each node
	;; if a list is found loop through the row removing values from the lists
	(loop for global-x from 0 to (- maxx 1) do
		(loop for global-y from 0 to (- maxy 1) do
			(if (listp (aref board global-x global-y)) (progn
				(setf tmplist (copy-list (aref board global-x global-y)))
				(loop for local-y from 0 to (- maxy 1) do
					(if (not (listp (aref board global-x local-y)))
						(setf tmplist (delete (aref board global-x local-y) tmplist))
					)
				)
				(if tmplist
					(setf (aref board global-x global-y) (copy-list tmplist))
					(return-from remove-from-row-sublist nil)
				)
			))
		)
	)
	(return-from remove-from-row-sublist board)
))

;; remove-from-column-sublist
;; purpose:
;; preconditions:
;; postconditions:
;; parameters:
;; returns:
(defun remove-from-column-sublist (board)
	;; loop through each node
	;; if a list is found loop through the row removing values from the lists
	(loop for global-x from 0 to (- maxx 1) do
		(loop for global-y from 0 to (- maxy 1) do
			(if (listp (aref board global-x global-y)) (progn
				(setf tmplist (copy-list (aref board global-x global-y)))
				(loop for local-x from 0 to (- maxx 1) do
					(if (not (listp (aref board local-x global-y)))
						(setf tmplist (delete (aref board local-x global-y) tmplist))
					)
				)
				(if tmplist
					(setf (aref board global-x global-y) (copy-list tmplist))
					(return-from remove-from-column-sublist nil)
				)
			))
		)
	)
	(return-from remove-from-column-sublist board)
)

;; queueing-function
;; purpose:        To determin the fitness of the node and place it in the queue
;; preconditions:  The curr-node must be filled with possible lists
;;                    instead of blanks
;; postconditions: The node-list is updated
;; parameters:     The current node as a game object
;;                 The node list
;; returns:        The updated node list
(defun queueing-function (curr-node node-list)
    ;; Set initial values for the position of the curr node
    ;; and the position of the node it's being compaired to
    (setf pos-index nil)
    (setf pos-list 0)

    ;; Loop through the entire list
    ;; If the node can be placed before the entire list is traversed, jump out
    (loop while (and (not pos-index) (< pos-list (list-length node-list))) do
        (if (<= (slot-value curr-node 'fitness) (slot-value (nth pos-list node-list) 'fitness))
            (setf pos-index (+ pos-list 1))
        )
        (setf pos-list (+ pos-list 1))
    )

    ;; If the position is not found, place it at the end of the list
    (if (not pos-index)
        (setf pos-index (+ (list-length node-list) 1))
    )

    ;; Return after caling the function to place the node in the correct location
    (return-from queueing-function (insert-at pos-index node-list curr-node))
)

;; push onto visited list
;; purpose:        To place all rotations of the current board onto the visited list
;; preconditions:  The board must be valid
;; postconditions: The visited list is updated
;; parameters:     The current board
;;                 The current visited list
;; returns:        The updated visited list
(defun push-onto-visited-list (curr-board visited-list)
    (setf processing-board (copy-array curr-board))
	(push (copy-array processing-board) visited-list)
    (loop for rotation from 1 to 3 do
        (setf rotated-board (copy-array processing-board))
        (loop for x from 0 to (- maxx 1) do
            (loop for y from 0 to (- maxy 1) do
                (setf (aref rotated-board (- maxy 1) y) (aref processing-board x y))
            )
        )
        (push (copy-array rotated-board) visited-list)
        (setf processing-board (copy-array rotated-board))
    )
    (return-from push-onto-visited-list visited-list)
)

;; is-already-visited
;; purpose:        To determine if the board has already been tried
;; preconditions:  The curr-node must be a valid board
;; postconditions: None
;; parameters:     The current node to be tested
;;                 The list of visited nodes
;; returns:        t if the node was already, nil if it wasn't
(defun is-already-visited (curr-node visited-list)
    (loop for x from 0 to (- (list-length visited-list) 1) do
        (if (nth x visited-list)
            (if (array-equal curr-node (nth x visited-list))
                (return-from is-already-visited t)
            )
        )
    )
    (return-from is-already-visited nil)
)

;; insert-at
;; purpose:        To place the curr-node at position pos in the node-list
;; preconditions:  The curr-node must be a valid game object
;; postconditions: The node-list is updated
;; parameters:     The position of the current node
;;                 The list of unexpanded nodes
;;                 The current node as a valid game object
;; returns:        The updated node list
;;
;; Function based on http://www.ic.unicamp.br/~meidanis/courses/mc336/2006s2/funcional/p21.lisp
;;
(defun insert-at (pos node-list curr-node)
    ;; Call recursively decrementing the position to 1
    ;;    When the position is one, place the node at the beginning of the list
    ;;    When the function moves up the stack all the other nodes
    ;;       are placed in front of the current node
    (if (or (eql pos 1) (eql node-list nil))
        (cons curr-node node-list)
        (cons (car node-list) (insert-at (- pos 1) (cdr node-list) curr-node))
    )
)

