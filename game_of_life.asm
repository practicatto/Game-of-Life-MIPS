#
#					▒█▀▀█ █▀▀█ █▀▄▀█ █▀▀ 　 █▀▀█ █▀▀ 　 █░░ ░▀░ █▀▀ █▀▀ 
#					▒█░▄▄ █▄▄█ █░▀░█ █▀▀ 　 █░░█ █▀▀ 　 █░░ ▀█▀ █▀▀ █▀▀ 
#					▒█▄▄█ ▀░░▀ ▀░░░▀ ▀▀▀ 　 ▀▀▀▀ ▀░░ 　 ▀▀▀ ▀▀▀ ▀░░ ▀▀▀
# 						Computer Organization's project
#
#	 			+-----------------+
#	 			|     Authors     |			+----------+---------+ 
#	 			+-----------------+			| Language | Spanish |
#	 			| Joseph Avila    |			+----------+---------+ 
#		 		| Joangie Marquez |		
#		 		+-----------------+		
#
#		 	   +--------------------------------------------------------------------------+
#		 	   |                               Descripcion                                |
# 			  +--------------------------------------------------------------------------+
# 			  | Autómata celular (Cellular automaton) que evoluciona de manera discreta. |
# 			  | Está compuesto por un tablero teóricamente infinito en dos dimensiones   |
#			  | que rodea las celdas sobre las cuales se producirán las interacciones.   |
# 			  +--------------------------------------------------------------------------+
#
#
# 
.data
	display:		.word		0x10008000 #para poder usar el bitmap tools y visualizar se usa el siguiente registro $gp ya que es preferible a un arreglo en el static data porque es menos propenso a bugs
	vivos:			.space		1200 #array de vivos
	muertos:		.space		1200 #array de muertos
	
	pixel_vivo:		.word 		0xFFFFFF	#blanco
	pixel_muerto:		.word		0x000000	# 0 (negro)
	opt:			.word		0 #opcion seleccionada
	
	#mensajes
	instrucciones_msg:	.asciiz		"Hola!\nActiva el bitmap display antes de empezar.\nTools > Bitmap display. Después conectalo con mips!\nPresiona enter para continuar"
	inicio_msg:		.asciiz		"Bienvenido!\n Selecciona una de las siguientes configuraciones de patrones:\n1. Bloque (siempre vivo)\n2. Pulsar (oscilador)\n3. Arma\n4. Nave\nPatron methuselah (patron que tardan en estabilizarse):\n5. Arcon\nPatrones creados\n6. Joseph\n7. Joangie (tetromino que muere) \n8. Salir\n"
	error_msg:		.asciiz		"Ha ingresado una opcion invalida. Ingresa un numero [1-8] \n"
	new_line: 		.asciiz 	"\n"
	informacion_msg:	.asciiz		"\n   Informacion    \n----------------\n"
	gen_msg:		.asciiz		"Generacion: "
	celulas_vivas:		.asciiz		"Celulas vivas: "
	
		
.text 
main:	
	# instrucciones para empezar | v0: entrada user, a1: tipo de mensaje (0 para error) , a0: mensaje
	
	jal mostrar_instrucciones
	j imprimir_opts #imprimir las opciones
	
	opt_invalido:
		li $v0, 55	
		li $a1, 0	
		la $a0, error_msg
		syscall

	imprimir_opts:
		# impresion de las opciones
		li $v0, 51		 #dialogo para leer int de user
		la $a0, inicio_msg	#mensaje de las opciones
		syscall
		
	#almacenando patron opt
	sw $a0, opt #almacenando el patron escogido que está en el registro $a0 en opt
	lw $s0, opt #cargando en $s0 el valor de opt
	
	#mensajes no validos
	bgt $s0, 8, opt_invalido
	blt $s0, 1, opt_invalido
		
		
	#ifs
	beq $s0, 1, bloque_pattern
	beq $s0, 2, pulsar_pattern
	beq $s0, 3, arma_pattern
	beq $s0, 4, nave_pattern
	beq $s0, 5, arcon_pattern
	beq $s0, 6, joseph_pattern
	beq $s0, 7, joangie_pattern
	beq $s0, 8, end
		

	lw $s1, display #se carga direccion inicial de la pantalla donde se va a ver la simulacion 
	li $a0, 0 #se guarda la posicion en x (cuanto se mueve a la derecha) Rango: [0-63] porque 512/8 = 64 (8x8 unit pixels). Inicialmente: 0
	li $a1, 0 #se guarda la posicion en y (cuanto se mueve hacia abajo) Rango: [0-63]. Inicialmente: 0
	

