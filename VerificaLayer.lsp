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