(define-module (monads)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-9))

(define-record-type <monad>
  (monad binder returner plus zero)
  monad?
  (binder binder)
  (returner returner)
  (plus plus)
  (zero zero))

(define m-id
  (monad (lambda (v f) (f v)) (lambda (v) v) #f #f))

(define bind-seq (lambda (v f) (fold-right append '() (map f v))))
(define return-seq (lambda (v) (list v)))

(define m-seq
  (monad bind-seq
         return-seq
         #f
         #f))

(define bind-maybe (lambda (v f)
                     (cond ((eq? (car v) 'just) (f (cadr v)))
                           ((eq? (car v) 'nothing) '(nothing)))))
(define return-maybe (lambda (v) `(just ,v)))

(define m-maybe
  (monad bind-maybe
         return-maybe
         #f
         #f))

(define bind-cont (lambda (v f)
                    (lambda (k)
                      (v (lambda (w) ((f w) k))))))
(define return-cont (lambda (v)
                      (lambda (k) (k v))))

(define m-cont
  (monad bind-cont
         return-cont
         #f
         #f))

(define bind-state (lambda (v f)
                     (lambda (s) (let ((vs (v s)))
                                   (let ((vn (car vs))
                                         (sn (cdr vs)))
                                     ((f vn) sn))))))
(define return-state (lambda (v) (lambda (s) `(,v . ,s))))

(define m-state
  (monad bind-state
         return-state
         #f
         #f))

(define (get-state s) `(,s . ,s))
(define (put-state new-s) (lambda (s) `(_ . ,new-s)))

(define bind-writer (lambda (v f)
                      (let ((mb (f (car v))))
                        `(,(car mb) . ,(append (cdr v) (cdr mb))))))
(define return-writer (lambda (v) `(,v . ())))

(define m-writer
  (monad bind-writer
         return-writer
         #f
         #f))

(define (tell-writer to-write) `(_ . (,to-write)))

(define-syntax with-m
  (syntax-rules (<- return)
    ((_ monad var <- mv rest ...) ((binder monad) mv (lambda (var) (with-m monad rest ...))))
    ((_ monad var <-- mv rest ...) ((binder monad) ((returner monad) mv) (lambda (var) (with-m monad rest ...))))
    ((_ monad (return v)) ((returner monad) v))
    ((_ monad mv) mv)))
