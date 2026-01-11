;;; orgtbl-ascii-plot.el --- unicode-art bar plots in org-mode tables  -*- coding:utf-8; lexical-binding: t;-*-

;; Copyright (C) 2013-2026  Thierry Banel

;; Author: Thierry Banel  tbanelwebmin at free dot fr
;; Version: 1.1
;; Keywords: org, table, ascii, plot

;; orgtbl-ascii-plot is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; orgtbl-ascii-plot is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;                              □
;;╭╴Extend Org Mode bar plots╶──╯
;;│ The standard Org Mode key-binding C-c " a
;;│ is extended with new Unicode styles of plots,
;;│ using Unicode block characters.
;;│ The new plots add visual vertical lines at selected coordinates
;;│ to better make sense of the graphic.
;;╰─────────────────────────────╮
;;╭╴Legacy usage╶───────────────╯
;;│ With out-of-the-box Org Mode, put the cursor in a column containing
;;│ numerical values, then type C-c " a
;;│ A new column is added with a bar plot.
;;│ When the table is refreshed (C-u C-c *),
;;│ the plot is updated to reflect the new values.
;;╰─────────────────────────────╮
;;╭╴New usage╶──────────────────╯
;;│ This package does not change:
;;│ - the key-binding: C-c " a
;;│ - the 3 legacy plots
;;│ This package changes:
;;│ - after C-c " a, asks for the type of plot (including legacy ones)
;;│ - gives the opportunity to change the min & max, and round them
;;╰─────────────────────────────╮
;;╭╴Zero dependencies╶──────────╯
;;│ As those plots are pure text, they do not require external
;;│ graphic formats (like JPG, GIF, PNG, SVG and so on).
;;│ The package itself is pure Emacs, it does not pull extra packages.
;;│ The only requirements are:
;;│ - to use a monospaced font able to display block characters.
;;│ - to encode the file in Unicode, for instance in UTF-8
;;╰─────────────────────────────╮
;;╭╴Example╶────────────────────╯
;;│ 
;;│ |  x | sin(x/7) | ascii legacy | new unicode  |
;;│ |----+----------+--------------+--------------|
;;│ |  0 |        1 | WWWWWW       | █████▉▏      |
;;│ |  1 | 1.142372 | WWWWWWH      | █████▉▊      |
;;│ |  2 | 1.281843 | WWWWWWWh     | █████▉█▋     |
;;│ |  3 | 1.415572 | WWWWWWWW!    | █████▉██▍    |
;;│ |  4 | 1.540834 | WWWWWWWWW:   | █████▉███▏   |
;;│ |  5 | 1.655078 | WWWWWWWWWH   | █████▉███▉   |
;;│ |  6 | 1.755975 | WWWWWWWWWW!  | █████▉████▌  |
;;│ |  7 | 1.841471 | WWWWWWWWWWW  | █████▉█████  |
;;│ |  8 | 1.909823 | WWWWWWWWWWW! | █████▉█████▍ |
;;│ |  9 | 1.959639 | WWWWWWWWWWWV | █████▉█████▊ |
;;│ | 10 | 1.989903 | WWWWWWWWWWWH | █████▉█████▉ |
;;│ | 11 | 2.000000 | WWWWWWWWWWWW | █████▉██████ |
;;│ | 12 | 1.989723 | WWWWWWWWWWWH | █████▉█████▉ |
;;│ | 13 | 1.959282 | WWWWWWWWWWWV | █████▉█████▊ |
;;│ | 14 | 1.909297 | WWWWWWWWWWW! | █████▉█████▍ |
;;│ | 15 | 1.840787 | WWWWWWWWWWW  | █████▉█████  |
;;│ | 16 | 1.755147 | WWWWWWWWWW!  | █████▉████▌  |
;;│ | 17 | 1.654122 | WWWWWWWWWH   | █████▉███▉   |
;;│ | 18 | 1.539770 | WWWWWWWWW:   | █████▉███▏   |
;;│ | 19 | 1.414421 | WWWWWWWW!    | █████▉██▍    |
;;│ | 20 | 1.280629 | WWWWWWWh     | █████▉█▋     |
;;│ | 21 | 1.141120 | WWWWWWV      | █████▉▊      |
;;│ | 22 | 0.998736 | WWWWWW       | █████▉▏      |
;;│ | 23 | 0.856377 | WWWWW.       | █████▏▏      |
;;│ | 24 | 0.716944 | WWWW;        | ████▎ ▏      |
;;│ | 25 | 0.583278 | WWW!         | ███▍  ▏      |
;;│ | 26 | 0.458103 | WWh          | ██▋   ▏      |
;;│ | 27 | 0.343967 | WW.          | ██    ▏      |
;;│ | 28 | 0.243198 | W!           | █▍    ▏      |
;;│ | 29 | 0.157846 | H            | ▉     ▏      |
;;│ | 30 | 0.089653 | !            | ▌     ▏      |
;;│ | 31 | 0.040007 | :            | ▏     ▏      |
;;│ #+TBLFM: $2=sin($1/7)+1;Rf6::$3='(orgtbl-ascii-draw $2 0.0 2.0 12)::$4='(orgtbl-ascii-plot-with-vert $2 0.0 2.0 12 6)
;;│                                       ▲
;;│ A vertical line here╶─────────────────╯
;;╰─────────────────────────────╮
;;╭╴Fonts╶──────────────────────╯
;;│ A font able to display the needed Unicode characters is required
;;│ Here is a list of recommended fonts:
;;│ - DejaVu Sans Mono
;;│ - Unifont
;;│ - Hack
;;│ - JetBrains Mono
;;│ - Cascadia Mono
;;│ - Agave
;;│ - JuliaMono
;;│ - FreeMono
;;│ - Iosevka Comfy Fixed, Iosevka Comfy Wide Fixed
;;│ - Aporetic Sans Mono, Aporetic Serif Mono
;;│ - Source Code Pro
;;│ Type for example:
;;│ M-x set-default-font DejaVu Sans Mono RET
;;╰─────────────────────────────╮
;;                              □

