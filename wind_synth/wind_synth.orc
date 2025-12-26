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

sr = 48000
ksmps = 64
nchnls = 2
0dbfs = 1.0

;-------------------------------------------------------------------------------
; Wind Synthesizer Instrument
; Noise -> SVF -> VCA architecture with envelope control
;-------------------------------------------------------------------------------
instr wind_motion
    ; Parameters
    iDur = p3                    ; Note duration
    iAmp = ampdbfs(p4)           ; Overall amplitude (dBFS)
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

;-------------------------------------------------------------------------------
; Simple Wind Instrument - Fixed settings with fade in/out
; No evolving envelopes, just steady tone with attack/release
;-------------------------------------------------------------------------------
instr wind_still
    ; Parameters
    iDur = p3                    ; Note duration
    iAmp = ampdbfs(p4)           ; Overall amplitude (dBFS)
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
