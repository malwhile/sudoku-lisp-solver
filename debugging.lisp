;;; debugging.lisp
;;; Debug output and logging functionality

;; Global debug stream
(defvar *DEBUG* nil "Debug output stream")

;; Open a debug file for output
(defun open-debug (filename)
  "Open a debug output file for writing"
  (setf *DEBUG* (open filename
                       :direction :output
                       :if-exists :supersede
                       :if-does-not-exist :create)))

;; Close the debug file
(defun close-debug ()
  "Close the debug output file"
  (when *DEBUG*
    (close *DEBUG*)
    (setf *DEBUG* nil)))
