; ========== INSTRUMENT 1: Evolving Wind with LFO Panning ==========
; p1=instr p2=start p3=dur p4=amp(dBFS) p5=filterEnvTime p6=ampEnvTime p7=cutoff p8=resonance p9=pan p10=lfoFreq p11=lfoDepth

; Breathy flute-like sound (center, no LFO)
i1 0 2.0 -10.5 0.8 1.5 1200 0.7 0.5 0 0

; Longer, evolving texture (slow auto-pan from center)
i "wind_motion" 2.5 4.0 -8 2.0 3.5 800 1.2 0.5 0.3 0.4

; Short puff (fast tremolo pan)
i "wind_motion" 7 0.5 -6 0.3 0.4 2000 0.5 0.5 4 0.3

; Low rumble (very slow drift)
i "wind_motion" 8 3.0 -4.5 1.5 2.5 300 0.9 0.5 0.1 0.5


; ========== INSTRUMENT 2: Fixed Wind with Simple Fade ==========
; p1=instr p2=start p3=dur p4=amp(dBFS) p5=attack p6=release p7=cutoff p8=resonance p9=pan

; Steady bright tone (center, quick fade in/out)
i "wind_still" 12 4.0 -8 0.2 0.3 1500 0.6 0.5

; Dark rumble (left, slow fade)
i "wind_still" 16.5 6.0 -6 0.5 0.8 400 0.8 0.2

; Mid-bright breeze (right, very quick fade)
i "wind_still" 23 3.0 -9 0.1 0.15 1000 0.7 0.8

; Soft whisper (center, gentle fade)
i "wind_still" 26.5 5.0 -10.5 0.4 0.5 1800 0.5 0.5
