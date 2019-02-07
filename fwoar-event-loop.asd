;;; -*- Mode:Lisp; Syntax:ANSI-Common-Lisp; Package: ASDF-USER -*-
(in-package :asdf-user)

(defsystem :fwoar-event-loop 
  :description ""
  :author "Ed L <edward@elangley.org>"
  :license "MIT"
  :depends-on (#:alexandria
               #:blackbird
               #:chanl
               #:serapeum
               #:uiop
               (:feature :sbcl
                         (:require :sb-concurrency)))
  :serial t
  :components ((:file "package")
               (:file "event-loop")
               (:file "chanl-event-loop")
               (:file "sbcl-concurrency-event-loop" :if-feature :sbcl)))
