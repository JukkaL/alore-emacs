;;; alore-mode.el --- a major mode for editing alore programs

;; Based on lua mode.
;;
;; Authors:
;;      Current Jukka Lehtosalo <jukka.lehtosalo@iki.fi> (alore mode)
;;	   2001 Christian Vogler <cvogler@gradient.cis.upenn.edu> (lua mode)
;;         1997 Bret Mogilefsky <mogul-alore@gelatinous.com> starting from
;;              tcl-mode by Gregor Schmid <schmid@fb3-s7.math.tu-berlin.de>
;;              with tons of assistance from 
;;              Paul Du Bois <pld-alore@gelatinous.com> and
;;              Aaron Smith <aaron-alore@gelatinous.com>.

;; Original notes and license:

;; This file is part of GNU Emacs.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.


(defconst alore-using-xemacs (string-match "XEmacs" emacs-version)
  "Nil unless using XEmacs).")


;; Variables

(defvar alore-mode-map nil
  "Keymap used with alore-mode.")

(defvar alore-prefix-key "\C-c"
  "Prefix for all alore-mode commands.")

(defvar alore-mode-hook nil
  "Hooks called when alore mode fires up.")

(defvar alore-mode-menu (make-sparse-keymap "Alore")
  "Keymap for alore-mode's menu.")

(defvar alore-font-lock-keywords
  (eval-when-compile
    (list
      ;; Keywords.
      (concat "\\<"
              (regexp-opt '("and"
                            "as"
                            "bind"
                            "break"
                            "case"
                            "class"
                            "const"
                            "def"
                            "div"
                            "dynamic"
                            "elif"
                            "else"
                            "encoding"
                            "end"
                            "except"
                            "finally"
                            "for"
                            "if"
                            "implements"
                            "import" 
                            "in"
                            "interface"
                            "is"
                            "mod"
			    "module"
                            "nil"
                            "not"
                            "or"
                            "private"
                            "raise"
                            "repeat"
                            "return"
                            "self"
                            "super"
			    "switch"
                            "to" 
			    "try"
                            "until"
                            "var"
                            "void"
                            "while") t)
              "\\>")

     "Default expressions to highlight in Alore mode.")))

(defconst alore-indent-whitespace " \t"
  "Character set that constitutes whitespace for indentation in alore.")

;; alore-mode

(defun alore-mode ()
  "Major mode for editing alore scripts.
The following keys are bound:
\\{alore-mode-map}
"
  (interactive)
  (let ((switches nil)
                  s)
    (kill-all-local-variables)
    (setq major-mode 'alore-mode)
    (setq mode-name "Alore")
    (set (make-local-variable 'comment-start) "--")
    (set (make-local-variable 'comment-start-skip) "--")
    (set (make-local-variable 'font-lock-defaults)
    '(alore-font-lock-keywords nil nil ((?_ . "w"))))
    (make-local-variable 'alore-default-eval)
    (or alore-mode-map
	(alore-setup-keymap))
    (use-local-map alore-mode-map)
    (set-syntax-table (copy-syntax-table))
    (modify-syntax-entry ?+ ".")
    (modify-syntax-entry ?- ". 12")
    (modify-syntax-entry ?* ".")
    (modify-syntax-entry ?/ ".")
    (modify-syntax-entry ?. ".")
    (modify-syntax-entry ?\\ ".")
    (modify-syntax-entry ?> ".")
    (modify-syntax-entry ?< ".")
    (modify-syntax-entry ?= ".")
    (modify-syntax-entry ?\n ">")
    (modify-syntax-entry ?\" "\"")
    (modify-syntax-entry ?\' "\"")
    ;; _ needs to be part of a word, or the regular expressions will
    ;; incorrectly regognize end_ to be matched by "\\<end\\>"!
    (modify-syntax-entry ?_ "w")
    (if (and alore-using-xemacs
	     (featurep 'menubar)
	     current-menubar
	     (not (assoc "Alore" current-menubar)))
	(progn
	  (set-buffer-menubar (copy-sequence current-menubar))
	  (add-menu nil "Alore" alore-xemacs-menu)))
    ;; Append Alore menu to popup menu for XEmacs.
    (if (and alore-using-xemacs (boundp 'mode-popup-menu))
	(setq mode-popup-menu
	      (cons (concat mode-name " Mode Commands") alore-xemacs-menu)))
    (run-hooks 'alore-mode-hook)))

(defun alore-setup-keymap ()
  "Set up keymap for alore mode.
If the variable `alore-prefix-key' is nil, the bindings go directly
to `alore-mode-map', otherwise they are prefixed with `alore-prefix-key'."
  (setq alore-mode-map (make-sparse-keymap))
  (let ((map (if alore-prefix-key
                 (make-sparse-keymap)
                 alore-mode-map)))
        
         ;; communication
         (define-key map "\C-c" 'comment-region)
         (if alore-prefix-key
             (define-key alore-mode-map alore-prefix-key map))
         ))


(provide 'alore-mode)


;;; alore-mode.el ends here
