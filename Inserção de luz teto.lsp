;;Objetvo: Desenhar um ponto de luz centralizdo no comodo.
;;Autor: Guilherme Alves Araujo
;;Data: 01/05/19


;Função principal.
;Insere um ponto de luz no meio do cômodo.
(defun c:pluz()
	(guardaVariaveis)
	(setq *error* erroPadrao)
	(pontoInsercao)
	(luminariaInsercao pontoIn)	
	(restauraVariaveis)
)

;Cria uma mensagem de erro padrão.
(defun erroPadrao(erroMensagem)
	(setq *error* erroOriginal)
	(restauraVariaveis)
	(prompt "\nComando cancelado!")
)

;Guarda os valores das variáveis de ambiente.
(defun guardaVariaveis()
	(setq snap (getvar "osmode"))
	(setq erroOriginal *error*)	;*error* = variavel padrão que guarda os erros do CAD.
	(setq layerCorrente (getvar "clayer"))
  	(setq textoPadrao (getvar "textstyle"))
)

;restaura os valores da variáveis de ambiente.
(defun restauraVariaveis()
	(setvar "osmode" snap)
	(setvar "clayer" layerCorrente)
  	(setvar "textstyle" textoPadrao)
  	(setvar *error* erroOriginal)
)

;Define um ponto para a inserção do bloco de luminária.
(defun pontoInsercao()
	(setq pIn1 (getpoint "\nSelecione um vertice do comodo: "))
	(setq pIn2 (getpoint "\nSelecione o ponto oposto ao anterior: "))
	(setq anguloIn (angle pIn1 pIn2))
	(setq distIn (/ (distance pIn1 pIn2) 2))
	(setvar "osmode" 0)

	(setq pontoIn (polar pIn1 anguloIn distIn))
)


;Inseri um bloco de luminária com as respectivas anotações.
(defun luminariaInsercao(centro)

   ;Insere a porta.
  	   (command "_insert" "D:/Guilherme.doc/Blocos/Blocos Gui/Blocos dinâmicos/Elétrica/Luz din" "_s" "1" "_r" "0" centro)
	   (princ)

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
			(if (> desligado 0)		;Verifica se o layer esta "desligado".
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
