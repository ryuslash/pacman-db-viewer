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

(defpackage :pacman-db-viewer
  (:use :cl :ningle :chipz :archive :flexi-streams :cl-utilities
        :clack.builder :clack.middleware.static :pacman-db-viewer-config)
  (:import-from :clack :clackup)
  (:export :start))
