(in-package :fwoar.event-loop)

(defclass chanl-event-loop ()
  ((%queue :initarg :queue :reader queue :initform (make-instance 'chanl:bounded-channel :size *task-depth*))
   (%finish-callbaack :reader finish-cb :writer register-finish-cb)))

(defmethod tick ((event-loop chanl-event-loop))
  (prog1 event-loop
    (let ((task (chanl:recv (queue event-loop))))
      (when task
        (funcall task)))))

(defmethod enqueue ((queue chanl:channel) fn)
  (chanl:send queue fn))
