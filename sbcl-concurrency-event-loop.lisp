(in-package :fwoar.event-loop)

(defclass sb-concurrency-event-loop ()
  ((%queue :initarg :queue :reader queue :initform (sb-concurrency:make-mailbox))
   (%finish-callbaack :reader finish-cb :writer register-finish-cb)))

(defmethod enqueue ((queue sb-concurrency:mailbox) fn)
  (sb-concurrency:send-message queue fn))

(defmethod tick ((event-loop sb-concurrency-event-loop))
  (prog1 event-loop
    (let ((task (sb-concurrency:receive-message (queue event-loop) :timeout 0.001)))
      (when task
        (funcall task)))))