# 			+----------+
# 			| Patrones |
# 			+----------+

bloque_pattern:
	addi $sp, $sp, -4		
	sw $ra, ($sp) # push $ra
	
	lw $s1, display			
	li $a0, 32			
	li $a1, 32			
	jal crear_pixel
	
	lw $s1, display			
	li $a0, 31			
	li $a1, 32			
	jal crear_pixel	
		
	lw $s1, display			
	li $a0, 31			
	li $a1, 31			
	jal crear_pixel	
	
	
	lw $ra, ($sp)
	addiu $sp, $sp, 4 #pop $ra
	j comenzar 


pulsar_pattern:
	addi $sp, $sp, -4		
	sw $ra, ($sp)				# push $ra to the stack	
	
	lw $s1, display			
	li $a0, 26			
	li $a1, 30			
	jal crear_pixel	
	lw $s1, display			
	li $a0, 26			
	li $a1, 29			
	jal crear_pixel
	lw $s1, display			
	li $a0, 26			
	li $a1, 28			
	jal crear_pixel
	lw $s1, display			
	li $a0, 31			
	li $a1, 30			
	jal crear_pixel	
	lw $s1, display			
	li $a0, 31			
	li $a1, 29			
	jal crear_pixel
	lw $s1, display			
	li $a0, 31			
	li $a1, 28			
	jal crear_pixel
	lw $s1, display			
	li $a0, 33			
	li $a1, 30			
	jal crear_pixel	
	lw $s1, display			
	li $a0, 33			
	li $a1, 29			
	jal crear_pixel
	lw $s1, display			
	li $a0, 33			
	li $a1, 28			
	jal crear_pixel
	jal crear_pixel
	lw $s1, display			
	li $a0, 38			
	li $a1, 30			
	jal crear_pixel	
	lw $s1, display			
	li $a0, 38			
	li $a1, 29			
	jal crear_pixel
	lw $s1, display			
	li $a0, 38			
	li $a1, 28			
	jal crear_pixel
	lw $s1, display			
	li $a0, 26			
	li $a1, 34			
	jal crear_pixel	
	lw $s1, display			
	li $a0, 26			
	li $a1, 35			
	jal crear_pixel
	lw $s1, display			
	li $a0, 26			
	li $a1, 36			
	jal crear_pixel
	jal crear_pixel
	lw $s1, display			
	li $a0, 31			
	li $a1, 34			
	jal crear_pixel	
	lw $s1, display			
	li $a0, 31			
	li $a1, 35			
	jal crear_pixel
	lw $s1, display			
	li $a0, 31			
	li $a1, 36			
	jal crear_pixel
	jal crear_pixel
	lw $s1, display			
	li $a0, 33			
	li $a1, 34			
	jal crear_pixel	
	lw $s1, display			
	li $a0, 33			
	li $a1, 35			
	jal crear_pixel
	lw $s1, display			
	li $a0, 33			
	li $a1, 36			
	jal crear_pixel
	jal crear_pixel
	lw $s1, display			
	li $a0, 38			
	li $a1, 34			
	jal crear_pixel	
	lw $s1, display			
	li $a0, 38			
	li $a1, 35			
	jal crear_pixel
	lw $s1, display			
	li $a0, 38			
	li $a1, 36			
	jal crear_pixel
	lw $s1, display			
	li $a0, 28			
	li $a1, 26			
	jal crear_pixel
	lw $s1, display			
	li $a0, 29			
	li $a1, 26			
	jal crear_pixel
	lw $s1, display			
	li $a0, 30			
	li $a1, 26			
	jal crear_pixel
	lw $s1, display			
	li $a0, 34			
	li $a1, 26			
	jal crear_pixel
	lw $s1, display			
	li $a0, 35			
	li $a1, 26			
	jal crear_pixel
	lw $s1, display			
	li $a0, 36			
	li $a1, 26			
	jal crear_pixel
	lw $s1, display			
	li $a0, 28			
	li $a1, 33			
	jal crear_pixel
	lw $s1, display			
	li $a0, 29			
	li $a1, 33			
	jal crear_pixel
	lw $s1, display			
	li $a0, 30			
	li $a1, 33			
	jal crear_pixel
	lw $s1, display			
	li $a0, 34			
	li $a1, 33			
	jal crear_pixel
	lw $s1, display			
	li $a0, 35			
	li $a1, 33			
	jal crear_pixel
	lw $s1, display			
	li $a0, 36			
	li $a1, 33			
	jal crear_pixel
	lw $s1, display			
	li $a0, 28			
	li $a1, 38			
	jal crear_pixel
	lw $s1, display			
	li $a0, 29			
	li $a1, 38			
	jal crear_pixel
	lw $s1, display			
	li $a0, 30			
	li $a1, 38			
	jal crear_pixel
	lw $s1, display			
	li $a0, 34			
	li $a1, 38			
	jal crear_pixel
	lw $s1, display			
	li $a0, 35			
	li $a1, 38			
	jal crear_pixel
	lw $s1, display			
	li $a0, 36			
	li $a1, 38			
	jal crear_pixel
	lw $s1, display			
	li $a0, 28			
	li $a1, 31			
	jal crear_pixel
	lw $s1, display			
	li $a0, 29			
	li $a1, 31			
	jal crear_pixel
	lw $s1, display			
	li $a0, 30			
	li $a1, 31			
	jal crear_pixel
	lw $s1, display			
	li $a0, 34			
	li $a1, 31			
	jal crear_pixel
	lw $s1, display			
	li $a0, 35			
	li $a1, 31			
	jal crear_pixel
	lw $s1, display			
	li $a0, 36			
	li $a1, 31			
	jal crear_pixel
	
	lw $ra, ($sp)
	addiu $sp, $sp, 4			# pop $ra from the stack	
	j comenzar 

