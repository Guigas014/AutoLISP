(defun portaf ()

  ;(setq teste 0)
  
  ;(while (= teste 0)
  
  ;;(setq cx1 (load_dialog "C:/Users/guilh/OneDrive/Área de Trabalho/Aulas de Lisp/Porta Fachada/CxPortaF.dcl"))	;Carrega o arquivo DCL.
  (setq cx1 (load_dialog "CxPortaF.dcl"))	;Carrega o arquivo DCL.
  (if (not (new_dialog "caixaPorta1" cx1)) (exit))		;Verifica se a caixa de dialogo em "dcl_id" existe. (IMPORTANTE!)

  ;(load "C:/Users/guilh/OneDrive/Área de Trabalho/Aulas de Lisp/Porta Fachada/PortaFachada1.lsp")

  ;Largura
;;;  (setq larg "0.70")					;Seta o valor da variavel que será usada.
;;;  (set_tile "largPorta" "0.70")				;Seta o valor a ser apresentado na cx.
;;;  (action_tile "largPorta" "(setq larg $value)")

  (setq largAntiga larg)
    
  (if largAntiga
	(progn
	  (setq larg (rtos largAntiga 2 2))
          (set_tile "largPorta" (rtos largAntiga 2 2))
	  )
    	(progn
	  (setq larg "0.70")
	  (set_tile "largPorta" "0.70")
	  )
    )
  (action_tile "largPorta" "(setq larg $value)")
   

    
    
  ;Altura
;;;  (setq alt "2.10")
;;;  (set_tile "altPorta" "2.10")
;;;  (action_tile "altPorta" "(setq alt $value)")

  (setq altAntiga alt)

  (if altAntiga
	(progn
	   (setq alt (rtos altAntiga 2 2))
	   (set_tile "altPorta" (rtos altAntiga 2 2))
	  )
        (progn
	  (setq alt "2.10")
	  (set_tile "altPorta" "2.10")
	  )
    )
  (action_tile "altPorta" "(setq alt $value)")
    
  
  ;Puxador
  (setq lado "Direito")
  (set_tile "opcaoPuxador" "Direito")
  (action_tile "opcaoPuxador" "(setq lado $value)")


  (action_tile "accept" "(done_dialog 1)")
  (action_tile "cancel" "(done_dialog 2)")
  
  
  ;finalização
  (setq valorFinal (start_dialog))		;start_dialog - Inicia a caixa de diálogo.
  (unload_dialog cx1)
  ;(if (= valorFinal 1) (portaFachadateste))


  ;Tratamento de erro.
  (if (= valorFinal 1)
	(progn
	    (if (<= (atof larg) 0)		;A cx manda uma string!!
	        (progn
		     (alert "Digite um valor válido para a largura!")
		     (setq larg (atof larg)
		     	    alt (atof alt))

		     (portaf)
		  )
	           
		   (if (<= (atof alt) 0)
		     (progn
		     	(alert "Digite um valor válido para a altura!")
		        (setq alt (atof alt)
		              larg (atof larg))		;a largura deve ser retornado novamente, pois é outra condição que está  sendo satisfeita.

		        (portaf)
		     )
		         ;(setq teste 1)		;Tira o controle do looping e volta para o lisp principal.
		     
		   )  
	    )
	)
    
        (if (= valorFinal 2)
	  (progn
	    (*error* "\nComando cancelado pelo usuário!!!!\n")
	    (exit)
	    	    
	    )
	  

	  )
    
  )


  
 )