;;Objetvo: Criar os layers principais do in�cio do projeto.
;;Autor: Guilherme Alves Araujo
;;Data: 24/01/23


;fun��o principal
(defun c:initlayer()

	(setq layerNames (list "Parede" "Muro" "Cota" "Corte" "Janelas" "Movies" "ProjecaoTelha"))
	(setq layerColors (list 6 3 1 2 3 2 1))
  	(setq layerLineTypes (list "" "" "" "" "" "" "hiddenx2"))
  	(setq cont 0)
	

  	(while (< cont 7)
	  	(setq testLayer (tblsearch "layer" (nth cont layerNames)))	
	
		(if (= testLayer nil)
	  		(progn
	    			(command "layer"
					"n"  (nth cont layerNames)
			     		"c"  (nth cont layerColors) (nth cont layerNames)
			     		"lt" (nth cont layerLineTypes) (nth cont layerNames) ""
    	    			)
	    			;;(princ)
	  		)
	  		(progn	
	  			(alert "O layer j� existe!")
	    			;;(princ testLayer)
	  		)
		)

	  	(setq cont (+ cont 1))
	) 

	(alert "Layers criados com sucesso!")  
  	
)