arma_pattern:
	addi $sp, $sp, -4		
	sw $ra, ($sp)				
	
	lw $s1, display			
	li $a0, 15			
	li $a1, 14			
	jal crear_pixel	
	lw $s1, display			
	li $a0, 15			
	li $a1, 15			
	jal crear_pixel
	lw $s1, display			
	li $a0, 16			
	li $a1, 14			
	jal crear_pixel	
	lw $s1, display			
	li $a0, 16			
	li $a1, 15			
	jal crear_pixel
	lw $s1, display			
	li $a0, 25			
	li $a1, 14			
	jal crear_pixel
	lw $s1, display			
	li $a0, 25			
	li $a1, 15			
	jal crear_pixel
	lw $s1, display			
	li $a0, 25			
	li $a1, 16			
	jal crear_pixel
	lw $s1, display			
	li $a0, 26			
	li $a1, 13		
	jal crear_pixel
	lw $s1, display			
	li $a0, 26			
	li $a1, 17		
	jal crear_pixel
	lw $s1, display			
	li $a0, 27			
	li $a1, 12		
	jal crear_pixel
	lw $s1, display			
	li $a0, 28			
	li $a1, 12		
	jal crear_pixel
	lw $s1, display			
	li $a0, 27			
	li $a1, 18		
	jal crear_pixel
	lw $s1, display			
	li $a0, 28			
	li $a1, 18		
	jal crear_pixel
	lw $s1, display			
	li $a0, 29			
	li $a1, 15		
	jal crear_pixel
	lw $s1, display			
	li $a0, 30			
	li $a1, 13		
	jal crear_pixel
	lw $s1, display			
	li $a0, 30			
	li $a1, 17		
	jal crear_pixel
	lw $s1, display			
	li $a0, 31			
	li $a1, 14		
	jal crear_pixel
	lw $s1, display			
	li $a0, 31			
	li $a1, 15		
	jal crear_pixel
	lw $s1, display			
	li $a0, 31			
	li $a1, 16		
	jal crear_pixel
	lw $s1, display			
	li $a0, 32			
	li $a1, 15		
	jal crear_pixel
	lw $s1, display			
	li $a0, 35			
	li $a1, 12		
	jal crear_pixel
	lw $s1, display			
	li $a0, 35			
	li $a1, 13		
	jal crear_pixel
	lw $s1, display			
	li $a0, 35			
	li $a1, 14		
	jal crear_pixel
	lw $s1, display			
	li $a0, 36			
	li $a1, 12		
	jal crear_pixel
	lw $s1, display			
	li $a0, 36			
	li $a1, 13		
	jal crear_pixel
	lw $s1, display			
	li $a0, 36		
	li $a1, 14		
	jal crear_pixel
	lw $s1, display			
	li $a0, 37		
	li $a1, 11		
	jal crear_pixel
	lw $s1, display			
	li $a0, 37		
	li $a1, 15		
	jal crear_pixel
	lw $s1, display			
	li $a0, 39		
	li $a1, 10		
	jal crear_pixel
	lw $s1, display			
	li $a0, 39		
	li $a1, 11		
	jal crear_pixel
	lw $s1, display			
	li $a0, 39		
	li $a1, 15		
	jal crear_pixel
	lw $s1, display			
	li $a0, 39		
	li $a1, 16		
	jal crear_pixel
	lw $s1, display			
	li $a0, 49		
	li $a1, 12		
	jal crear_pixel
	lw $s1, display			
	li $a0, 49		
	li $a1, 13		
	jal crear_pixel
	lw $s1, display			
	li $a0, 50		
	li $a1, 12		
	jal crear_pixel
	lw $s1, display			
	li $a0, 50		
	li $a1, 13		
	jal crear_pixel
	
	lw $ra, ($sp)
	addiu $sp, $sp, 4			
	j comenzar

