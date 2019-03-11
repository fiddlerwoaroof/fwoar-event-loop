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

(defgeneric cleanup (event-loop)
  (:method (event-loop)
    (declare (ignore event-loop))))

(defgeneric queue (event-loop))

(defgeneric (setf finish-cb) (cb event-loop))
(defgeneric finish-cb (event-loop))

(defgeneric tick (event-loop)
  (:method :around (event-loop)
    (call-next-method)))

(defparameter *task-depth* 10)

(defmacro until-finished (finished-var &body body)
  `(loop until ,finished-var do
         ,@body))

(defun run-loop (event-loop)
  (let ((finished nil))
    (setf (finish-cb event-loop)
          (lambda ()
            (setf finished t)))
    (prepare-loop event-loop)
    (unwind-protect (until-finished finished
                      (with-simple-restart (continue "continue event loop")
                        (tick event-loop)))
      (format t "unwinding...")
      (cleanup event-loop))))

(defun wait-for-promise (promise)
  (let* ((result-queue (make-instance 'chanl:bounded-channel)))
    (bb:alet ((v promise))
      (chanl:send result-queue v))
    (loop
      (return (chanl:recv result-queue)))))
