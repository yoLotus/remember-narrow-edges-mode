(defvar buffer-last-narrow-edges-hash (make-hash-table :test
                                                       'equal)
  "a hash table which record point and mark of the last
buffer narrowed when region is active")


(defun remember-narrow-edges-and-narrow-region ()
  "narrow-to-region should not be not adviced according to the
  documentation because it is a compiled function. The key
  binding `C-x n n` must be bind to this function and call
  narrow-to-region next"
  (interactive)
  (if (not (region-active-p))           ; if no region active then check if
                                        ; this buffer has already been narrowed
                                        ; and use these last recorded edges
                                        ; values
      (progn
        (let ( (last-edges-recorded (gethash (current-buffer) buffer-last-narrow-edges-hash)))
          (if last-edges-recorded
              (narrow-to-region (car last-edges-recorded) (car (cdr last-edges-recorded)))
            (progn
              (narrow-to-region (point) (mark))
              (remember-narrow-edges-add-new-edges (point) (mark))))
          )
        )
    (progn                              ; otherwise regular narrow-to-region
                                        ; and record the edges values
      (narrow-to-region (point) (mark))
      (remember-narrow-edges-add-new-edges (point) (mark))
      )))

(defun remember-narrow-edges-add-new-edges (beg end)
  "insert new narrow edge to the hash"
  (puthash (current-buffer) (list beg end) buffer-last-narrow-edges-hash)
  )


;;;###autoload
(define-minor-mode remember-narrow-edges-mode
  "Each time a buffer is narrowed, the edges (mark and point of
the active region) are recorded. The buffer is next widen and the
next time the buffer is one time again narrowed without region
active, the buffer is narrowed with last recorded edges."
  :lighter " rne"
  :global t
  )

(provide 'remember-narrow-edges-mode)