nave_pattern:
	addi $sp, $sp, -4		
	sw $ra, ($sp)				
	
	lw $s1, display			
	li $a0, 0			
	li $a1, 32			
	jal crear_pixel	
	lw $s1, display			
	li $a0, 0			
	li $a1, 34			
	jal crear_pixel	
	lw $s1, display			
	li $a0, 1			
	li $a1, 31			
	jal crear_pixel	
	lw $s1, display			
	li $a0, 2			
	li $a1, 31			
	jal crear_pixel	
	lw $s1, display			
	li $a0, 3			
	li $a1, 31			
	jal crear_pixel	
	lw $s1, display			
	li $a0, 4			
	li $a1, 31			
	jal crear_pixel	
	lw $s1, display			
	li $a0, 4			
	li $a1, 32			
	jal crear_pixel	
	lw $s1, display			
	li $a0, 4			
	li $a1, 33			
	jal crear_pixel
	lw $s1, display			
	li $a0, 3			
	li $a1, 34			
	jal crear_pixel		
	
	lw $ra, ($sp)
	addiu $sp, $sp, 4			# pop $ra from the stack
	j comenzar 

arcon_pattern:
	acorn:
	subiu $sp, $sp, 4		
	sw $ra, ($sp)				# push $ra to the stack
	
	lw $s1, display			
	li $a0, 39		
	li $a1, 33		
	jal crear_pixel
	lw $s1, display			
	li $a0, 40		
	li $a1, 33		
	jal crear_pixel
	lw $s1, display			
	li $a0, 40		
	li $a1, 31		
	jal crear_pixel
	lw $s1, display			
	li $a0, 42		
	li $a1, 32		
	jal crear_pixel
	lw $s1, display			
	li $a0, 43		
	li $a1, 33		
	jal crear_pixel
	lw $s1, display			
	li $a0, 44		
	li $a1, 33		
	jal crear_pixel
	lw $s1, display			
	li $a0, 45		
	li $a1, 33		
	jal crear_pixel
	
	lw $ra, ($sp)
	addiu $sp, $sp, 4				
	j comenzar 
	
