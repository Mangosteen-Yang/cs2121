; LCD Backlight
.equ LCD_BACKLIGHT_STABLE = 0
.equ LCD_BACKLIGHT_FADEIN = 1
.equ LCD_BACKLIGHT_FADEOUT = 2

; LCD Backlight Functions
initialiseBacklightTimer:
	push temp1
	
	clr temp1 							; clear variables
	sts BacklightSeconds, temp1
	sts BacklightCounter, temp1
	sts BacklightCounter+1, temp1
	sts BacklightFadeCounter, temp1
	sts BacklightFade, temp1
	ldi temp1, 0xFF
	sts BacklightPWM, temp1

	clr temp1 							; initialise timer prescale
	sts TCCR2A, temp1
	ldi temp1, 0b00000010
	sts TCCR2B, temp1
	
	ser temp1
	out DDRE, temp1

	ldi temp1, (1 << CS40) 				; initialise pwm timer
	sts TCCR4B, temp1
	ldi temp1, (1 << WGM40)|(1 << COM4A1)
	sts TCCR4A, temp1

	ldi temp1, 0xFF 					; initialise output compare value
	sts OCR4AL, temp1
	clr temp1
	sts OCR4AH, temp1

	ldi temp1, 1 << TOIE2 				; enable timer interrupt
	sts TIMSK2, temp1

	pop temp1
	ret

backlightFadeIn:
	push temp1

	ldi temp1, LCD_BACKLIGHT_FADEIN				; set backlight fade state to fade in
	sts BacklightFade, temp1	
	
	clr temp1									; reset the backlight counter
	sts BacklightSeconds, temp1
	sts BacklightCounter, temp1
	sts BacklightCounter+1, temp1

	pop temp1
	ret

backlightFadeOut:
	push temp1

	ldi temp1, LCD_BACKLIGHT_FADEOUT			; set backlight fade state to fade out
	sts BacklightFade, temp1	

	pop temp1
	ret

