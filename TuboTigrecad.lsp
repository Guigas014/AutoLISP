;;Objetvo: Desenhar o tubo padrão TigreCAD conforme a bitola.
;;Autor: Guilherme Alves Araujo
;;Data: 26/04/26

(defun c:tt()
    ;Seleciona a linha de referência
    (setq obj (entget (car (entsel  "\n selecione a linha de referencia do tubo: "))))
    (princ obj)

    ;Definir os pontos extremos da linha de referência e seu angulo
    (setq pini (cdr (assoc 10 obj)))
    (setq pfim (cdr (assoc 11 obj)))
    (setq angulo (angle pini pfim))
    (princ angulo)
    (setq angulo1 (+ angulo (/ pi 2)))
    (setq angulo2 (+ angulo  (/ (* 3 pi) 2)))
    ; (setq angulo1 (* (/ 180 pi) angulo))
    ; (setq angulo2 (* (/ 180 pi) angulo))

    ;Escolhar a bitola do tubo
    (initget 1 "4 5 7 0 C")
    (setq typeTubo (getint "\nQual e a bitola do tubo <40(4), 50(5), 75(7), 100(0), CV(C)>: "))

    (cond 
        ((= typeTubo 4)
            (tubo40)
        )
        ((= typeTubo 5)
            (tubo50)
        )
        ((= typeTubo 7)
            (tubo75)
        )
        ((= typeTubo 0)
            (tubo100)
        )
        ((= typeTubo (strcase "C"))
            (tuboCV)
        )
        (t
            (prompt "\n Entrada invalida!")
            (princ)
        )
    )
)

;Desenha tubo de 40
(defun tubo40()
    ;Desenha as lihas externas
    ; (prompt "OK")
    (entmake (list (cons 0 "line") (cons 10 (polar pini angulo1 0.02)) (cons 11 (polar pfim angulo1 0.02)) (cons 62 2)))
    (entmake (list (cons 0 "line") (cons 10 (polar pini angulo2 0.02)) (cons 11 (polar pfim angulo2 0.02)) (cons 62 2)))

    ;Muda a linha do meio
    (entdel (cdr (assoc -1 obj)))
    (entmake (list (cons 0 "line") (cons 10 pini) (cons 11 pfim) (cons 62 1) (cons 6 "HIDDEN2") (cons 48 0.05)))t
)

;Desenha tubo de 50
(defun tubo50()
    ;Desenha as lihas externas
    ; (prompt "OK")
    (entmake (list (cons 0 "line") (cons 10 (polar pini angulo1 0.025)) (cons 11 (polar pfim angulo1 0.025)) (cons 62 2)))
    (entmake (list (cons 0 "line") (cons 10 (polar pini angulo2 0.025)) (cons 11 (polar pfim angulo2 0.025)) (cons 62 2)))

    ;Muda a linha do meio
    (entdel (cdr (assoc -1 obj)))
    (entmake (list (cons 0 "line") (cons 10 pini) (cons 11 pfim) (cons 62 1) (cons 6 "HIDDEN2") (cons 48 0.05)))t
)

;Desenha tubo de 75
(defun tubo75()
    ;Desenha as lihas externas
    ; (prompt "OK")
    (entmake (list (cons 0 "line") (cons 10 (polar pini angulo1 0.0375)) (cons 11 (polar pfim angulo1 0.0375)) (cons 62 2)))
    (entmake (list (cons 0 "line") (cons 10 (polar pini angulo2 0.0375)) (cons 11 (polar pfim angulo2 0.0375)) (cons 62 2)))

    ;Muda a linha do meio
    (entdel (cdr (assoc -1 obj)))
    (entmake (list (cons 0 "line") (cons 10 pini) (cons 11 pfim) (cons 62 1) (cons 6 "HIDDEN2") (cons 48 0.05)))t
)

;Desenha tubo de 100
(defun tubo100()
    ;Desenha as lihas externas
    ; (prompt "OK")
    (entmake (list (cons 0 "line") (cons 10 (polar pini angulo1 0.05)) (cons 11 (polar pfim angulo1 0.05)) (cons 62 2)))
    (entmake (list (cons 0 "line") (cons 10 (polar pini angulo2 0.05)) (cons 11 (polar pfim angulo2 0.05)) (cons 62 2)))

    ;Muda a linha do meio
    (entdel (cdr (assoc -1 obj)))
    (entmake (list (cons 0 "line") (cons 10 pini) (cons 11 pfim) (cons 62 1) (cons 6 "HIDDEN2") (cons 48 0.05)))t
)

;Desenha tubo de CV
(defun tuboCV()
    ;Desenha as lihas externas
    ; (prompt "OK")
    ; (entmake (list (cons 0 "line") (cons 10 (polar pini (/ pi 2) 0.02)) (cons 11 (polar pfim (/ pi 2) 0.02)) (cons 62 2)))
    ; (entmake (list (cons 0 "line") (cons 10 (polar pini (/ (* 3 pi) 2) 0.02)) (cons 11 (polar pfim (/ (* 3 pi) 2) 0.02)) (cons 62 2)))
   (entmake (list (cons 0 "line") (cons 10 (polar pini angulo1 0.02)) (cons 11 (polar pfim angulo1 0.02)) (cons 62 2)))
   (entmake (list (cons 0 "line") (cons 10 (polar pini angulo2 0.02)) (cons 11 (polar pfim angulo2 0.02)) (cons 62 2)))

    ;Muda a linha do meio
    (entdel (cdr (assoc -1 obj)))
    (entmake (list (cons 0 "line") (cons 10 pini) (cons 11 pfim) (cons 62 1) (cons 6 "DOTX2") (cons 48 0.01)))
)
