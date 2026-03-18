;; best-first-search
;; purpose:        To run the best first search to find a solution to sudoku
;; preconditions:  The board must be a valid sudoku game board
;; postconditions: The board is updated
;; parameters:     A valid sudoku game board
;; returns:        t if a valid game board is found, nil if not
;;                 The completed board
;;                 The number of nodes created
;;                 The depth of the solution node
;;                 The number of nodes expanded
(defun generic-search (board queueing-function)
	;; Grab the root board
	;; Fill the blanks
	;; Place it into a game object
	;; Place the object into a list
	;; Run do-best-first-search
	(setf root-node (copy-array board))
	(setf root-node (fillblanks root-node))

	(setf gameobj (make-instance 'game))
	(setf (slot-value gameobj 'board) root-node)
	(setf (slot-value gameobj 'depth) 0)
	(setf obj-tmplist (list gameobj))

	
	(return-from generic-search (do-generic-search obj-tmplist queueing-function))

)

;; do-best-first-search
;; purpose:        To run a best first search to fill the sudoku board
;; preconditions:  The nodes inside the list must contain valid boards
;; postconditions: None
;; parameters:     A list of nodes using the game datrastructure
;;                 Whether or not to check if nodes have been visited
;;						defult is not to check
;; returns:        t if a valid board is found, nil if not
;;                 A completed board
;;                 The number of nodes created
;;                 The depth of the solution node
;;                 The number of nodes expanded
(defun do-generic-search (node-list queueing-function &optional (check-visited nil))
	;; Set the initial values for node count, depth, expanded, and visited
	(setf node-count 0)
	(setf node-depth 0)
	(setf expanded-nodes 0)
	(setf visited-list (list '()))
	(setf already-visited nil)

    ;; Test if the initial board is a solution
    (if (goal-test (copy-array (slot-value (nth 0 node-list) 'board)))
        (return-from do-breadth-first-search (list t (slot-value (nth 0 node-list) 'board) node-count node-depth expanded-nodes))
    )

    ;; Loop until the list of nodes is empty
    ;; If the loop ends before a solution is found, there is no solution
    (loop while (/= (list-length node-list) 0) do
        ;; Get the parent node, the one closest to the solution
        ;; Remove it from the list
		(setf parent-values (funcall queueing-function node-list))
		(setf node-list (nth 0 parent-values))
		(setf parent-node (nth 1 parent-values))
		(setf parent-board (copy-array (slot-value parent-node 'board)))

		;; Determin the next blank cell to fill creating the children nodes
		;; If it is not nil expand, if it is nil, then this is not on the path to the solution
		(setf smallest-cell (fewest-cell-coords (copy-array parent-board)))
		(if smallest-cell (progn
			(setf x-smallest (nth 0 smallest-cell))
			(setf y-smallest (nth 1 smallest-cell))
			(setf expanded-nodes (+ expanded-nodes 1))

			;; Loop from 0 to the length of the list of possible values
			;; Create a node per possible value
			;; Test if it is a solution
			;;      If so return
			;;      If not push them onto the back of the queue
			(setf num-of-val (list-length (aref parent-board x-smallest y-smallest)))
			(loop for cell-value from 0 to (- num-of-val 1) do
				(setf child-board (copy-array parent-board))
				(setf (aref child-board x-smallest y-smallest) (nth cell-value (aref parent-board x-smallest y-smallest)))
				(setf node-count (+ node-count 1))

						(update-board-display (copy-array child-board) node-count (list-length node-list) (+ (slot-value parent-node 'depth) 1) expanded-nodes)

				(if (is-valid-board child-board) (progn
					;; Debug output commented out - use update-board-display instead
					;; (if (not (listp (aref child-board 0 2)))
					;; 	(if (= (aref child-board 0 2) 2)
					;; 		(print child-board)
					;; 	)
					;; )

					(setf child-node (make-instance 'game))
					(setf (slot-value child-node 'board) (copy-array child-board))
					(setf (slot-value child-node 'depth) (+ (slot-value parent-node 'depth) 1))

					;; If the child board still contains a full list of possible values continue
					;;     If there are nil positions then skip
					(if check-visited (progn
						(setf already-visited (is-already-visited child-board visited-list))
						(setf visited-list (push-onto-visited-list child-board visited-list))
					))
					;; If the child is a valid game board then push it onto the list
					;;    If not skip
					(if (not already-visited) (progn

						(if (goal-test (copy-array child-board))
							(return-from do-generic-search (list t child-board node-count (+ (slot-value parent-node 'depth) 1) expanded-nodes))
						)

						;; Push the child onto the queue
						(setf returnvalues (funcall queueing-function node-list child-node))
						(setf node-list (nth 0 returnvalues))
					))
				))
			)
		))
	)

    (return-from do-generic-search (list nil parent-board node-count (slot-value parent-node 'depth) expanded-nodes))

)


;; best-first-fitness-function
;; purpose:        To updated the fitness value of the game object
;; preconditions:  The node must be a valid game object
;; postconditions: The fitness of the node is updated
;; parameters:     A valid game board node
;; returns:        The node with the updated fitness
(defun generic-best-first-fitness-function (node)
	;; To determin the fitness loop through each position and count the number of possibilities
	;;    The "fitest board" has the lowest fitness value
	(setf (slot-value node 'board) (remove-from-sublists (slot-value node 'board)))
	(setf game-board (slot-value node 'board))
	(if (not game-board)
		(return-from generic-best-first-fitness-function nil)
	)

	(setf counter 0)
	(loop for x from 0 to (- maxx 1) do
		(loop for y from 0 to (- maxy 1) do
			(if (listp (aref game-board x y))
				(setf counter (+ counter (list-length (aref game-board x y))))
			)
		)
	)
	(return-from generic-best-first-fitness-function counter)
)

;; generic-best-first-queueing
;; purpose:        To push and pop off the queue to perform a best first search
;; preconditions:  The node list must be a valid game node list
;;                 The node must be a valid game node
;; postconditions: The node-list is updated
;;                 The fitness of the node is updated
;; parameters:     A valid game node list
;;                 An optional node parameter
;;                    If a valid nod, it will be pushed onto the queue
;;                    If nil then the next node is returned
;; returns:        A list of the updated queue and the node
;;                    If node was nil the next node
;;                    If node not nil then nil
(defun generic-best-first-queueing (node-list &optional (node nil))
	(if node
		(progn
			(setf (slot-value node 'fitness) (generic-best-first-fitness-function child-node))
			(if (slot-value node 'board)
				(setf node-list (queueing-function child-node node-list))
			)
			(setf next-node nil)
		)
		(progn
			(setf next-node (pop node-list))
		)
	)
	(return-from generic-best-first-queueing (list node-list next-node))
)

;; generic-breadth-first-queueing
;; purpose:        To push and pop off the queue to perform a breadth first search
;; preconditions:  The node list must be a valid game node list
;;                 The node must be a valid game node
;; postconditions: The node-list is updated
;; parameters:     A valid game node list
;;                 An optional node parameter
;;                    If a valid nod, it will be pushed onto the queue
;;                    If nil then the next node is returned
;; returns:        A list of the updated queue and the node
;;                    If node was nil the next node
;;                    If node not nil then nil
(defun generic-breadth-first-queueing (node-list &optional (node nil))
	(if node
		(progn
			(push node node-list)
			(setf next-node nil)
		)
		(progn
			(setf next-node (nth (- (list-length node-list) 1) node-list))
			(setf node-list (butlast node-list))
		)
	)
	(return-from generic-breadth-first-queueing (list node-list next-node))
)

;; generic-depth-first-queueing
;; purpose:        To push and pop off the queue to perform a depth first search
;; preconditions:  The node list must be a valid game node list
;;                 The node must be a valid game node
;; postconditions: The node-list is updated
;; parameters:     A valid game node list
;;                 An optional node parameter
;;                    If a valid nod, it will be pushed onto the queue
;;                    If nil then the next node is returned
;; returns:        A list of the updated queue and the node
;;                    If node was nil the next node
;;                    If node not nil then nil
(defun generic-depth-first-queueing (node-list &optional (node nil))
	(if node
		(progn
			(push node node-list)
			(setf next-node nil)
		)
		(progn
			(setf next-node (pop node-list))
		)
	)
	(return-from generic-depth-first-queueing (list node-list next-node))
)
