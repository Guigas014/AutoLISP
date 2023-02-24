;;Objetvo: Desenhar paredes, laje, portas e janelas de um corte.
;;Autor: Guilherme Alves Araujo
;;Data: 01/05/19


;função principal
(defun c:desenhaCorte(/ pontos targets target )
  (load "VerificaLayer.lsp")
  
 (setq cont 1
       cont1 1
       linhaCorte nil
       opcao (list "Parede" "POrta" "Janela")
       opAtual (nth 0 opcao)
       )

 ;Não está repetindo.
 (while (= cont1 1)
   (setq linhaCorte (entget (car (entsel "\nSelecione a linha de corte: "))))
   (setq testeLinha linhaCorte)
   
   (if testeLinha
     (setq cont1 0)
   )
      

 )
 
	
  
 (while (/= cont 0)
   
    (initget 128)
    (setq ponto (getpoint "\nSelecione as interseções das paredes com a linha de corte: "))

	(if (= 'LIST (type ponto))
	  	(progn
		  (setq pontos (cons ponto pontos))

		  ;Desenha os pontos de referência, para não selecionar repetido.
		  (setvar "pdmode" 35)
		  (setq target (entmake (list (cons 0 "point") (cons 62 1) (cons 10 ponto))))
		  (setq targets (cons (entlast) targets)) 
		  
		  (setq cont (1+ cont))
		  (princ)

		)


	  	
	  	(if (= ponto nil)	
		    (progn

		      (foreach n targets
			(entdel n)			;Para esse comando funcionar devemos usar o "name" da entidade.
		      )

		      (setq cont 0)
		      (setvar "pdmode" 0)

		      (derivaDistancia)
		     
        	    )
		)

	  
	       
	) 
   
 )

)



;;;-----------------------------------------------------------------------------------------------------------------------------------------------;;


(defun derivaDistancia(/ vetorXY )

  ;Testa a posição do corte.
  (setq xi (cadr (assoc 10 linhaCorte))
  	yi (caddr (assoc 10 linhaCorte))
	xf (cadr (assoc 11 linhaCorte))
	yf (caddr (assoc 11 linhaCorte))
	)

 ;Vertical 
;;; (if (= yi yf)
;;;   (progn
;;;	(foreach n pontos
;;;	  (setq vetorXY (cons (car n) vetorXY))
;;;	)
;;;   )
;;;   (progn
;;;     (if (/= yi yf)
;;;	(progn
;;;	  (foreach n pontos
;;;	    (setq vetorXY (cons (cadr n) vetorXY))
;;;	  )
;;;	)
;;;        (prompt "Erro na seleção da linha de corte!")
;;;     )   
;;;   )
;;; )

 (cond
   (
    (/= yi yf)
        (foreach n pontos
	  (setq vetorXY (cons (cadr n) vetorXY))
	)
   )
   (
    (= yi yf)
        (foreach n pontos
	 (setq vetorXY (cons (car n) vetorXY))
	)
   )
   (t  (princ "Erro na seleção da linha de corte! - 2"))
 )
  

 ;Setar as distancias
 (setq aux (nth 0 vetorXY)
       distancias nil
       )
 
 (foreach n vetorXY
   (setq distancias (cons (- aux n) distancias))
   (setq aux n)
 )

 (setq distancias (cons 0 distancias))

 ;inverte a lista
 ;(setq dist nil)
  
;;; (foreach n distancias
;;;   (setq dist (cons n dist))
;;; )

 ;(princ distancias)
  
 (desenhaParede)

)



;;;-----------------------------------------------------------------------------------------------------------------------------------------------;;


(defun desenhaParede(/ pSup pInf )

  ;Pé Direito
  (setq pDirPadrao "2.70")
  (setq pDireito (getreal (strcat "Digite o pé direito <" pDirPadrao ">: ")))

  (if (not pDireito) (setq pDireito (atof pDirPadrao)))
  

  ;Questiona laje, forro ou nada.
  (setq Teto (list "Laje" "Forro" "Nada"))		;Vetor do opAtual1.

  (if (not opAtual1)
    (progn
      (setq opAtual1 (nth 0 Teto))
      ;(setq opTeto "L")
    )
    ;Se existir.
  )

  
  (initget 128)
  (setq opTeto (getkword  (strcat "Especifique o tipo de teto [Laje/Forro/Nada] <" opAtual1 ">: ")))

  
  	;;Condicional que funciona apenas se o valor de opTeto for nil, ou seja, apertei ENTER.
  	(if (not opTeto)
    	  (progn
	    (cond
	      ((= opAtual1 "Laje") (setq opTeto "L"))
	      ((= opAtual1 "Forro") (setq opTeto "F"))
	      ((= opAtual1 "Nada") (setq opTeto "N"))
	      (t (princ "Opção Inválida!"))
	    )
          )
        )
  

  	(cond
	  (
	   (= (strcase opTeto) "L")
	   (setq opAtual1 (nth 0 Teto))
	   (setq esp (getreal (strcat "Informe a espessura da Laje <" (setq LajPadrao "0.10") ">: ")))
	   (if (not esp) (setq esp (atof LajPadrao)))
	  )
	  (
	   (= (strcase opTeto) "F")
	   (setq opAtual1 (nth 1 Teto))
	   (setq esp (getreal (strcat "Informe a espessura do Forro <" (setq ForrPadrao "0.03") ">: ")))
	   (if (not esp) (setq esp (atof ForrPadrao)))
	  )
	  (
	   (= (strcase opTeto) "N")
	   (setq opAtual1 (nth 2 Teto))
	  )
	  (t (princ "Opção Inválida!"))
        )
  

  (setq pontoIn (getpoint "Clique no ponto de inserção: "))
   

  
  ;Desenha linhas das paredes.
  (verificaLayer "Parede" "6")
  
  (setq pSup1 (polar pontoIn (/ pi 2) pDireito)				;Ponto final da primeira linha desenhada.
	pInf1 pontoIn
	)			
  

  (setq linhas nil)

 
  (foreach n distancias
    
    	(if (/= n 0)
	  
	    (setq pInf (polar pInf1 0 n)
	          pSup (polar pSup1 0 n)
		  )
	      
	    (setq pInf pInf1
	          pSup pSup1
	          )
	    ) 
	  
    	(setq linhas (cons (entmake (list (cons 0 "line") (cons 8 "Parede") (cons 10 pInf) (cons 11 pSup))) linhas))

    	(setq pSup1 pSup
	      pInf1 pInf
	)
    
  )

  
  ;Desenha base e laje (ou forro)
  (setq xTeste1 (cadr (assoc 10 (nth 0 linhas)))
        xTeste2 (cadr (assoc 10 (nth 0 linhas)))
        entExterna1 (nth 0 linhas)
	entExterna2 (nth 0 linhas)
	)
  
  (foreach n linhas

    (setq xAux (cadr (assoc 10 n)))
    
    
    ;Analisa e seta a entidade externa 1.
    (if (> xTeste1 xAux)
      
	  (setq entExterna1 n
	        xTeste1 xAux
	       )
    )
    

    ;Analisa e seta a entidade externa 2.
    (if (< xTeste2 xAux)

	(setq entExterna2 n
	      xTeste2 xAux
	      )
    )
  )


  ;Base
  (setq pBase1 (cdr (assoc 10 entExterna1))
	pBase2 (cdr (assoc 10 entExterna2))
	)

  (setq pBaseIni (polar pBase1 pi 0.5)
	pBaseFim (polar pBase2 0  0.5)
	)

  (entmake (list (cons 0 "line") (cons 8 "Parede") (cons 10 pBaseIni) (cons 11 pBaseFim)))

  (setq baseOff (polar pBase1 (/ (* 3 pi) 2) 1)) 

  (command "._offset" 0.03 (entlast) baseOff "")
 

  
  ;Laje ou Forro
  (setq pLaje1 (cdr (assoc 11 entExterna1))
	pLaje2 (cdr (assoc 11 entExterna2))
	pLajeTR1 (polar pLaje1 0  0.02)
	pLajeTR2 (polar pLaje2 pi 0.02)
	)

  ;pergunta se é laje ou forro ou nada.
  (cond
	  (
	   (= (strcase opTeto) "L")
	   
	   	(entmake (list (cons 0 "line") (cons 8 "Parede") (cons 10 pLaje1) (cons 11 pLaje2)))

 	   	(command "._offset" esp "_non" (entlast) "_non" "@0,-1" "")

  	   	(command "._trim" "" "f" pLajeTR1 pLajeTR2 "" "")
	  )
	  (
	   (= (strcase opTeto) "F")
	   
	   	(entmake (list (cons 0 "line") (cons 8 "Parede") (cons 10 pLaje1) (cons 11 pLaje2)))

 	   	(command "._offset" esp "_non" (entlast) "_non" "@0,-1" "")

  	   	;(command "._trim" "" "f" pLajeTR1 pLajeTR2 "" "")
	  )
	  (
	   (= (strcase opTeto) "N")
	   
	   	(entmake (list (cons 0 "line") (cons 8 "Parede") (cons 10 pLaje1) (cons 11 pLaje2)))
	  )
	  
	  (t (princ "Opção Inválida!"))
   )
   (setvar "clayer" "0")
  

  (princ)
)