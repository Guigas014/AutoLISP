;;Objetvo: Desenhar os detalhes das portas e janelas da fachada.
;;Autor: Guilherme Alves Araujo
;;Data: 04/05/19



;Função principal.
(defun c:portaFachadateste( / a b larg alt)

;mudando o erro padrão.
(defun *error* (msg)
   (princ (strcat "\n" msg))
   ;(princ msg)
   (princ)
)


  
;(load "C:/Users/guilh/OneDrive/Área de Trabalho/Aulas de Lisp/Porta Fachada/controlPortaF.lsp")

;Para carregar outros arquivos sem especificar o caminho completo, como abaixo,
;devemos colocar todos os arquivos em uma pasta e indicar o caminho da mesma no Options do AutoCAD
;na opção Files -> Support File Search Path.
(load "Porta Fachada/controlPortaF.lsp")  
  


  ;Buscar o ponto inicial e as dimensões.

  
  (portaf)	;Chama a função responsável pela execução da caixa de diálogo.

  ;(setq msg "Comando cancelado pelo usuário2!")
  
  (setq obj (entget (car (entsel "\nSelecione a polyline do contorno da porta: ")))
	p (cdr (assoc 10 obj))
	larg (atof larg)		;Estou convertendo de sring para real as variaveis larg e alt que vem da cx de dialogo.
	alt (atof alt)	
  )


  ;Setar os pontos para desenhar as bordas.

  ;pega todos os X dos pontos do contorno.
  (foreach n obj
	(setq teste (car n))	;a variavel teste recebe o par associado para para testar se é 10 (ponto inicial).

    	(if (= teste 10)
	    (setq a (cons (cadr n) a))
	  ) 
  )

  ;inverte os valores da lista, para a ordem certa (3 2 1) (1 2 3).
  (foreach n a
	(setq b (cons n b))
    )

  ;setar o x do primeiro e do ultiomo ponto.
  (setq x1 (nth 0 b)
  	x4 (nth 3 b))
  

  ;testa qual x é maior, para descobrir se o contorno começou na direita ou esquerda.
  (if (> x1 x4)
    
	;pontos para esquerda.
  	(setq p1 (polar p pi 0.03)
	      p1 (polar p1 (/ pi 2) 0.03)
              p2 (polar p1 (/ pi 2) (- alt 0.06))
              p3 (polar p2 pi (- larg 0.06))
              p4 (polar p3 (/ (* 3 pi) 2) (- alt 0.06))
	)

    	(if (< x1 x4)
	

	   ;pontos para direita.
	   (setq p1 (polar p 0 0.03)
	         p1 (polar p1 (/ pi 2) 0.03)
		 p2 (polar p1 (/ pi 2) (- alt 0.06))
		 p3 (polar p2 0 (- larg 0.06))
		 p4 (polar p3 (/ (* 3 pi) 2) (- alt 0.06))
           )
	  
	   (progn
		(prompt "\nOs valores de x1 e x4 são iguais")
	     	(exit)
	     )
	   
	)
    	
  )

  (desenhaBordaPorta)
  (setaPontoPuxador)
  (desenhaPuxador)

  
)
 


  
  ;Desenhar as bordas.
  (defun desenhaBordaPorta()

    (setq c (entmakex (list (cons 0 "line")(cons 10 p1)(cons 11 p2))))
    (entmake (list (cons 0 "line")(cons 10 p2)(cons 11 p3)))
    (entmake (list (cons 0 "line")(cons 10 p3)(cons 11 p4)))
    (entmake (list (cons 0 "line")(cons 10 p4)(cons 11 p1)))

  ;(command "._move" c "" p1) ;testando o comando entmakex OK
    
  )
  


  
  
  ;Setar os pontos do puxador.
  (defun setaPontoPuxador()

    ;(initget 1 "D E")
    (setq lado (substr lado 1 1))		;Peguei a primeira letra da string da variavel lado da caixade dialogo.


    	(cond
		(
		 (and (= lado "D") (< x1 x4))
		 (direcaoEsquerda p3 p4)
		)

		(
		 (and (= lado "D") (> x1 x4))
		 (direcaoEsquerda p2 p1)
		)

		(
		 (and (= lado "E") (< x1 x4))
		 (direcaoDireita p2 p1)
		)

		(
		 (and (= lado "E") (> x1 x4))
		 (direcaoDireita p3 p4)
		)
		(
		 (t "\nPolyline inválida!")
		)
	  )
    )
    
    
	(defun direcaoDireita(ref2 ref1)
		(setq dist (distance ref2 ref1)
			dist (/ dist 2)
			p5 (polar ref2 (/ (* 3 pi) 2) dist)
			p5 (polar p5 0 0.10)
			p5 (polar p5 (/ (* 3 pi) 2) 0.40)
			p6 (polar p5 0 0.04)
			p7 (polar p6 (/ pi 2) 0.80)
			p8 (polar p7 pi 0.04)
		      )
	  )

    
    	(defun direcaoEsquerda(ref3 ref4)

	  	(setq dist (distance ref3 ref4)
			dist (/ dist 2)
			p5 (polar ref3 (/ (* 3 pi) 2) dist)
			p5 (polar p5 pi 0.10)
			p5 (polar p5 (/ (* 3 pi) 2) 0.40)
			p6 (polar p5 pi 0.04)
			p7 (polar p6 (/ pi 2) 0.80)
			p8 (polar p7 0 0.04)
		      )
	  )
    






  ;Desenhar o puxador.
  (defun desenhaPuxador()

  	;(setq obj2 (entmake (list (cons 0 "lwpolyline") (cons 10 p5) (cons 10 p6) (cons 10 p7) (cons 10 p8) (cons 11 p5)))) isso é um rec e está OK.
  	(entmake (list (cons 0 "line")(cons 10 p5)(cons 11 p6)))
  	(entmake (list (cons 0 "line")(cons 10 p6)(cons 11 p7)))
  	(entmake (list (cons 0 "line")(cons 10 p7)(cons 11 p8)))
  	(entmake (list (cons 0 "line")(cons 10 p8)(cons 11 p5)))
    	(princ)
   
    )
 











;Condicional if com argumento composto de OR e AND.
  
;;;	(if (or (and (= lado "D") (< x1 x4)) (and (= lado "E") (> x1 x4)))
;;;
;;;	  	  (setq dist (distance p3 p4)
;;;			dist (/ dist 2)
;;;			p5 (polar p3 (/ (* 3 pi) 2) dist)
;;;			p5 (polar p5 pi 0.10)
;;;			p5 (polar p5 (/ (* 3 pi) 2) 0.40)
;;;			p6 (polar p5 pi 0.04)
;;;			p7 (polar p6 (/ pi 2) 0.80)
;;;			p8 (polar p7 0 0.04)
;;;		  )
;;;	  
;;;	  	  (if (or (and (= lado "E") (< x1 x4)) (and (= lado "D") (> x1 x4)))
;;;
;;;			 (setq dist (distance p2 p1)
;;;			       dist (/ dist 2)
;;;			       p5 (polar p2 (/ (* 3 pi) 2) dist)
;;;			       p5 (polar p5 0 0.10)
;;;			       p5 (polar p5 (/ (* 3 pi) 2) 0.40)
;;;			       p6 (polar p5 0 0.04)
;;;			       p7 (polar p6 (/ pi 2) 0.80)
;;;			       p8 (polar p7 pi 0.04)
;;;		      )
;;;
;;;		    ) 
;;;	
;;;	  )
  



