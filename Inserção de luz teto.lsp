;;Objetvo: Desenhar um ponto de luz centralizdo no comodo.
;;Autor: Guilherme Alves Araujo
;;Data: 01/05/19


;Fun��o principal.
;Insere um ponto de luz no meio do c�modo.
(defun c:pluz()
	(guardaVariaveis)
	(setq *error* erroPadrao)
	(pontoInsercao)
	(luminariaInsercao pontoIn)	
	(restauraVariaveis)
)

;Cria uma mensagem de erro padr�o.
(defun erroPadrao(erroMensagem)
	(setq *error* erroOriginal)
	(restauraVariaveis)
	(prompt "\nComando cancelado!")
)

;Guarda os valores das vari�veis de ambiente.
(defun guardaVariaveis()
	(setq snap (getvar "osmode"))
	(setq erroOriginal *error*)	;*error* = variavel padr�o que guarda os erros do CAD.
	(setq layerCorrente (getvar "clayer"))
  	(setq textoPadrao (getvar "textstyle"))
)

;restaura os valores da vari�veis de ambiente.
(defun restauraVariaveis()
	(setvar "osmode" snap)
	(setvar "clayer" layerCorrente)
  	(setvar "textstyle" textoPadrao)
  	(setvar *error* erroOriginal)
)

;Define um ponto para a inser��o do bloco de lumin�ria.
(defun pontoInsercao()
	(setq pIn1 (getpoint "\nSelecione um vertice do comodo: "))
	(setq pIn2 (getpoint "\nSelecione o ponto oposto ao anterior: "))
	(setq anguloIn (angle pIn1 pIn2))
	(setq distIn (/ (distance pIn1 pIn2) 2))
	(setvar "osmode" 0)

	(setq pontoIn (polar pIn1 anguloIn distIn))
)


;Inseri um bloco de lumin�ria com as respectivas anota��es.
(defun luminariaInsercao(centro)

   ;Insere a porta.
  	   (command "_insert" "D:/Guilherme.doc/Blocos/Blocos Gui/Blocos din�micos/El�trica/Luz din" "_s" "1" "_r" "0" centro)
	   (princ)

)



;Verifica a exist�ncia de um layer e se ele esta desligado.
(defun verificaLayer (nome cor)
	(setq layer (tblsearch "layer" nome))

	(if (= layer nil)	;Verifica se o layer n�o existe.
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