;;; Requires:
(require 'org)
(require 'org-table)
(require 'easymenu)
(require 'subr-x)

;;; Code:

;;╭──────────────────╮
;;│ Helper functions │
;;╰──────────────────╯

(defun orgtbl-ascii-plot--decimal-readable-round (x)
  "Find the closest decimal-readable value to X.
A decimal-readable value is one begining with either 1, 2, or 5,
and whose next digits are all zeros.
Examples:
  4.14  → 5
  2.89  → 2
  0.17  → 0.2
  891.3 → 1000"
  (cond
   ((= x 0) (float x))
   ((<= x 0)
    (- (orgtbl-ascii-plot--decimal-readable-round (- x))))
   (t
    (let ((y 1.0) (z 1.0))
      (cond
       ((>= x 1)
        (while (<= (setq z (* y 10)) x)
          (setq y z)))
       (t
        (while (>  (setq y (/ z 10)) x)
          (setq z y))))
      ;; guaranty here: y <= x < z
      ;; y & z are powers of 10
      (cond
       ((> x (* y 7.071067811865475244)) z)     ;; sqrt(5*10)
       ((> x (* y 3.162277660168379332)) (* y 5)) ;; sqrt(2*5)
       ((> x (* y 1.414213562373095049)) (* y 2)) ;; sqrt(1*2)
       (t                                y))))))

(defun orgtbl-ascii-plot--wizard-ask-for-round (prompt default)
  (setq default (float default))
  (let* ((r (orgtbl-ascii-plot--decimal-readable-round default))
         (ans
          (read-from-minibuffer
           (format
            "%s (use ↓ for a rounded value) (default %s): " prompt default)
           nil
           nil
           nil
           nil
           (list (number-to-string r) (number-to-string default)))))
    (if (string-blank-p ans)
        default
      (float (string-to-number ans)))))

(defun orgtbl-ascii-plot--wizard-ask-for-number (prompt default)
  (setq default (float default))
  (let ((ans
         (read-from-minibuffer
          (format "%s (default %s): " prompt default)
          nil
          nil
          nil
          nil
          (list (number-to-string default)))))
    (if (string-blank-p ans)
        default
      (float (string-to-number ans)))))

(defun orgtbl-ascii-plot--to-number (x)
  "Convert X to a number if possible, otherwise return nil."
  (cond
   ((numberp x) x)
   ((and
     (stringp x)
     (string-match-p
      (rx
       bos
       (opt (any "+-"))
       (or
        (seq digit (0+ digit) (opt "." (0+ digit)))
        (seq "." (0+ digit)))
       (opt (any "Ee") (opt (any "+-")) (1+ digit))
       eos)
      x))
    (string-to-number x))
   (t nil)))

;;╭────────────────────╮
;;│ Individual Wizards │
;;╰────────────────────╯

(defun orgtbl-ascii-plot--wizard-legacy (type col xmin xmax ymax)
  (setq xmin (orgtbl-ascii-plot--wizard-ask-for-round "Plot starts at" xmin))
  (setq xmax (orgtbl-ascii-plot--wizard-ask-for-round "Plot ends at" xmax))
  (format "'(%s (or $%s \"\") %s %s %s)" type col xmin xmax ymax))

(defun orgtbl-ascii-plot--wizard-1-vertical (col xmin xmax ymax)
  (setq xmin (orgtbl-ascii-plot--wizard-ask-for-round "Plot starts at" xmin))
  (setq xmax (orgtbl-ascii-plot--wizard-ask-for-number  "Plot ends at" xmax))
  (let* ((xlin
          (orgtbl-ascii-plot--wizard-ask-for-round
           (format "Vertical line position within [%s..%s]" xmin xmax)
           (/ (+ xmin xmax) 2.0)))
         (ylin (ffloor (* (/ (- xlin xmin) (- xmax xmin)) ymax))))
    (setq xmax (+ xmin (/ (* (- xlin xmin) ymax) ylin)))
    (format "'(%s (or $%s \"\") %s %s %s %d)"
            'orgtbl-ascii-plot-with-vert col xmin xmax ymax ylin)))

(defun orgtbl-ascii-plot--wizard-2-verticals (col xmin xmax ymax)
  (setq xmin
        (orgtbl-ascii-plot--wizard-ask-for-number
         "Plot starts at"
         xmin))
  (setq xmax
        (orgtbl-ascii-plot--wizard-ask-for-number
         "Plot ends at"
         xmax))
  (let* ((xlin1
          (orgtbl-ascii-plot--wizard-ask-for-round
           (format "First vertical line position within [%s..%s]: "
                   xmin xmax)
           (/ (+ xmin xmin xmax) 3.0)))
         (xlin2
          (orgtbl-ascii-plot--wizard-ask-for-round
           (format "Second vertical line position within [%s..%s]: "
                   xlin1 xmax)
           (/ (+ xlin1 xmax) 2.0)))
         (xdist (- xlin2 xlin1))
         (ylin2 (ffloor   (* (/ (- xlin2 xmin) (- xmax xmin)) ymax)))
         (ylin1 (fceiling (* (/ (- xlin1 xmin) (- xmax xmin)) ymax)))
         (ydist (- ylin2 ylin1))
         )
    (if (= ydist 0)
        (user-error
         "The two vertical lines would merge on a single character.
Either the two vertical lines are too close at %s & %s,
or the min-max interval [%s..%s] is too large"
         xlin1 xlin2 xmin xmax))
    (setq xmin (- xlin2 (* (/ ylin2 ydist) xdist)))
    (setq xmax (+ (* (/ (- ymax ylin2) ydist) xdist) xlin2))
    (format "'(%s (or $%s \"\") %s %s %s %d %d)"
            'orgtbl-ascii-plot-with-vert col xmin xmax ymax ylin1 ylin2)))

(defun orgtbl-ascii-plot--wizard-many-verticals (col xmin xmax ymax)
  (setq xmin (orgtbl-ascii-plot--wizard-ask-for-round "Plot starts at" xmin))
  (setq xmax (orgtbl-ascii-plot--wizard-ask-for-number "Plot ends at " xmax))
  (let ((xdist (orgtbl-ascii-plot--wizard-ask-for-round
                "Distance between vertical lines"
                (/ (- xmax xmin) 3)))
        nblines ydist)
    (setq xmin (* (floor xmin xdist) xdist))
    (setq xmax (* (ceiling xmax xdist) xdist))
    (setq nblines (round (- xmax xmin) xdist))
    (setq ydist (round (* xdist ymax) (- xmax xmin)))
    (if (= ydist 0)
        (user-error
         "The vertical lines would merge on a single character.
Either vertical lines are too close at %s,
or the min-max interval [%s..%s] is too large"
         xdist xmin xmax))
    (setq ymax (* ydist nblines))
    (format "'(%s (or $%s \"\") %s %s %s %s)"
            'orgtbl-ascii-plot-with-vert col xmin xmax ymax
            (cl-loop
             for i from 1 below nblines
             concat (format " %s" (* i ydist))))))

;;╭──────────────────╮
;;│ Top level Wizard │
;;╰──────────────────╯

;;;###autoload
(defun orgtbl-ascii-plot-wizard (&optional type)
  "Draw an ASCII or UNICODE bar plot in a column.

With cursor in a column containing numerical values, this function
will draw a plot in a new column.

TYPE may be
- \"0-vertical-ascii-legacy\"
- \"0-vertical-unicode-cont-legacy\"
- \"0-vertical-unicode-grid-legacy\"
- \"1-vertical\"
- \"2-verticals\"
- \"many-verticals\"
"
  (interactive "P")
  (unless type
    (setq type
          (completing-read
           "Kind of plot: "
           '("0-vertical-ascii-legacy"
             "0-vertical-unicode-cont-legacy"
             "0-vertical-unicode-grid-legacy"
             "1-vertical"
             "2-verticals"
             "many-verticals")
           nil
           t
           nil)))
  (let ((col (org-table-current-column))
        (ymax (floor (read-number "Width of column in characters: " 12)))
	(xmin  1e999)		 ; 1e999 will be converted to infinity
	(xmax -1e999)		 ; which is the desired result
	(table (org-table-to-lisp))
        formula)
    ;; Skip any hline a the top of table.
    (while (eq (car table) 'hline) (pop table))
    ;; Skip table header if any.
    (dolist (x (or (cdr (memq 'hline table)) table))
      (when (consp x)
	(setq x (nth (1- col) x))
	(when (setq x (orgtbl-ascii-plot--to-number x))
	  (when (> xmin x) (setq xmin x))
	  (when (< xmax x) (setq xmax x)))))

    (setq formula
          (cond
           ((equal type "0-vertical-ascii-legacy")
            (orgtbl-ascii-plot--wizard-legacy 'orgtbl-ascii-draw col xmin xmax ymax))
           ((equal type "0-vertical-unicode-cont-legacy")
            (orgtbl-ascii-plot--wizard-legacy 'orgtbl-uc-draw-cont col xmin xmax ymax))
           ((equal type "0-vertical-unicode-grid-legacy")
            (orgtbl-ascii-plot--wizard-legacy 'orgtbl-uc-draw-grid col xmin xmax ymax))
           ((equal type "1-vertical")
            (orgtbl-ascii-plot--wizard-1-vertical col xmin xmax ymax))
           ((equal type "2-verticals")
            (orgtbl-ascii-plot--wizard-2-verticals col xmin xmax ymax))
           ((equal type "many-verticals")
            (orgtbl-ascii-plot--wizard-many-verticals col xmin xmax ymax))
           (t (error "Unknow type %s" type))))

    (org-table-insert-column)
    (org-table-move-column-right)

    (org-table-store-formulas
     (cons
      (cons
       (concat "$" (number-to-string (1+ col))) formula)
      (org-table-get-stored-formulas)))
    (org-table-recalculate t)))

;;╭───────────────────╮
;;│ Org Table formula │
;;╰───────────────────╯

;; Coordinates:
;; x-coordinates are the real values found in the Org Mode table
;;   they go from xmin to xmax
;; y-coordinates measure a number of characters in the bar plot
;;   they go from 0 to ymax
;;   they are either floating points or integers
;; The formula for mapping a real value x
;; to y, a number of character from zero is:
;;   y = (x-xmin) / (xmax-xmin) * ymax
;; Therefore, plugin xmin or xmax for x, we can see that:
;;   xmin → 0
;;   xmax → ymax
;; The other way around:
;;   x = xmin + y * (xmax-xmin) / ymax

;;;###autoload
(defun orgtbl-ascii-plot-with-vert (x xmin xmax ymax &rest ylin)
  (let ((boxes " ▏▎▍▌▋▊▉█")
        (result x))
    (if (stringp xmin) (setq xmin (string-to-number xmin)))
    (if (stringp xmax) (setq xmax (string-to-number xmax)))
    (if (stringp ymax) (setq ymax (string-to-number ymax)))
    (setq xmin (float xmin))
    (setq xmax (float xmax))
    (setq ymax (floor ymax))
    (setq ylin
          (cl-loop
           for y in ylin
           collect (floor (if (stringp y) (string-to-number y) y))))
    (cond

     ;; 1st case: a numeric cell, x is numeric
     ((setq x (orgtbl-ascii-plot--to-number x))
      (setq x (float x))
      (let* ((y (* (/ (- x xmin) (- xmax xmin)) ymax))
             (fy (if (<= -9999 y 9999) (floor y) y))) ;; avoid arith overflow
        (setq result (make-string ymax ?-))

        ;; paint in black left of y, paint in white right of y
        (cl-loop
         for i from 0 below ymax
         do
         (cond
          ((equal fy i)
           (aset result i (aref boxes (floor (* (- y i) 8)))))
          ((< y i)
           (aset result i (aref boxes 0)))
          (t
           (aset result i (aref boxes 8)))))

        ;; visually mark too small or too large values
        (cond
         ((< x xmin)
          (aset result 0 ?←))
         ((> x xmax)
          (aset result (1- ymax) ?→)))))

     ;; 2nd case: a non numeric cell copied in result
     ((< (length result) ymax)
      (setq result (string-pad result ymax))))

    ;; get ride of a possible blank at the beginning which breaks alignment
    (if (eq (aref result 0) ? )
        (aset result 0 ?◦))

    ;; overwrite vertical lines
    (cl-loop
     for i in ylin
     do
     (if (and (> i 0) (eq (aref result (1- i)) (aref boxes 8)))
         (aset result (1- i) (aref boxes 7)))
     (unless
         ;; it happens that the unicodes ▏▎▍▌▋▊▉█ form a continuous range
         ;; and as this is not going to change anytime soon, hardcoding is ok
         (<= (aref boxes 8) (aref result i) (aref boxes 1))
       (aset result i (aref boxes 1))))

    result))

;;╭────────────────────────────╮
;;│ Keyboard and Menu Bindings │
;;╰────────────────────────────╯

;;;###autoload
(defun orgtbl-ascii-plot-bindings ()
  (org-defkey org-mode-map "\C-c\"a"  #'orgtbl-ascii-plot-wizard)
  ;;(org-defkey org-mode-map "\C-c\"g"  #'org-plot/gnuplot)
  (easy-menu-add-item org-tbl-menu '("Plot") "--")
  (cl-loop
   for type in '("0-vertical-ascii-legacy"
                 "0-vertical-unicode-cont-legacy"
                 "0-vertical-unicode-grid-legacy"
                 "1-vertical"
                 "2-verticals"
                 "many-verticals")
   for fun = (intern (format "orgtbl-ascii-plot-wizard-%s" type))
   do
   ;; here we create on the fly small defuns just for the menu
   (eval `(defun ,fun () (interactive) (orgtbl-ascii-plot-wizard ,type)))
   (easy-menu-add-item
    org-tbl-menu '("Plot")
    (vector
     type
     fun
     :enable '(org-at-table-p)))))

(orgtbl-ascii-plot-bindings)

;; eval-after-load is not useful, because of the (require 'org) instruction
;; at the begining of this file, orgtbl-ascii-plot.el 
;; (eval-after-load 'org #'orgtbl-ascii-plot-bindings)

(provide 'orgtbl-ascii-plot)
;;; orgtbl-ascii-plot.el ends here
