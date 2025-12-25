<CsoundSynthesizer>
<CsOptions>
-o wind_synth.wav -3 -m0
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 64
nchnls = 2
0dbfs = 1.0

; Wind Synthesizer Instrument
; Noise -> SVF -> VCA architecture with envelope control
instr 1
    ; Parameters
    iDur = p3                    ; Note duration
    iAmp = p4                    ; Overall amplitude
    iFilterEnvTime = p5          ; Filter envelope time
    iAmpEnvTime = p6             ; Amplitude envelope time
    iFilterCutoff = p7           ; Base filter cutoff frequency
    iFilterRes = p8              ; Filter resonance (Q)
    iPan = p9                    ; Stereo position (0=left, 0.5=center, 1=right)
    iLFOFreq = p10               ; LFO frequency (Hz) for pan modulation
    iLFODepth = p11              ; LFO depth (0-1, amount of pan modulation)
    
    ; Generate noise sources (separate for left and right)
    aNoise1 rand 0.5             ; Left channel noise
    aNoise2 rand 0.5             ; Right channel noise
    
    ; Envelope for filter cutoff (affects brightness/timbre)
    kFilterEnv linseg 0, iFilterEnvTime*0.1, 1, iFilterEnvTime*0.7, 0.3, iFilterEnvTime*0.2, 0.1
    kFilterFreq = iFilterCutoff + (kFilterEnv * iFilterCutoff * 2)
    
    ; State Variable Filters (low-pass mode)
    aLP1, aHP1, aBP1 svfilter aNoise1, kFilterFreq, iFilterRes
    aLP2, aHP2, aBP2 svfilter aNoise2, kFilterFreq, iFilterRes
    
    ; Envelope for amplitude (overall volume contour)
    kAmpEnv linseg 0, iAmpEnvTime*0.05, 1, iAmpEnvTime*0.85, 0.7, iAmpEnvTime*0.1, 0
    
    ; VCAs (apply amplitude envelope)
    aSig1 = aLP1 * kAmpEnv * iAmp
    aSig2 = aLP2 * kAmpEnv * iAmp

    ; LFO for pan modulation (sine wave oscillator)
    kLFO lfo iLFODepth, iLFOFreq, 0  ; LFO output range: -depth to +depth
    kPan = iPan + kLFO                ; Modulate pan position with LFO
    kPan limit kPan, 0, 1             ; Clamp to valid range [0, 1]

    ; Stereo panning (equal-power law)
    kPanL = sqrt(1 - kPan)            ; Left channel gain (now k-rate)
    kPanR = sqrt(kPan)                ; Right channel gain (now k-rate)

    ; Apply panning and mix both noise sources
    aLeft = (aSig1 + aSig2) * kPanL
    aRight = (aSig1 + aSig2) * kPanR

    ; Output stereo
    outs aLeft, aRight
endin

; Simple Wind Instrument - Fixed settings with fade in/out
; No evolving envelopes, just steady tone with attack/release
instr 2
    ; Parameters
    iDur = p3                    ; Note duration
    iAmp = p4                    ; Overall amplitude (fixed)
    iAttack = p5                 ; Fade-in time (seconds)
    iRelease = p6                ; Fade-out time (seconds)
    iFilterCutoff = p7           ; Filter cutoff frequency (fixed)
    iFilterRes = p8              ; Filter resonance (Q)
    iPan = p9                    ; Stereo position (fixed, 0=left, 0.5=center, 1=right)

    ; Generate noise sources (separate for left and right)
    aNoise1 rand 0.5             ; Left channel noise
    aNoise2 rand 0.5             ; Right channel noise

    ; State Variable Filters (low-pass mode) - FIXED cutoff, no envelope
    aLP1, aHP1, aBP1 svfilter aNoise1, iFilterCutoff, iFilterRes
    aLP2, aHP2, aBP2 svfilter aNoise2, iFilterCutoff, iFilterRes

    ; Simple envelope: fade in -> sustain -> fade out
    iSustain = iDur - iAttack - iRelease
    if iSustain < 0 then
        iSustain = 0
    endif
    kAmpEnv linseg 0, iAttack, 1, iSustain, 1, iRelease, 0

    ; VCAs (apply amplitude envelope)
    aSig1 = aLP1 * kAmpEnv * iAmp
    aSig2 = aLP2 * kAmpEnv * iAmp

    ; Stereo panning (equal-power law) - FIXED position, no LFO
    iPanL = sqrt(1 - iPan)       ; Left channel gain
    iPanR = sqrt(iPan)           ; Right channel gain

    ; Apply panning and mix both noise sources
    aLeft = (aSig1 + aSig2) * iPanL
    aRight = (aSig1 + aSig2) * iPanR

    ; Output stereo
    outs aLeft, aRight
endin

</CsInstruments>
<CsScore>

; ========== INSTRUMENT 1: Evolving Wind with LFO Panning ==========
; p1=instr p2=start p3=dur p4=amp p5=filterEnvTime p6=ampEnvTime p7=cutoff p8=resonance p9=pan p10=lfoFreq p11=lfoDepth

; Breathy flute-like sound (center, no LFO)
i1 0 2.0 0.3 0.8 1.5 1200 0.7 0.5 0 0

; Longer, evolving texture (slow auto-pan from center)
i1 2.5 4.0 0.4 2.0 3.5 800 1.2 0.5 0.3 0.4

; Short puff (fast tremolo pan)
i1 7 0.5 0.5 0.3 0.4 2000 0.5 0.5 4 0.3

; Low rumble (very slow drift)
i1 8 3.0 0.6 1.5 2.5 300 0.9 0.5 0.1 0.5


; ========== INSTRUMENT 2: Fixed Wind with Simple Fade ==========
; p1=instr p2=start p3=dur p4=amp p5=attack p6=release p7=cutoff p8=resonance p9=pan

; Steady bright tone (center, quick fade in/out)
i2 12 4.0 0.4 0.2 0.3 1500 0.6 0.5

; Dark rumble (left, slow fade)
i2 16.5 6.0 0.5 0.5 0.8 400 0.8 0.2

; Mid-bright breeze (right, very quick fade)
i2 23 3.0 0.35 0.1 0.15 1000 0.7 0.8

; Soft whisper (center, gentle fade)
i2 26.5 5.0 0.3 0.4 0.5 1800 0.5 0.5

e
</CsScore>
</CsoundSynthesizer>
