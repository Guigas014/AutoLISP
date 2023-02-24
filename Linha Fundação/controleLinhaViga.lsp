(defun controlLineViga()

  (setq caixa (load_dialog "Linha Fundação/caixaLinhaViga.dcl"))
  (if (not (new_dialog "caixa_viga" caixa)) (exit))

  

  ;Tipo de Viga
  (setq tipo "externa")
  (set_tile "tipoViga" "externa")
  (action_tile "tipoViga" "(setq tipo $value)")

  ;Posição da Viga
  (setq posicao "horizontal")
  (set_tile "posicaoViga" "horizontal")
  (action_tile "posicaoViga" "(setq posicao $value)")
;;;  (action_tile "posicaoViga" "(mudaEstadoDirecao)")
  
  
  
  
  ;Direção da Linha Horizontal
  (setq direcao "cima")
  (set_tile "direcao" "cima")
  (action_tile "direcao" "(setq direcao $value)")

  

  ;Estado inicial dos radios
;;;  (mode_tile "esquerda" 1)
;;;  (mode_tile "direita" 1)

  ;Ação dos radios
;;;  (action_tile "cima" "(setq direcao $value)")
;;;  (action_tile "baixo" "(setq direcao $value)")
;;;  (action_tile "esquerda" "(setq direcao $value)")
;;;  (action_tile "direita" "(setq direcao $value)") 


  ;Imagens.
  ;Para criar uma imagem sld - no própio AutoCAD digite no
  ;termimal "mslide" e siga as orientações.

  ;Array com o numero das imagens
  (setq images (list "icon_image1" "icon_image2" "icon_image3" "icon_image4"))

  (foreach img images
	(setq Image (strcat "Linha Fundação/Imagens/imagem" (substr img 11))) 
  
  	(setq x (dimx_tile img)
	      y (dimy_tile img)
  	)
  	(start_image img)
  	(fill_image 0 0 x y 0)
  	(slide_image -20 -55 (+ x 40) (+ y 40) Image)		;(slide_image originX originY Width Height Arquivo) 
  	(end_image)

  )
  
  
  ;Ação dos botões
  (action_tile "accept" "(done_dialog 1)")
  (action_tile "cancel" "(done_dialog 2)")

  
  ;finalização
  (setq valorFinal (start_dialog))		;start_dialog - Inicia a caixa de diálogo.
  (unload_dialog caixa)  

;;;  (if (= valorFinal 1)
;;;    (cond
;;;      (
;;;	(= direcao "cima")
;;;	(setq direcao "cima")
;;;        (princ direcao)
;;;      )
;;;      (
;;;	(= direcao "baixo")
;;;	(setq direcao "baixo")
;;;        (princ direcao)
;;;      )
;;;      (
;;;	(= direcao "esquerda")
;;;	(setq direcao "esquerda")
;;;        (princ direcao)
;;;      )
;;;      (
;;;	(= direcao "direita")
;;;	(setq direcao "direita")
;;;        (princ direcao)
;;;      )
;;;    )
;;;  )
  
  ;Teste do botão cancelar
  (if (= valorFinal 2)
	  (progn
	    (alert "\nComando cancelado pelo usuário!\n")
	    (exit)	    
	  )	  
  )
 	
)


(defun mudaEstadoDirecao()
  (setq opcao $value)
  
  (cond
    (
    	(= opcao "vertical")
    	(mode_tile "esquerda" 0)
	(mode_tile "direita" 0)
        (mode_tile "cima" 1)
	(mode_tile "baixo" 1)
    )
    (
    	(= opcao "horizontal")
    	(mode_tile "esquerda" 1)
	(mode_tile "direita" 1)
        (mode_tile "cima" 0)
	(mode_tile "baixo" 0)
    )
  )
)



