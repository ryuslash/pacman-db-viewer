;; pacman-db-viewer --- View Pacman package databases.
;; Copyright (C) 2015  Tom Willemse

;; pacman-db-viewer is free software: you can redistribute it and/or
;; modify it under the terms of the GNU Affero General Public License
;; as published by the Free Software Foundation, either version 3 of
;; the License, or (at your option) any later version.

;; pacman-db-viewer is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
;; Affero General Public License for more details.

;; You should have received a copy of the GNU Affero General Public
;; License along with pacman-db-viewer. If not, see
;; <http://www.gnu.org/licenses/>.

(defpackage :pacman-db-viewer-config
  (:export :*base-directory* :*database-file* :*url-prefix*))

(defparameter pacman-db-viewer-config:*base-directory*
  (make-pathname :name nil :type nil :defaults *load-truename*)
  "The base directory pacman-db-viewer is loaded from.")

(defvar pacman-db-viewer-config:*database-file* nil
  "The location of the package database to read from.")

(defvar pacman-db-viewer-config:*url-prefix* ""
  "Prefix added to URLs.

This option is required for the proper serving of static assets.")

(asdf:defsystem :pacman-db-viewer
  :serial t
  :description "View Pacman packages database contents."
  :author "Tom Willemse"
  :license "AGPLv3"
  :depends-on (:ningle
               :closure-template
               :cl-utilities
               :archive
               :chipz
               :flexi-streams)
  :defsystem-depends-on (:closure-template)
  :components ((:file "packages")
               (:file "pacman-db")
               (:closure-template "templates/main")
               (:file "ui")
               (:file "routes")))
