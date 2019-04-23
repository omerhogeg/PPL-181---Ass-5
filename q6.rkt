#lang racket

(require racket/sandbox)
(require racket/exn)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Part 1: The lazy lists interface ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define cons-lzl cons)

(define empty-lzl empty)

(define empty-lzl? empty?)

(define head car)

(define tail
  (lambda (lz-lst)
    ((cdr lz-lst))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Part 2: Auxiliary functions for testing ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Signature: check-inf-loop(mission)
; Purpose: check if the result is infinite loop,
;          if so, return 'infinite
;          otherwise the actual result
; Type: [[Empty -> T1] -> Union(T1, Symbol)]
(define check-inf-loop
  (lambda (mission)
    (with-handlers ([exn:fail:resource?
                     (lambda (e)
                       (if (equal? (exn->string e)
                                   "with-limit: out of time\n")
                           'infinite
                           'error))])
      (call-with-limits 1 #f mission))))

; A function that creates an infinite loop
(define (inf x) (inf x))

;Take:
(define take(lambda (lz n)
    (if (or (<= n 0) (empty-lzl? lz))
     (empty-lzl)
      (if (= n 1)
        (list (head lz)) 
        (cons-lzl (head lz)(take (tail lz) (- n 1)))
        ))))

;Append for lzl:
(define lzl-append(lambda(first-lzl second-lzl)
    (if(empty-lzl? first-lzl)
        second-lzl
        (cons-lzl (head first-lzl)
                  (lambda ()(lzl-append (tail first-lzl) second-lzl))))))
;Map for lzl:
(define lzl-map(lambda (ourVal our-lzl)
    (if(empty-lzl? our-lzl)
        our-lzl
        (cons-lzl(ourVal(head our-lzl))
                  (lambda()(lzl-map ourVal (tail our-lzl)))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;
; Part 3: The assignment ;
;;;;;;;;;;;;;;;;;;;;;;;;;;

; Signature: all-subs(long)
; Type: [List(T) -> LZL(List(T))]
; Purpose: compute all lists that can be obtained 
; from long by removing items from it.
; Pre-conditions: -
; Tests:
; (take (all-subs '(1 2 3)) 8) ->
; '(() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3))
(define all-subs
  (lambda (long)
    ;; Your code here
    (if (empty-lzl? long) 
      (cons-lzl '() (lambda() empty-lzl))
      (let ((rest (all-subs (cdr long))))
        (lzl-append
          rest
          (lzl-map (lambda (temp) (cons-lzl (head long) temp))
                   rest)
         )))))




;;;;;;;;;;;;;;;;;;;;;
; Part 4: The tests ;
;;;;;;;;;;;;;;;;;;;;;

;; Make sure to add take or another utility to test here
;; If the results are obained in a different order, change the test accordingly.
(check-inf-loop (lambda () (take (all-subs '(1 2 3)) 8)))
;; Write more tests - at least 5 tests.
; here is our tests:
(check-inf-loop (lambda () (take (all-subs '()) 1)))	
(check-inf-loop (lambda () (take (all-subs '(1)) 2)))	
(check-inf-loop (lambda () (take (all-subs '(2 3)) 4)))
(check-inf-loop (lambda () (take (all-subs '(1 2 3 4)) 2)))
(check-inf-loop (lambda () (take (all-subs '(1 2 3 4)) 4)))
(check-inf-loop (lambda () (take (all-subs '(1 2 3 4)) 8)))
(check-inf-loop (lambda () (take (all-subs '(1 2 3 4)) 16)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Part 5: The tests expected results;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#|
> (check-inf-loop (lambda () (take (all-subs '(1 2 3)) 8))
'(() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3))
|#

#|
>(check-inf-loop (lambda () (take (all-subs '()) 1)))
'(())
|#

#|
(check-inf-loop (lambda () (take (all-subs '(1)) 2)))
'(() (1))
|#

#|
(check-inf-loop (lambda () (take (all-subs '(2 3)) 4)))
'(() (3) (2) (2 3))
|#

#|
(check-inf-loop (lambda () (take (all-subs '(1 2 3 4)) 2)))
'(() (4))
|#

#|
(check-inf-loop (lambda () (take (all-subs '(1 2 3 4)) 4))
'(() (4) (3) (3 4))
|#

#|
(check-inf-loop (lambda () (take (all-subs '(1 2 3 4)) 8)))
'(() (4) (3) (3 4) (2) (2 4) (2 3) (2 3 4))
|#

#|
(check-inf-loop (lambda () (take (all-subs '(1 2 3 4)) 16)))
'(() (4) (3) (3 4) (2) (2 4) (2 3) (2 3 4) (1) (1 4) (1 3) (1 3 4) (1 2) (1 2 4) (1 2 3) (1 2 3 4))
|#

