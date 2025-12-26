;-------------------------------------------------------------------------------
; 	The MIT License (MIT)
; 
; 	Copyright (c) 2025 A.C. Verbeck
; 
; 	Permission is hereby granted, free of charge, to any person obtaining a copy
; 	of this software and associated documentation files (the "Software"), to deal
; 	in the Software without restriction, including without limitation the rights
; 	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; 	copies of the Software, and to permit persons to whom the Software is
; 	furnished to do so, subject to the following conditions:
; 
; 	The above copyright notice and this permission notice shall be included in
; 	all copies or substantial portions of the Software.
; 
; 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; 	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; 	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; 	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; 	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; 	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
; 	THE SOFTWARE.
;-------------------------------------------------------------------------------
;	wind still example

;--------------------------------------------------------------------------------------
; instr			start 	dur		amp		attack 		release 	cutoff 	resonance 	pan
;--------------------------------------------------------------------------------------
i "wind_still"	0		4.0 	-6		0.3			0.5			1500	0.6			0.5			; Steady bright tone (center, quick fade in/out)
i "wind_still"	6		6.0		-12		0.5			0.8			400		0.8			0.2			; Dark rumble (left, slow fade)
i "wind_still"	14		3.0		-18		0.1			0.15		1000	0.7			0.8			; Mid-bright breeze (right, very quick fade)
i "wind_still"	18		5.0		-24		0.4			0.5			1800	0.5			0.5			; Mid-bright breeze (right, very quick fade)

