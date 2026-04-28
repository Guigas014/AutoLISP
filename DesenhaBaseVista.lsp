;;Objetvo: Desenhar a base de uma vista.
;;Autor: Guilherme Alves Araujo
;;Data: 26/04/26


;funcao principal
(defun c:dv(/ pontos targets target )
;   (load "VerificaLayer.lsp")
  
 (setq cont 1
       cont1 1
       linhaCorte nil
       opcao (list "Parede" "POrta" "Janela")
       opAtual (nth 0 opcao)
       )

 ;Nao esta repetindo.
 (while (= cont1 1)
   (setq linhaCorte (entget (car (entsel "\nSelecione uma linha da parede do registro: "))))
   (setq testeLinha linhaCorte)
   
   (if testeLinha
     (setq cont1 0)
   )
      

 )
 
	
  
 (while (/= cont 0)
   
    (initget 128)
    (setq ponto (getpoint "\nSelecione os pontos (em linha reta) para definir as distancias: "))

	(if (= 'LIST (type ponto))
	  	(progn
		  (setq pontos (cons ponto pontos))

		  ;Desenha os pontos de referencia, para nao selecionar repetido.
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

  ;Testa a posicao do corte.
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
;;;        (prompt "Erro na selecao da linha de corte!")
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
   (t  (princ "Erro na selecao da linha de referencia!"))
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
 (setq dist nil)
  
 (foreach n distancias
   (setq dist (cons n dist))
 )

 ;(princ distancias)
  
 (desenhaParede)

)



;;;-----------------------------------------------------------------------------------------------------------------------------------------------;;


(defun desenhaParede(/ pSup pInf )

  ;Pe Direito
  (setq pDirPadrao "2.70")
;   (setq pDireito (getreal (strcat "Digite o pe direito <" pDirPadrao ">: ")))

  (if (not pDireito) (setq pDireito (atof pDirPadrao)))
  

  (setq pontoIn (getpoint "Clique no ponto de insercao: "))
   

  
  ;Desenha linhas das paredes.
;   (verificaLayer "Parede" "6")
  
  (setq pSup1 (polar pontoIn (/ pi 2) pDireito)				;Ponto final da primeira linha desenhada.
	pInf1 pontoIn
	)			
  

  (setq linhas nil)

  ;Testa a direção que os pontos foram selecionados e desenha as linhas verticais
  (if (or (> xi xf) (> yi yf))
    (progn
     (foreach n dist
    
    	(if (/= n 0)
	  
	    (setq pInf (polar pInf1 0 n)
	          pSup (polar pSup1 0 n)
		  )
	      
	    (setq pInf pInf1
	          pSup pSup1
	          )
	    ) 
	  
    	(setq linhas (cons (entmake (list (cons 0 "line") (cons 62 1) (cons 10 pInf) (cons 11 pSup))) linhas))

    	(setq pSup1 pSup
	      pInf1 pInf
	    ) 
      )
    )
    (progn
     (foreach n distancias
    
    	(if (/= n 0)
	  
	    (setq pInf (polar pInf1 0 n)
	          pSup (polar pSup1 0 n)
		  )
	      
	    (setq pInf pInf1
	          pSup pSup1
	          )
	    ) 
	  
    	(setq linhas (cons (entmake (list (cons 0 "line") (cons 62 1) (cons 10 pInf) (cons 11 pSup))) linhas))

    	(setq pSup1 pSup
	      pInf1 pInf
	    ) 
     )
    )
  )

 
  ; (foreach n distancias
    
  ;   	(if (/= n 0)
	  
	;     (setq pInf (polar pInf1 0 n)
	;           pSup (polar pSup1 0 n)
	; 	  )
	      
	;     (setq pInf pInf1
	;           pSup pSup1
	;           )
	;     ) 
	  
  ;   	(setq linhas (cons (entmake (list (cons 0 "line") (cons 62 1) (cons 10 pInf) (cons 11 pSup))) linhas))

  ;   	(setq pSup1 pSup
	;       pInf1 pInf
	;     ) 
  ; )

  
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

  (entmake (list (cons 0 "line") (cons 62 1) (cons 10 pBase1) (cons 11 pBase2)))
 
  
  ;Laje ou Forro
  (setq pLaje1 (cdr (assoc 11 entExterna1))
	pLaje2 (cdr (assoc 11 entExterna2))
	pLajeTR1 (polar pLaje1 0  0.02)
	pLajeTR2 (polar pLaje2 pi 0.02)
	)

  (entmake (list (cons 0 "line") (cons 62 1) (cons 10 pLaje1) (cons 11 pLaje2)))

  ;Insere o texto VISTA 1
  (command "._text" "j" "tl" (polar pBase1 (/ (* 3 pi) 2) 0.20) 0.125 0 "VISTA 1" "")
  ; Muda a cor do último objeto criado
  (command "CHPROP" "L" "" "C" 3 "")

  ;Insere o texto esc 1:25
  (command "._text" "j" "tl" (polar pBase1 (/ (* 3 pi) 2) 0.40) 0.08 0 "esc 1:25" "")
  ; Muda a cor do último objeto criado
  (command "CHPROP" "L" "" "C" 1 "")

  (princ)
)
