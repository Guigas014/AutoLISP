;;Objetvo: Desenhar o X do projeto de referência.
;;Autor: Guilherme Alves Araujo
;;Data: 07/05/26

(defun c:xx()
    
    ; Pega dois pontos opostos no desenho
    (setq p1 (getpoint "\nClique no ponto esquerdo superior: "))
  
    (setq p2 (getcorner p1 "\nClique no ponto direito inferior: "))

    ;define os ponntos paralelos aos dos pontos anteriores
    (setq po1 (list (car p2) (cadr p1)))
    
    (setq po2 (list (car p1) (cadr p2)))

    ;Desenha o X
    (entmake (list (cons 0 "line") (cons 10 p1) (cons 11 p2) (cons 62 6)))
    (entmake (list (cons 0 "line") (cons 10 po1) (cons 11 po2) (cons 62 6)))

    (princ)
)
