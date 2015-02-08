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

(in-package :pacman-db-viewer)

(defvar *current-pacman-package* nil)

(defclass pacman-package ()
  ((filename :accessor filename)
   (name :accessor name)
   (version :accessor version)
   (desc :accessor description)
   (csize :accessor csize)
   (isize :accessor isize)
   (md5sum :accessor md5sum)
   (sha256sum :accessor sha256sum)
   (pgpsig :accessor pgp-signature)
   (url :accessor url)
   (license :accessor license)
   (arch :accessor architecture)
   (builddate :accessor build-date)
   (packager :accessor packager)))

(defun string-ends-with (str postfix)
  (string-equal str postfix :start1 (- (length str) (length postfix))))

(defun map-archive-entries (func pathname)
  (with-open-file (gzstream pathname :element-type '(unsigned-byte 8))
    (let ((origin (chipz:make-decompressing-stream 'chipz:gzip gzstream))
          *current-pacman-package* lst)
      (archive:with-open-archive (archive origin)
        (archive:do-archive-entries (entry archive)
          (if (string-ends-with (archive:name entry) "/")
              (setf *current-pacman-package* (make-instance 'pacman-package)
                    lst (cons *current-pacman-package* lst))
              (funcall func entry))))
      lst)))

(defun map-lines (func stream)
  (do (line eofp)
      (eofp stream)
    (multiple-value-bind (line-1 eofp-1) (read-line stream nil "")
      (setf line line-1
            eofp eofp-1)
      (funcall func line))))

(defun read-paragraph (stream)
  (labels ((read-to-end (acc)
             (let ((line (read-line stream)))
               (if (not (string= line ""))
                   (read-to-end (append acc (list ", " line)))
                   (apply 'concatenate 'string (cdr acc))))))
    (read-to-end nil)))

(defun read-package-description-file (stream)
  (map-lines
   (lambda (line)
     (unless (string= line "")
       (let* ((type (remove #\% line))
              (sym (intern type 'pacman-db-viewer)))
         (case sym
           ((filename name version desc csize isize md5sum sha256sum
                      pgpsig url license arch builddate packager)
            (setf (slot-value *current-pacman-package* sym)
                  (read-paragraph stream)))
           (t (format t "UNK: ~A~%" line))))))
   stream)
  *current-pacman-package*)

(defun entry-to-pacman-package (entry)
  (when (archive:entry-regular-file-p entry)
    (let ((stream (flexi-streams:make-flexi-stream
                   (archive:entry-stream entry))))
      (destructuring-bind (package type)
          (cl-utilities:split-sequence #\/ (archive:name entry))
        (case (intern (string-upcase type) 'keyword)
          (:desc (read-package-description-file stream))
          (:depends (read-package-dependency-file stream))
          (t
           (format t "Unknown type: ~S~%With first line:~%~A~%"
                   (intern type 'keyword) (read-line stream))))))))

(defun read-package-dependency-file (stream)
  ;; (map-lines (lambda (line) (format t "~A~%" line)) stream)
  "To be implemented..."
  nil)

(defun read-packages-from (pathname)
  (map-archive-entries #'entry-to-pacman-package pathname))
