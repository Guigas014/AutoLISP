;;Objetvo: Desenha o telhado do corte lateral.
;;Autor: Guilherme Alves Araujo
;;Data: 22/02/23

(defun c:telhadocorte ()
  
	;Carrega o Verifica Layer
  	(load "VerificaLayer.lsp")
  
  	(guardaVariaveis)

  
	(setq pSuperior (getpoint "\nSelecione o ponto mais alta do telhado: ")
	      pInferior (getpoint "\nSelecione o ponto mais baixo do telhado: ")  
  	)
  
  	(initget 128)
  	(setq rufo (getkword "\nO telhado tem Rufo (S) ou (N): "))

  	(if (= (strcase rufo) "S")
		(setq largRufo (getreal "\nQual é a largura do Rufo: ")) 
	)
  
  	(initget 128)
  	(setq projecaoDupla (getkword "\nO telhado tem projeção nos dois lados (S) ou (N): "))

  
  	;Muda a posição do ponto mais alto.
	(if (= (strcase rufo) "S")
		(setq pSuperior (polar pSuperior (* (/ pi 2) 3) 0.17))
	  	(progn
			(if (= (strcase rufo) "N")
				(setq pSuperior (polar pSuperior (* (/ pi 2) 3) 0.11))
			  	(progn
					(alert "Opção incorreta!")
				  	(exit)
				)
			)
		)
	)
  	
	  
  	;Calcula a projeção do telhado se dupla ou não
  	(if (= (strcase projecaoDupla) "S")
		(progn
			(setq angulo (angle pSuperior pInferior))	
			(setq pInferior (polar pInferior angulo 0.50))	;Deslocamento do ponto	
		  	(setq pSuperior (polar pSuperior angulo -0.65)) 
		)
	  	(progn
			(if (= (strcase projecaoDupla) "N")
				(progn
					(setq angulo (angle pSuperior pInferior))	
					(setq pInferior (polar pInferior angulo 0.50))
				)
			  	(progn
					(alert "Opção incorreta!")
				  	(exit)
				)
			)
		)
	) 
  	

  	;Desativa o snap
  	(setvar "osmode" 0)

  	(verificaLayer "Telhado" "2")
  
  
  	;Desenha a Vigota
  	(if (= (strcase projecaoDupla) "N")
	  	(progn
			(setq linhaBase (entmake (list (cons 0 "line")(cons 62 3)
				       (cons 10 pSuperior)(cons 11 (polar pInferior angulo -0.50))))
			)

  			(setq pSuperiorVigotaTop (polar pSuperior (/ pi 2) 0.05))
  			(setq pInferiorVigotaTop (polar pInferior (/ pi 2) 0.05))
  			(setq linhaVigotaTop (entmake (list (cons 0 "line")(cons 62 3)
					(cons 10 pSuperiorVigotaTop)(cons 11 (polar pInferiorVigotaTop angulo -0.50))))
			)
		)
	  	(progn
			(setq linhaBase (entmake (list (cons 0 "line")(cons 62 3)(cons 10 pSuperior)(cons 11 pInferior))))

  			(setq pSuperiorVigotaTop (polar pSuperior (/ pi 2) 0.05))
  			(setq pInferiorVigotaTop (polar pInferior (/ pi 2) 0.05))
  			(setq linhaVigotaTop (entmake (list (cons 0 "line")(cons 62 3)
							    (cons 10 pSuperiorVigotaTop)(cons 11 pInferiorVigotaTop))))
		)
	)

  	
  	;Desenha a Telha
 	(setq pSuperiorTelhaBot (polar pSuperior (/ pi 2) 0.08))
  	(setq pInferiorTelhaBot (polar pInferior (/ pi 2) 0.08))
  	(entmake (list (cons 0 "line")(cons 62 2)(cons 10 pSuperiorTelhaBot)(cons 11 pInferiorTelhaBot)))

  	(setq pSuperiorTelhaTop (polar pSuperiorTelhaBot (/ pi 2) 0.03))
  	(setq pInferiorTelhaTop (polar pInferiorTelhaBot (/ pi 2) 0.03))
  	(entmake (list (cons 0 "line")(cons 62 2)(cons 10 pSuperiorTelhaTop)(cons 11 pInferiorTelhaTop)))

  
  	;Desenha o rufo
  	(if (= (strcase rufo) "S")
	  	(progn
			(setq pSuperiorRufoBot (polar pSuperiorTelhaTop (/ pi 2) 0.03))
			;(setq pInferiorRufoBot (polar pInferiorTelhaTop (/ pi 2) 0.03))
			(entmake (list (cons 0 "line")(cons 62 2)(cons 10 pSuperiorRufoBot)
				       (cons 11 (polar pSuperiorRufoBot angulo largRufo)))
			)

			(setq pSuperiorRufoTop (polar pSuperiorRufoBot (/ pi 2) 0.03))
			;(setq pInferiorRufoTop (polar pInferiorRufoBot (/ pi 2) 0.03))
			(entmake (list (cons 0 "line")(cons 62 2)(cons 10 pSuperiorRufoTop)
				       (cons 11 (polar pSuperiorRufoTop angulo largRufo)))
			)
		)
	)



  	;Fecha as bordas
  	(if (= (strcase projecaoDupla) "S")
		(progn
		  	;Fecha a borda inferior da Vigota
  			(entmake (list (cons 0 "line")(cons 62 3)(cons 10 pInferiorVigotaTop)(cons 11 pInferior)))
			;Fecha a borda superior da Vigota
  			(entmake (list (cons 0 "line")(cons 62 3)(cons 10 pSuperiorVigotaTop)(cons 11 pSuperior)))


  			;Fecha a borda superior do Telhado
  			(entmake (list (cons 0 "line")(cons 62 2)(cons 10 pSuperiorTelhaTop)(cons 11 pSuperiorTelhaBot)))
		)
	  	(progn
			;Fecha a borda inferior da Vigota
  			(entmake (list (cons 0 "line")(cons 62 3)
	      			(cons 10 (polar pInferiorVigotaTop angulo -0.50))
	       			(cons 11 (polar pInferior angulo -0.50)))
			)
		)
	)
  
	;Fecha a borda inferior do Telhado
  	(entmake (list (cons 0 "line")(cons 62 2)(cons 10 pInferiorTelhaTop)(cons 11 pInferiorTelhaBot)))

	;Fecha a borda do Rufo
	(if (= (strcase rufo) "S")
		(progn
			(entmake (list (cons 0 "line")(cons 62 2)
		       		(cons 10 (polar pSuperiorRufoTop angulo largRufo))
		       		(cons 11 (polar pSuperiorRufoBot angulo largRufo)))
			)
		)
	)

  
  
  
	;(princ obj)
  	(restauraVariaveis)
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