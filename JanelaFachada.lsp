;;Objetvo: Desenhar os detalhes das portas e janelas da fachada.
;;Autor: Guilherme Alves Araujo
;;Data: 04/05/19



;Função principal.
(defun c:janelaFachada(/ pontos pontos1)

  ;Buscar o ponto inicial e as dimensões.
  (setq obj (entget (car (entsel "\nSelecione a polyline do contorno da janela: ")))
	;p (cdr (assoc 10 obj))
;;;	larg (getreal "\nQual a largura: ")
;;;	alt (getreal "\nQual a altura: ")	
  )


  ;Pegar todos os pontos do contorno.
  (foreach n obj
    
    (setq teste (car n))
    
    (if (= teste 10)
	(setq pontos (cons (cdr n) pontos))
      )
    )

  ;Inverte a ordem dos pontos na lista.
  (foreach n pontos
    (setq pontos1 (cons n pontos1))
    )
  ;Setar os pontos em variáveis.
  (setq pr1 (nth 0 pontos1)
        pr2 (nth 1 pontos1)
	pr3 (nth 2 pontos1)
	pr4 (nth 3 pontos1)
	)

  ;Teste para setar a largura e a altura da janela.

  ;Setando a largura.
  (if (/= (car pr1) (car pr2))
    (progn
      (setq larg (- (car pr1) (car pr2)))
      (if (< larg 0)
	(setq larg (* larg -1))
      )
    )
    (progn
      (setq larg (- (car pr2) (car pr3)))
      (if (< larg 0)
	(setq larg (* larg -1))
      )
    )
  )

  ;Setando a altura
  (if (/= (cadr pr1) (cadr pr2))
    (progn
      (setq alt (- (cadr pr1) (cadr pr2)))
      (if (< alt 0)
	(setq alt (* alt -1))
      )
    )
    (progn
      (setq alt (- (cadr pr2) (cadr pr3)))
      (if (< alt 0)
	(setq alt (* alt -1))
      )
    )
  )
    
  

  ;Teste para descobrir a posição do contorno da janela.
  (cond
    ;primeira condição.
    (
     (and (< (car pr1) (car pr2)) (> (cadr pr1) (cadr pr3)))

     (setq angulo1 0
	   angulo2 (/ (* 3 pi) 2)
	   angulo3 pi
	   )
     (desenhatracosPrincipais)
     (desenhaDetalhes pp1 pp3)
    )

    ;segunda condição.
    (
     (and (< (car pr1) (car pr2)) (< (cadr pr1) (cadr pr3)))

     (setq angulo1 0
	   angulo2 (/ pi 2)
	   angulo3 pi
	   )
     (desenhatracosPrincipais)
     (desenhaDetalhes pp1 pp3)
    )
    
    ;terceira condição.
    (
     (and (> (car pr1) (car pr2)) (> (cadr pr1) (cadr pr3)))

     (setq angulo1 pi
	   angulo2 (/ (* 3 pi) 2)
	   angulo3 0
	   )
     (desenhatracosPrincipais)
     (desenhaDetalhes pp1 pp3)
     
    )

    ;quarta condição.
    (
     (and (> (car pr1) (car pr2)) (< (cadr pr1) (cadr pr3)))

     (setq angulo1 pi
	   angulo2 (/ pi 2)
	   angulo3 0
	   )
     (desenhatracosPrincipais)
     (desenhaDetalhes pp1 pp3)
    )

    ;default.
    (
     (t "\nPolyline inválida!")
    )
  )
 
 (princ) 
)


(defun desenhatracosPrincipais()

    (setq pp1 (polar pr1 angulo1 (/ larg 4))
          pp2 (polar pr1 angulo1 (/ larg 2))
	  pp3 (polar pp2 angulo1 (/ larg 4))
	  )

    (entmake (list (cons 0 "line") (cons 10 pp1) (cons 11 (polar pp1 angulo2 alt))))
    (entmake (list (cons 0 "line") (cons 10 pp2) (cons 11 (polar pp2 angulo2 alt))))
    (entmake (list (cons 0 "line") (cons 10 pp3) (cons 11 (polar pp3 angulo2 alt))))
    (princ)
)



(defun desenhaDetalhes(pini1 pini2)

  ;Segundo detalhe.
  (setq p1 (polar pini1 angulo2 0.03)
	p2 (polar p1 angulo1 (- (/ larg 4) 0.03))
	p3 (polar p2 angulo2 (- alt 0.06))
	p4 (polar p3 angulo3 (- (/ larg 4) 0.03))
	)
  
  (entmake (list (cons 0 "line") (cons 10 p1) (cons 11 p2)))
  (entmake (list (cons 0 "line") (cons 10 p2) (cons 11 p3)))
  (entmake (list (cons 0 "line") (cons 10 p3) (cons 11 p4)))
  

  ;Terceiro detalhe.
  (setq p5 (polar pini2 angulo2 0.03)
	p6 (polar p5 angulo3 (- (/ larg 4) 0.03))
	p7 (polar p6 angulo2 (- alt 0.06))
	p8 (polar p7 angulo1 (- (/ larg 4) 0.03))
	)

  (entmake (list (cons 0 "line") (cons 10 p5) (cons 11 p6)))
  (entmake (list (cons 0 "line") (cons 10 p6) (cons 11 p7)))
  (entmake (list (cons 0 "line") (cons 10 p7) (cons 11 p8)))

  
  ;Primeiro detalhe.
  (setq p9 (polar p1 angulo3 0.03)
	p10 (polar p9 angulo3 (- (/ larg 4) 0.06))
	p11 (polar p10 angulo2 (- alt 0.06))
	p12 (polar p11 angulo1 (- (/ larg 4) 0.06))
	)

  (entmake (list (cons 0 "line") (cons 10 p9) (cons 11 p10)))
  (entmake (list (cons 0 "line") (cons 10 p10) (cons 11 p11)))
  (entmake (list (cons 0 "line") (cons 10 p11) (cons 11 p12)))
  (entmake (list (cons 0 "line") (cons 10 p12) (cons 11 p9)))

  
  ;Quarto detalhe.
  (setq p13 (polar p5 angulo1 0.03)
	p14 (polar p13 angulo1 (- (/ larg 4) 0.06))
	p15 (polar p14 angulo2 (- alt 0.06))
	p16 (polar p15 angulo3 (- (/ larg 4) 0.06))
	)

  (entmake (list (cons 0 "line") (cons 10 p13) (cons 11 p14)))
  (entmake (list (cons 0 "line") (cons 10 p14) (cons 11 p15)))
  (entmake (list (cons 0 "line") (cons 10 p15) (cons 11 p16)))
  (entmake (list (cons 0 "line") (cons 10 p16) (cons 11 p13)))


  
)
  