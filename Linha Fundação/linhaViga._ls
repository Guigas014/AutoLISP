;;Objetvo: Desenhar a linha central da viga do tamanho certo. Passando 50cm de cada lado.
;;Autor: Guilherme Alves Araujo
;;Data: 18/02/23


;função principal
(defun c:lineviga()

  ;Carrega o controle que gerência e abre a caixa de dialogo.
  (load "Linha Fundação/controleLinhaViga.lsp")

  ;Carrega o Verifica Layer
  (load "VerificaLayer.lsp")
  (guardaVariaveis)

  
  ;Pega o objeto da lihna
  (setq obj (entget (car (entsel "\Selecione a linha de referência da viga: "))))
  ;(prompt obj)

  
  ;Caixa de dialogo que recolhe dados para a inserção da linha.
  (controlLineViga)  
  (setq tipo (substr tipo 1 1))
  (setq position (substr posicao 1 1))
  (setq direction (substr direcao 1 1))


  
  ;Recolhe dados para a inserção da linha.
;;;  (initget 128)
;;;  (setq	tipo (getkword "\nA viga é interna[I] ou Externa[E]: "))
;;;
;;;  (initget 128)
;;;  (setq	position (getkword "\nQual a posião da viga? Horizontal[H] ou Vertical[V]: "))
;;;
;;;  ;(princ (list tipo position))
;;;
;;;  ;Testa se a viga esta na horizontal ou vertical
;;;  (cond
;;;    (
;;;      (= (strcase position) "H")
;;;    	(initget 128)
;;;    	(setq direction (getkword "\nInserir linha central acima[C] ou abaixo[B]: "))
;;;    	;(print direction)
;;;    )
;;;    (
;;;      (= (strcase position) "V")
;;;    	(initget 128)
;;;    	(setq direction (getkword "\nInserir linha central na esquerda[E] ou na direita[D]: "))
;;;        ;(print direction)
;;;    ) 
;;;    (   
;;;       (t "Posição inválida!")  	
;;;    )  
;;;  )
  	
  

  ;Seta o ponto inicial e o final conforme o especificado acima
  (setq pontoInicial (cdr (assoc 10 obj))
	pontoFinal (cdr (assoc 11 obj))
        xPontoInicial (cadr (assoc 10 obj))
        yPontoInicial (cadr (cdr (assoc 10 obj)))
	xPontoFinal (cadr (assoc 11 obj))
        yPontoFinal (cadr (cdr (assoc 11 obj)))
  )

  

  ;Se for horizontal: se acima y=y+0.075 se abaixo y=y-0.075 (y inicial e final)
  (if (= (strcase position) "H")
      (cond
	(
	  (= (strcase direction) "C")
	  (setq pontoInicial (polar pontoInicial (/ pi 2) 0.075))
	  (setq pontoFinal (polar pontoFinal (/ pi 2) 0.075))
	)
	(
	  (= (strcase direction) "B")
	  (setq pontoInicial (polar pontoInicial (/ (* 3 pi) 2) 0.075))
	  (setq pontoFinal (polar pontoFinal (/ (* 3 pi) 2) 0.075))
	)
      )
  )

  (if (= (strcase position) "H")
      (cond
      ;Se interno O xMenor x=x-0.575 xMaior x=x+0.575
      (
        (= (strcase tipo) "I")
        (if (< xPontoInicial xPontoFinal)
         (progn
            (setq pontoInicial (polar pontoInicial pi 0.575))
            (setq pontoFinal (polar pontoFinal 0 0.575))
         )
         (progn
     	    (setq pontoInicial (polar pontoInicial 0 0.575))
            (setq pontoFinal (polar pontoFinal pi 0.575))
         )
       )
     )
    
     ;Se externo O xMenor x=x-0.425 xMaior x=x+0.425
     (
       (= (strcase tipo) "E")
       (if (< xPontoInicial xPontoFinal)
         (progn
       	    (setq pontoInicial (polar pontoInicial pi 0.425))
            (setq pontoFinal (polar pontoFinal 0 0.425))
         )
         (progn
     	    (setq pontoInicial (polar pontoInicial 0 0.425))
            (setq pontoFinal (polar pontoFinal pi 0.425))
         )
       )
     )
    )
  )

  
  

  
  ;Se for vertical: se direita x=x+0.075 se esquerda x=x-0.075 (x inicial e final)
  (if (= (strcase position) "V")
      (cond
	(
	  (= (strcase direction) "E")
	  (setq pontoInicial (polar pontoInicial pi 0.075))
	  (setq pontoFinal (polar pontoFinal pi 0.075))
	)
	(
	  (= (strcase direction) "D")
	  (setq pontoInicial (polar pontoInicial 0 0.075))
	  (setq pontoFinal (polar pontoFinal 0 0.075))
        )
      )
  )
  (if (= (strcase position) "V")  
      (cond
      ;Se interno O yMenor y=y-0.575 xMaior y=y+0.0575
       (
         (= (strcase tipo) "I")
         (if (< yPontoInicial yPontoFinal)
          (progn
       	     (setq pontoInicial (polar pontoInicial (/ (* 3 pi) 2) 0.575))
             (setq pontoFinal (polar pontoFinal (/ pi 2) 0.575))
          )
          (progn
     	     (setq pontoInicial (polar pontoInicial (/ pi 2) 0.575))
             (setq pontoFinal (polar pontoFinal (/ (* 3 pi) 2) 0.575))
          )
        )
      )
    
      ;Se externo O xMenor y=y-0.425 yMaior y=x+0.425
      (
        (= (strcase tipo) "E")
        (if (< yPontoInicial yPontoFinal)
          (progn
       	    (setq pontoInicial (polar pontoInicial (/ (* 3 pi) 2) 0.425))
            (setq pontoFinal (polar pontoFinal (/ pi 2) 0.425))
          )
          (progn
     	    (setq pontoInicial (polar pontoInicial (/ pi 2) 0.425))
            (setq pontoFinal (polar pontoFinal (/ (* 3 pi) 2) 0.425))
          )
        )
      )
    )
  )

  ;Desativa o snap
  (setvar "osmode" 0)
  
  (desenhaLinhaCentral)

  
  ;;;Escreve o texto V-1
  (verificaLayer "TEXTO1" "2")

  ;Acha o ponto central da reta
  (setq distCentro (/ (distance pontoInicial pontoFinal) 2)
	angulo (angle pontoInicial pontoFinal)
	centro (polar pontoInicial angulo distCentro) 
  )

  ;Arrumar o angulo para o texto não ficar upsidedown.
  (if (and (> angulo (/ pi 2)) (<= angulo (/ (* 3 pi) 2)))
    	(setq angulo (- angulo pi))
  )

  ;Testa se o texto está na horizontal ou vertical para fazer o espaçamento correto.
  (cond
    (
	(= (strcase position) "H")
     	(setq centro (polar centro (/ pi 2) 0.40))
        (command "._text" "s" "R50" "j" "mc" centro (* (/ 180 pi) angulo) "V-1")
    )
    (
	(= (strcase position) "V")
     	(setq centro (polar centro pi 0.40))
        (command "._text" "s" "R50" "j" "mc" centro (* (/ 180 pi) angulo) "V-1")
    )	
  )


  (restauraVariaveis)
)


;Desenha a linha central
(defun desenhaLinhaCentral()
   (entmake (list (cons 0 "line")(cons 62 2)(cons 10 pontoInicial)(cons 11 pontoFinal)))
)



;Guarda os valores das variáveis de ambiente.
(defun guardaVariaveis ()
  (setq snap (getvar "osmode"))
  (setq erroOriginal *error*)		;*error* = variavel padrão que guarda os erros do CAD.
  (setq layerCorrente (getvar "clayer"))
  (setq textoCorrente (getvar "textstyle"))
  (setq corCorrente (getvar "cecolor"))
  (setq lineCorrente (getvar "celtype"))
  (setq escCorrente (getvar "celtscale"))
)

;restaura os valores da variáveis de ambiente.
(defun restauraVariaveis ()
  (setvar "osmode" snap)
  (setvar "clayer" layerCorrente)
  (setvar "textstyle" textoCorrente)
  (setvar "cecolor" corCorrente)
  (setvar "celtype" lineCorrente)
  (setvar "celtscale" escCorrente)
  (princ)
)