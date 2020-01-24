;;Objetvo: Desenhar a linha de dimensionamento. DIST DISTLIN
;;Autor: Guilherme Alves Araujo
;;Data: 23/04/19

;função principal
(defun c:ldim()
  (guardaVariaveis)
  (setq	p1     (getpoint "\nClique no primeiro ponto: ")
	p2     (getpoint "\nClique no segundo ponto: ")
	dist1  (distance p1 p2)
	dist2  (/ (distance p1 p2) 2)
	angulo (angle p1 p2)
	centro (polar p1 angulo dist2)
	txt (rtos dist1 2 0)
  )

  ;Desenha a linha
  (verificaLayer "DISTLIN" "7") 
  (command "._line" p1 p2 "")
  (setvar "clayer" layerCorrente)

  ;Insere o texto
  (verificaLayer "DIST" "7")
  (command "._text" "j" "mc" centro 1.5  (* (/ 180 pi) angulo) txt "")
  (restauraVariaveis)
  (princ)
)







;Guarda os valores das variáveis de ambiente.
(defun guardaVariaveis ()
  (setq snap (getvar "osmode"))
  (setq erroOriginal *error*)		;*error* = variavel padrão que guarda os erros do CAD.
  (setq layerCorrente (getvar "clayer"))
)

;restaura os valores da variáveis de ambiente.
(defun restauraVariaveis ()
  (setvar "osmode" snap)
  (setvar "clayer" layerCorrente)
)

;Verifica a existência de um layer e se ele esta desligado.
(defun verificaLayer (nome cor)
	(setq layer (tblsearch "layer" nome))

	(if (= layer nil)	;Verifica se o layer não existe.
		(progn 
			(command "layer" "n" nome "c" cor nome "")	;cria um layer.
			(setvar "clayer" nome)		;coloca o layer criado como corrente.
			)
		(progn
			(setq desligado (cdr (assoc 62 layer)))
			(if (> desligado 0)		;Verifica se o layer esta "ligado".
				(progn
					(setvar "clayer" nome)	;coloca o layer como corrente.
				)
				(progn
					(command "layer" "on" nome "")	;Ativa o layer desligado.
					(command "clayer" nome)		;coloca o layer como corrente.
				)
			)
		)
	)
)