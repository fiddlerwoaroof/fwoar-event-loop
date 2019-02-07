(in-package :fwoar.event-loop)

(defgeneric run (task event-loop)
  (:method :around (task event-loop)
    (bb:with-promise (resolve reject)
      (enqueue (queue event-loop)
               (lambda ()
                 (handler-case (resolve (call-next-method))
                   (serious-condition (c)
                     (reject c))))))))


(defgeneric enqueue (queue fn))

(defgeneric prepare-loop (event-loop)
  (:method (event-loop)
    (declare (ignore event-loop))))

(defgeneric queue (event-loop))

(defgeneric register-finish-cb (cb event-loop))

(defgeneric tick (event-loop))

(defparameter *task-depth* 10)

(defun run-loop (event-loop)
  (let ((finished nil))
    (register-finish-cb (lambda ()
                          (setf finished t))
                        event-loop)
    (prepare-loop event-loop)
    (loop
      until finished
      do
         (tick event-loop))))

(defun wait-for-promise (promise)
  (let* ((result-queue (make-instance 'chanl:bounded-channel)))
    (bb:alet ((v promise))
      (chanl:send result-queue v))
    (loop
      (return (chanl:recv result-queue)))))