caixa_viga:dialog {
	label = "Viga - Linha central";
	spacer_1;

	:row {
		spacer_1;
	
		//Dialogo do TIPO
		:row {
			label = "Tipo";
			alignment = centered;
			
			:column {
				height = 12;
			
				:radio_row {
					key= "tipoViga";
				
					:radio_button {
						label = "Externa";
						key = "externa";
						//height = 10;
					}
					:radio_button {
						label = "Interna";
						key = "interna";
						//height = 10;
					}
				}	
			
				:row {
					:icon_image {
						key = "icon_image1";
						width = 16;
						height = 8;
					}
					:icon_image {
						key = "icon_image2";
						width = 16;
						height = 8;
					}
				}
			}
		
		}

		spacer_1;
		
		//Dialogo da POSICAO
		:row {
			label = "Posição";
			alignment = top;
			
			:column {
				height = 12;
			
				:radio_row {
					key= "posicaoViga";
				
					:radio_button {
						label = "Horizontal";
						key = "horizontal";
						//height = 10;
					}
					:radio_button {
						label = "Vertical";
						key = "vertical";
						//height = 10;
					}
				}	
			
				:row {
					:icon_image {
						key = "icon_image3";
						width = 16;
						height = 8;
					}
					:icon_image {
						key = "icon_image4";
						width = 16;
						height = 8;
					}
				}
			}
		
		}

		spacer_1;
		
		//Dialogo da DIRECAO
		:radio_column {
			label = "Direção";
			key= "direcao";
				
			:radio_button {
				label = "A cima";
				key = "cima";
				//is_enabled = true;	
			}
			:radio_button {
				label = "A baixo";
				key = "baixo";	
			}
			
			:radio_button {
				label = "Esqeurda";
				key = "esquerda";
			}
			:radio_button {
				label = "Direita";
				key = "direita";
			}
		}

		spacer_1;
	}

	spacer_1;
	spacer_1;

	ok_cancel;

	spacer_1;
}