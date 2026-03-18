;;; utilityfunctions.lisp
;;; General utility functions for array and list manipulation

;; Deep copy a 2D array
(defun copy-array (arr)
  "Create a deep copy of a 2D array"
  (if (null arr)
      nil
      (let ((rows (array-dimension arr 0))
            (cols (array-dimension arr 1)))
        (make-array (list rows cols)
                    :initial-contents
                    (loop for i from 0 below rows
                          collect (loop for j from 0 below cols
                                        collect (aref arr i j)))))))

;; Copy a list
(defun copy-list (lst)
  "Create a copy of a list"
  (cl:copy-list lst))

;; Get the length of a list
(defun list-length (lst)
  "Get the length of a list"
  (length lst))

;; Compare two arrays for equality
(defun array-equal (arr1 arr2)
  "Check if two arrays are equal"
  (if (or (null arr1) (null arr2))
      (and (null arr1) (null arr2))
      (and (equal (array-dimensions arr1) (array-dimensions arr2))
           (loop for i from 0 below (array-dimension arr1 0)
                 always (loop for j from 0 below (array-dimension arr1 1)
                              always (equal (aref arr1 i j) (aref arr2 i j)))))))
