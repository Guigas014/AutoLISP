caixaPorta1:dialog {
	label = "Porta Fachada";

	:row {
	     :boxed_column {
	     	label = "Dimensões";
	     	
		:edit_box {
			label = "Largura: ";
			key = "largPorta";
			width = 5;
			fixed_width = true;
			alignment = left; 
			
			
		}
		
		:edit_box {
			label = "Altura:    ";
			key = "altPorta";
			width = 5;
			fixed_width = true;
			alignment = left; 
		
		}
		spacer;
	     }
	     
	    
	     :boxed_radio_column {
		label = "Lado puxador";
		key = "opcaoPuxador";

		:radio_button {
			label = "Direito";
			key = "Direito";
		}
		:radio_button {
			label = "Esquerdo";
			key = "Esquerdo";
		}
		spacer;
	     }
	     spacer;
	}
	spacer;
	
	ok_cancel;
}	