;;Objetvo: Desenhar a linha de dimensionamento dos canos.
;;Autor: Guilherme Alves Araujo
;;Data: 06/05/19

;função principal
(defun c:ttubo()
  (load "VerificaLayer.lsp")
  
  (guardaVariaveis)
  (setq	p1     (getpoint "\nClique no primeiro ponto: ")
	p2     (getpoint "\nClique no segundo ponto: ")
	dist1  (distance p1 p2)
	dist2  (/ (distance p1 p2) 2)
	angulo (angle p1 p2)
	centro (polar p1 angulo dist2)
  )

  ;Arrumar o angulo para o texto não ficar upsidedown.
  (if (and (> angulo (/ pi 2)) (<= angulo (/ (* 3 pi) 2)))

    (setq angulo (- angulo pi))
    
    )

  
  ;Escolhe o tipo de linha.
  (initget 1 "100 75 40 H")
  (setq cano (getint "\nQual é o diâmetro do cano <100, 75, 40, Hidraulica>: "))  ;Coloquei getint e funcionou para o H!!
  
  (cond
    ((= cano 100)
     (cano100)
    )

    ((= cano 75)
     (cano75)
    )

    ((= cano 40)
     (cano40)
    )

    ((= cano (strcase "H"))
     (hidraulica)
     )

    (t
     (prompt "\nEntrada Inválida!")
     (princ)
    )
  )


 (restauraVariaveis)
  
)



;Desenha cano de 100.
  (defun cano100()
     	  ;Desenha a linha
	  (verificaLayer "Encanamento" "5")
    	  (setvar "osmode" 0)
	  (command "._line" p1 p2 "")
	  (setvar "clayer" layerCorrente)

	  ;Insere o texto
	  (verificaLayer "TEXTO1" "2")
	  (command "._text" "s" "R50" "j" "bc" centro (* (/ 180 pi) angulo) "%%C100" "")
	 
	  (princ)
    )


;Desenha cano de 75. (Terminar)
  (defun cano75()
     	  ;Desenha a linha
	  (verificaLayer "Encanamento" "5")
    	  (setvar "cecolor" "3")
    	  (setvar "osmode" 0)
	  (command "._line" p1 p2 "")

    	  (setvar "clayer" layerCorrente)
    	  (setvar "cecolor" corCorrente)
    
	  ;Insere o texto
	  (verificaLayer "TEXTO1" "2")
	  (command "._text" "s" "R50" "j" "bc" centro (* (/ 180 pi) angulo) "%%C75" "")
	 
	  (princ)
    )


;Desenha cano de 40. (Terminar)
  (defun cano40()
     	  ;Desenha a linha
	  (verificaLayer "Encanamento" "5")
    	  (setvar "osmode" 0)
    	  (setvar "cecolor" "1")
    	  ;(setvar "celtype" "HIDDEN2")
    	  (command "_linetype" "s" "HIDDEN2" "")
 	  (setvar "celtscale" 0.05)
	  (command "._line" p1 p2 "")
    
	  (restauraVariaveis)
	  
	  ;Insere o texto
	  (verificaLayer "TEXTO1" "2")
	  (command "._text" "s" "R50" "j" "bc" centro (* (/ 180 pi) angulo) "%%C40" "")
	  
	  (princ)
    )


;Desenha cano de hidraulica.
  (defun hidraulica()
     	  ;Desenha a linha
	  (verificaLayer "Encanamento" "5")
    	  (setvar "osmode" 0)
	  (command "._line" p1 p2 "")
    
	  (setvar "clayer" layerCorrente)

	  ;Insere o texto
          (setq txt (getstring "\nDigite o diâmentro: "))
	  (verificaLayer "TEXTO1" "2")
	  (command "._text" "s" "R50" "j" "bc" centro (* (/ 180 pi) angulo) (strcat "%%c" txt) "")
	 
	  (princ)
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

;;;;Cria uma mensagem de erro padrão.
;;;(defun erroPadrao(erroMensagem)
;;;	(setq *error* erroOriginal)
;;;	(restauraVariaveis)
;;;	(prompt "\nComando cancelado!")
;;;)



;Verifica a existência de um layer e se ele esta desligado.
;;;(defun verificaLayer (nome cor)
;;;	(setq layer (tblsearch "layer" nome))
;;;
;;;	(if (= layer nil)	;Verifica se o layer não existe.
;;;		(progn 
;;;			(command "layer" "n" nome "c" cor nome "")	;cria um layer.
;;;			(setvar "clayer" nome)		;coloca o layer criado como corrente.
;;;			)
;;;		(progn
;;;			(setq desligado (cdr (assoc 62 layer)))
;;;			(if (> desligado 0)		;Verifica se o layer esta "ligado".
;;;				(progn
;;;					(setvar "clayer" nome)	;coloca o layer como corrente.
;;;				)
;;;				(progn
;;;					(command "layer" "on" nome "")	;Ativa o layer desligado.
;;;					(command "clayer" nome)		;coloca o layer como corrente.
;;;				)
;;;			)
;;;		)
;;;	)
;;;)