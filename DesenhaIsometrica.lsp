;;Objetvo: Desenhar uma isometria a patir de uma planta baixa.
;;Autor: Guilherme Alves Araujo
;;Data: 11/05/26

(defun c:mki()

    ;Pegar todas as linha que serão desenhadas na isometria.
    (setq p1 (getpoint "\nPrimeiro canto da janela: "))
    (setq p2 (getcorner p1 "\nCanto oposto: "))

    (setq lines (ssget "W" p1 p2))

    (if lines (princ (strcat "\n" (itoa (sslength lines)) " objetos selecionados."))

    (princ "\nNenhum objeto selecionado."))

    ;Seta os dados: ponto de base e o nome da isometria.
    (setq basePoint (getpoint "\nEspecifique o ponto base: "))
    (setq name (getstring "\nDigite o nome da Isometria: "))
    ; (setq ang 315)

    (if (and lines basePoint) 
      (progn
        ;Rotaciona todas as linhas a 315 graus.
        (command "_ROTATE" lines "" basePoint 315)
    
        ;Cria o bloco com todas as linhas.
        (command "._-BLOCK" name basePoint lines "")

        ;Insere o bloco e muda a escala dos eixos X e Y.
        (command "._-INSERT" name basePoint 1.224 0.707 0.0)
      )
    )

    (princ "\nIsometria criada com sucesso!")
)


    ; ;Criar um bloco com todas as linhas.
    ; (entmake '((0 . "BLOCK") '(2 . "ISOMETRIA") '(70 . 0) '(10 basePoint)))
   
    ; ;Finaliza um bloco.
    ; (entmake '((0 . "ENDBLK")))


    ;Mudar as propriedades "Scale X" e "Scale Y" do bloco criado anteriormente.
    ; (entmake '((0 . "INSERT")
    ;          (2 . "ISOMETRIA")     ; Nome do bloco criado acima
    ;          (10 0.0 0.0 0.0)     ; Coordenada de inserção na tela (X Y Z)
    ;          (41 . 2.5)           ; >>> ESCALA X (scaleX = 2.5)
    ;          (42 . 1.5)           ; >>> ESCALA Y (scaleY = 1.5)
    ;          (43 . 1.0)           ; Escala Z (padrão = 1.0)
    ;         ))


 ;;Cria um bloco e coloca e entidade LINE dentro dele.
    ; (if lines
    ;     (progn
    ;     ;; 1. Converte a entidade padrão para objeto ActiveX (VLA-Object)
    ;     (setq objVla (vlax-ename->vla-object lines))
        
    ;     ;; 2. Acessa o banco de dados do desenho atual
    ;     (setq acadObj (vlax-get-acad-object))
    ;     (setq doc (vla-get-ActiveDocument acadObj))
    ;     (setq blocos (vla-get-Blocks doc))
        
    ;     ;; 3. Define o ponto base do bloco (ex: 0,0,0)
    ;     (setq basePoint (vlax-3d-point '(0.0 0.0 0.0)))
        
    ;     ;; 4. Cria a definição do bloco vazia
    ;     (setq novoBloco (vla-Add blocos basePoint "ISOMETRIA"))
        
    ;     ;; 5. Cria uma lista/array com o objeto da variável
    ;     (setq listaObjetos (vlax-make-safearray vlax-vbObject '(0 . 0)))
    ;     (vlax-safearray-put-element listaObjetos 0 objVla)
        
    ;     ;; 6. Copia o objeto para dentro do novo bloco
    ;     (vla-CopyObjects doc listaObjetos novoBloco)
        
    ;     ;; 7. Opcional: Apaga o objeto original do desenho
    ;     (vla-delete objVla)

    ;     (princ "\nObjeto movido para o bloco 'BlocoDaVariavel'!")
    ;     )
    ;     (princ "\nNenhum objeto selecionado.")
    ; )