joseph_pattern:
joangie_pattern:
	lw $s1, display			
	li $a0, 20			
	li $a1, 20			
	jal crear_pixel	
	
	lw $s1, display			
	li $a0, 21			
	li $a1, 21			
	jal crear_pixel	
	
	
	lw $s1, display			
	li $a0, 22			
	li $a1, 21			
	jal crear_pixel	
	
	lw $s1, display			
	li $a0, 23			
	li $a1, 21			
	jal crear_pixel	
	
	lw $ra, ($sp)
	addiu $sp, $sp, 4 #pop $ra
	j comenzar 
	

# 	+--------------------+
# 	|       Inicio       |
# 	|     Simulación     |
# 	+--------------------+

comenzar:
	li $t0, 0 # inicilizacion de generacion
	li $t7, 1 #inicializacion de pixeles vivos a 1 para que pueda empezar con el patron escogido por el usuario
	
	loop_display:
		beq $t7, $zero, end #si no hay pixeles vivos (0 pixeles vivos) entonces salir.
		jal actualizar #un loop en todo el display para ver si hay pixeles vivos
		jal print_data
		j loop_display
#se coloca end aqui para que no tenga que dar muchos saltos
end:
	la $v0, 10
	syscall

	
crear_pixel:	
	lw  $s1, display #inicio del display
	sll $t1, $a0, 2 #calculo de la posicion en x | multiplicando x por 4 (1 word)
	sll $t2, $a1, 8 #calculo de la posicion en y | multiplicando y por 2**8 (256 es el numero de toda la fila de la pantalla: 16384/64 = 256) 
	add $t1, $t1, $t2 #suma xy 
	add $s1, $s1, $t1 #posicion nueva del pixel 
	lw $t4, pixel_vivo #colocando pixel blanco
	sw $t4, ($s1) #aqui colocando en el bitmap el pixel vivo :d
	jr $ra #chau

 verifica_color:
 	#determinara el color del vecino (neighbor) nos encanta el spanglish
 	lw $s1, display 
 	sll $t1, $a2, 2 #calculo del vecino x
 	sll $t2, $a3, 8 #calculo del vecino y
 	add $t1, $t1, $t2 #x+y del vecino jiji
 	add $s1, $s1, $t1 #posiciones con el display address 
 	lw $v0, ($s1) #cargamos el color del vecino en v0
 	jr $ra
 
verfica_micolor:
	#determina el color del pixel actual en la pantalla
	lw $s1, display #display
	sll $t1, $a0, 2
	sll $t2, $a1, 8
	add $t1, $t1, $t2
	add $s1, $s1, $t1 #pos
	lw $v1, ($s1)
	jr $ra

obtener_direccion:
	#convierte las cordenadas xy en una direccion
	lw  $s1, display 
	sll $t3, $a0, 2 #x
	sll $t4, $a1, 8 #y 
	add $t3, $t3, $t4 #x + y
	add $s1, $s1, $t3 #display addr + (x+y)
	move $v1, $s1 # direccion de pixel en v1
	jr $ra 

