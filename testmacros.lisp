;;
;; Test the functions given by DesJardins
;;

(load "boardprocessing.lisp")
(load "datastructures.lisp")
(load "debugging.lisp")
(load "macrosNglobals.lisp")
(load "testproblems.lisp")
(load "utilityfunctions.lisp")
(load "my_utilities.lisp")
(load "display.lisp")
(load "genericsearch.lisp")


;; Used to run the full test for all three algorithms on all nine tests
(defun run-full-test() 
	(open-debug "sudoku2.out")

	(format *DEBUG* "Breadth First~%")
	(print "Running Breadth First Search")
	(run-individual-tests #'generic-breadth-first-queueing)

	(format *DEBUG* "~%-----------------------------------------------~%")
	(format *DEBUG* "Depth First~%")
	(print "Running Depth First Search")
	(run-individual-tests #'generic-depth-first-queueing)

	(format *DEBUG* "~%-----------------------------------------------~%")
	(format *DEBUG* "Best First~%")
	(print "Running Best First Search")
	(run-individual-tests #'generic-best-first-queueing)

	(close-debug)

)

;; Used to run the algorithm on all nine tests
(defun run-individual-tests (fitnessfunction)
	
	(setf xblocks 2)
	(setf yblocks 2)
	(setf maxx 4)
	(setf maxy 4)

	(setf tstarray (copy-array *test1*))
	(format *DEBUG* "~%test1~%")
	(print "Running Test 1")
	(run-testing-time tstarray fitnessfunction)

	(setf tstarray (copy-array *test2*))
	(format *DEBUG* "~%test2~%")
	(print "Running Test 2")
	(run-testing-time tstarray fitnessfunction)

	(setf tstarray (copy-array *test3*))
	(format *DEBUG* "~%test3~%")
	(print "Running Test 3")
	(run-testing-time tstarray fitnessfunction)

	(setf tstarray (copy-array *test4*))
	(format *DEBUG* "~%test4~%")
	(print "Running Test 4")
	(run-testing-time tstarray fitnessfunction)

	(setf xblocks 3)
	(setf yblocks 2)
	(setf maxx 6)
	(setf maxy 6)

	(setf tstarray (copy-array *test5*))
	(format *DEBUG* "~%test5~%")
	(print "Running Test 5")
	(run-testing-time tstarray fitnessfunction)

	(setf tstarray (copy-array *test6*))
	(format *DEBUG* "~%test6~%")
	(print "Running Test 6")
	(run-testing-time tstarray fitnessfunction)

	(setf xblocks 3)
	(setf yblocks 3)
	(setf maxx 9)
	(setf maxy 9)

	(setf tstarray (copy-array *test7*))
	(format *DEBUG* "~%test7~%")
	(print "Running Test 7")
	(run-testing-time tstarray fitnessfunction)

	(setf tstarray (copy-array *test8*))
	(format *DEBUG* "~%test8~%")
	(print "Running Test 8")
	(run-testing-time tstarray fitnessfunction)

	(setf tstarray (copy-array *test9*))
	(format *DEBUG* "~%test9~%")
	(print "Running Test 9")
	(run-testing-time tstarray fitnessfunction)


)

;; Used to run each individual algorithm and output the results to a file
(defun run-testing-time (board fitnessfunction)
	(setf time-before (get-internal-run-time))
	(setf result (generic-search board fitnessfunction))
	(setf time-after (get-internal-run-time))
	(setf time-taken (/ (- time-after time-before) internal-time-units-per-second))

	;; Log to debug file
	(format *DEBUG* "Created ~a~T Depth ~a~T Expanded ~a~%" (nth 2 result) (nth 3 result) (nth 4 result))
	(format *DEBUG* "CPU Time ~f~%" time-taken)

	;; Display result to console
	(display-result (nth 0 result)
	                 (nth 1 result)
	                 (nth 2 result)
	                 (nth 3 result)
	                 (nth 4 result)
	                 time-taken)
)

