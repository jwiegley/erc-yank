;;; erc-yank --- Automagically create a Gist if pasting more than 5 lines

;; Copyright (C) 2012 John Wiegley

;; Author: John Wiegley <jwiegley@gmail.com>
;; Created: 17 Jun 2012
;; Version: 1.0
;; Keywords: erc yank gist
;; X-URL: https://github.com/jwiegley/erc-yank

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; Automagically create a Gist if pasting more than 5 lines.
;;
;; Hook in as follows:
;;
;;   (add-hook 'erc-mode-hook
;;             (lambda () (define-key erc-mode-map [(control ?y)] 'erc-yank)))
;;
;; Or, if you want to use my `use-package' macro:
;;
;;   (use-package erc
;;     :commands erc
;;     :config
;;     (use-package erc-yank
;;       :commands erc-yank
;;       :init
;;       (bind-key "C-y" 'erc-yank erc-mode-map)))
;;
;; This module requires gist.el, from: https://github.com/defunkt/gist.el

;;; Code:

(require 'gist)

(defgroup erc-yank nil
  "Automagically create a Gist if pasting more than 5 lines"
  :group 'erc)

(defcustom erc-yank-flood-limit 5
  "Maximum number of lines allowed to yank to an erc buffer."
  :type 'integer
  :group 'erc-yank)

(defun erc-yank (&optional arg)
  "Yank or make a gist depending on the size of the yanked text."
  (interactive "*P")
  (let ((kill-text (current-kill (cond
                                  ((listp arg) 0)
                                  ((eq arg '-) -2)
                                  (t (1- arg))))))
    (if (> (length (split-string kill-text "\n")) erc-yank-flood-limit)
        (let ((buf (current-buffer)))
          (with-temp-buffer
            (insert kill-text)
            (gist-region (point-min) (point-max) nil
                         `(lambda (gist)
                            (with-current-buffer ,buf
                              (insert (oref gist :html-url)))))))
      (yank arg))))

(provide 'erc-yank)

;;; erc-yank.el ends here