actualizar:
	#Recorremos cada pixel de la pantalla y determinamos si habra vida nueva
	#Si no hay alguna celula viva se termina el programa
 	addi $sp, $sp, -4 
 	sw $ra ($sp) #push $ra
 	
 	li $t7, 0 #cuantos vivos encontramos en la pantalla
 	#pos inicial
 	li $a0, 0 
 	li $a1, 0 
 	
 	la $t8, vivos #inciializar arreglos para ver vivos y muertos
 	la $t9, muertos
 	
 	verifica_pixel:
 		jal verfica_micolor
 		beq $v1, $zero, muerto #verificar si el pixel es negro (muerto)
 	
 	verifica_coloreado: #si no esta negro, esta vivo
 		addi $t7, $t7, 1 #aumentando el contador de pixeles vivos
 		jal contar_vecinos
 		blt $t5, 2, marcar_muerto # num vecinos < 2 (0,1) -> muere por subpoblación :'
 		bgt $t5, 3, marcar_muerto # num vecinos > 3 (+4) -> muere por sobrepoblacion 
 		j  verificar_bordes
 		
 		 marcar_muerto:
 			jal obtener_direccion
 			sw $v1 ($t9) #el vivo lo guardamos en el arreglo de muertos
 			
 			addiu $t9, $t9, 4 #siguiente indice
 			addi $t7, $t7, -1 #restamos 1 en el contador
 			
 			j verificar_bordes
 		
 		muerto:
 			jal contar_vecinos
 			beq $t5, 3, marcar_vivo #si tiene 3 vecinos -> esta viva (IT'S ALIVE)
 			j verificar_bordes #seguir en el loop
 			marcar_vivo:
 				jal obtener_direccion
 				sw $v1, ($t8) #guardar nuevo pixel vivo en el arreglo de los vivos
 				addiu $t8, $t8, 4 #ir al siguiente espacio
 				addiu $t7, $t7, 1 #incrementar contador
 				
 		verificar_bordes: 
 			addiu $a0, $a0, 1 
 			bgt $a0, 63, reiniciar_x #el rango de las coordenadas es de [0,63] reiniciar coordenada x e incrementar la coordenada y
 			blt $a0, 64, verifica_pixel #x y y están dentro del rango entonces se puede seguir recorriendo la pantalla
 			
 			reiniciar_x:
 				li $a0,0
 				addiu $a1, $a1, 1
 				bgt $a1, 63, terminar_actualizacion 
 				j verifica_pixel
 				
 				terminar_actualizacion:
 					jal siguiente_gen	#una vez que terminamos, hay que dibujar los cambios en la pantalla
 					lw $ra, ($sp) 
 					addiu $sp, $sp, 4
 					jr $ra
 				
 		siguiente_gen:
 			addi $sp, $sp, -4
 			sw $s2, ($sp)
 			la $t8, vivos
 			la $t9, muertos
 			addiu $t0, $t0, 1
 				matar:
 					lw $s2, ($t9)
					beqz $s2, generar			
					lw $v1, ($t9) 
					lw $t4, pixel_muerto # color de pixl muerto
					sw $t4, ($v1) # pixel muerto
					sw $zero, ($t9)
					addiu $t9, $t9, 4
					j matar
 					
 					generar:
 						lw $s2, ($t8)
 						beq $s2, $zero, terminar_sgtgen
 						lw $v1, ($t8)
 						lw $t4, pixel_vivo #cargar pixel blanco
 						sw $t4, ($v1) #pixel en bitma
 						sw $zero, ($t8) #limpiar direccion del pixel que creamos
 						addiu $t8, $t8, 4 #siguiente pixel
 						j generar 
 					
 					terminar_sgtgen:

 						lw $s2, ($sp)
 						addiu $sp, $sp, 4
 						jr $ra
 print_data:
	
 	li $v0, 4
 	la $a0, informacion_msg
 	syscall
 	
 	li $v0, 4
	la $a0, gen_msg
	syscall
	
 	li $v0, 1
	addu $a0, $t0, $zero
	syscall

	li $v0, 4
	la $a0, new_line
	syscall
	
	li $v0, 4
	la $a0, celulas_vivas
	syscall
	
	
	li $v0, 1
	addu $a0, $t7, $zero
	syscall
	
	li $v0, 4
	la $a0, new_line
	syscall
	
	jr $ra
 						
 	
