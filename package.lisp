(defpackage :fwoar.event-loop
  (:use :cl )
  (:export
   #:run
   #:tick
   #:run-loop
   #:wait-for-promise
   #:prepare-loop
   #:cleanup
   #:finish-cb))