# .-----------------.----------------.----------------.
# | 1: (x-1, y-1)   |  2: (x, y-1)   |  3: (x+1,y-1)  |
# :-----------------+----------------+----------------:
# | 4: (x-1, y)     |  celula: (x,y)  |  5: (x+1, y)   |
# :-----------------+----------------+----------------:
# | 6: (x-1, y+1)   |  7: (x, y+1)   |  8: (x+1, y+1) |
# '-----------------'----------------'----------------'				

contar_vecinos:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	li $t5, 0 #contador de vecinos vivos
	
	### 1. (x-1, y-1) verificar vecinos en la izquierda superior
	verificar_superiorizq: 
		addi $a2, $a0, -1 #posicion x del vecino (x-1)
		blt $a2, 0, verificar_arriba
		addi $a3, $a1, -1 #posicion y del vecino (y-1)
		blt $a3, 0 verificar_arriba
		
		jal verifica_color
		sne $t6, $v0, 0
		add $t5, $t5, $t6 
	
	#(x, y-1) verificar vecinos arriba
	verificar_arriba:
		move $a2, $a0 #x
		addi $a3, $a1, -1 #y-1 
		blt $a3, 0, verificar_der
		
		jal verifica_color
		sne $t6, $v0, 0
		add $t5, $t5, $t6
	
	#(x+1, y-1) superior derecha
	verificar_superiorder:
		addi $a2, $a0, 1 #x+1
		bgt $a2, 63, verificar_izq
		addi $a3, $a1, -1 #y-1
		blt $a3, 0, verificar_izq
		jal verifica_color
		sne $t6, $v0, 0
		add $t5, $t5, $t6
	
	#(x-1,y) verificar izq	
	verificar_izq:
		addi $a2, $a0, -1 #x-1
		blt $a2, 0, verificar_der
		move $a3, $a1		
		jal verifica_color
		sne $t6, $v0, 0 			
		add $t5, $t5, $t6
		
	#(x+1,y)
	verificar_der:
		addi $a2, $a0, 1 #x+1
		bgt $a2, 63, verificar_inferiorizq 
		move $a3, $a1 
		jal verifica_color
		sne $t6, $v0, 0 			
		add $t5, $t5, $t6
	
	#(x-1,y+1) 
	verificar_inferiorizq:
		addi $a2, $a0, -1 #x-1
		blt $a2, 0, verificar_abajo
		addiu $a3, $a1, 1 #y-1
		bgt $a3, 63, verificar_abajo		
		jal verifica_color
		sne $t6, $v0, 0 			
		add $t5, $t5, $t6
	#x, y+1
	verificar_abajo:
		move $a2, $a0 #x
		addiu $a3, $a1, 1 #y+1
		bgt $a3, 63, verificar_inferiorder
		jal verifica_color
		sne $t6, $v0, 0 #no es 0, incrementar el contador de vecinos vivos
		add $t5, $t5, $t6
	#x+1, y+1
	verificar_inferiorder:
		addi $a2, $a0, 1 #x+1
		bgt $a2, 63, terminar_verificacion
		addi $a3, $a1, 1 #y+1
		bgt $a3, 63, terminar_verificacion
		jal verifica_color
		sne $t6, $v0, 0
		add $t5, $t5, $t6
	
	
	terminar_verificacion:
		lw $ra, ($sp)
		addiu $sp, $sp,4
		jr $ra
	
mostrar_instrucciones:
	li $v0, 4
	la $a0, instrucciones_msg
	syscall
	li $v0, 12
	syscall
	
	move $t0, $v0
	
	li $v0, 4
	la $a0, new_line
	syscall
	
	
	#10 es ascii para enter	
	bne $t0, 10, mostrar_instrucciones 
	jr $ra
	 
	


	









