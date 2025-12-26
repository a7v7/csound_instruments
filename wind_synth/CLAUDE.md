# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Csound-based wind synthesizer** - one instrument within the csound_instruments repository. This repository contains a collection of standalone Csound synthesis projects, each demonstrating different sound design techniques using Csound's high-level audio programming language.

The synthesizer provides **two instruments** for creating wind-like sounds:

**1. `wind_motion`** - Evolving wind with LFO-driven panning
- Dynamic filter and amplitude envelopes
- Automatic panning modulation (tremolo/auto-pan effects)
- Ideal for evolving, moving wind textures

**2. `wind_still`** - Fixed wind with simple fade
- Static filter cutoff and pan position
- Simple attack/sustain/release envelope
- Ideal for steady, sustained wind tones

Both instruments use:
- **Noise generators** (separate left/right for stereo width)
- **State Variable Filters (SVF)** in low-pass mode for tone shaping
- **Envelopes** for amplitude control
- **dBFS amplitude levels** for professional audio workflow

This is a **single-file Csound project** (.csd format) that combines instrument definitions, orchestration, and score in one unified document.

## Running the Synthesizer

### Basic execution
```bash
csound wind_synth.csd
```

This will:
- Process the score defined in the .csd file
- Generate `wind_synth.wav` as output (48kHz, stereo, 24-bit)
- Run silently (command-line option `-m0` suppresses most messages)

### Real-time audio output
```bash
csound -o dac wind_synth.csd
```

Replace `-o wind_synth.wav` with `-o dac` in the `<CsOptions>` section for real-time playback through audio interface.

### Common command-line options
```bash
csound -o output.wav wind_synth.csd        # Custom output filename
csound -o dac -d wind_synth.csd            # Real-time with debug messages
csound --sample-rate=96000 wind_synth.csd  # Override sample rate
```

## Csound (.csd) File Structure

The .csd file has three main sections:

**1. `<CsOptions>`** - Command-line parameters
- `-o wind_synth.wav` - Output file
- `-3` - 24-bit output format
- `-m0` - Suppress most messages

**2. `<CsInstruments>`** - Global settings and instrument definitions
- **Global settings:**
  - `sr = 48000` - Sample rate
  - `ksmps = 64` - Control rate (samples per k-cycle)
  - `nchnls = 2` - Stereo output
  - `0dbfs = 1.0` - 0 dB = 1.0 (floating-point range)

- **Instrument definitions:**
  - `wind_motion` - Evolving wind with LFO panning
  - `wind_still` - Fixed wind with simple fade
  - Both use: Noise generation → SVF filtering → Envelope shaping → VCA → Stereo output
  - All parameters are passed via p-fields (p3=duration, p4=amplitude in dBFS, etc.)

**3. `<CsScore>`** - Musical score (note events)
- Format for `wind_motion`: `i "wind_motion" start dur amp(dBFS) filterEnvTime ampEnvTime cutoff resonance pan lfoFreq lfoDepth`
- Format for `wind_still`: `i "wind_still" start dur amp(dBFS) attack release cutoff resonance pan`
- Example: `i "wind_motion" 0 2.0 -10.5 0.8 1.5 1200 0.7 0.5 0 0`
  - wind_motion instrument, starts at 0s, 2s duration
  - Amplitude -10.5 dBFS, filter envelope 0.8s, amp envelope 1.5s
  - Cutoff 1200Hz, resonance 0.7, center position (0.5), no LFO
- Example: `i "wind_still" 0 3.0 -8 0.2 0.3 1500 0.6 0.5`
  - wind_still instrument, starts at 0s, 3s duration
  - Amplitude -8 dBFS, 0.2s attack, 0.3s release
  - Cutoff 1500Hz, resonance 0.6, center position (0.5)

## Sound Design Parameters

### Instrument 1: `wind_motion` (Evolving Wind with LFO Panning)

| Field | Parameter | Description | Typical Range |
|-------|-----------|-------------|---------------|
| p1 | Instrument | Always `"wind_motion"` | - |
| p2 | Start time | When note begins (seconds) | 0+ |
| p3 | Duration | Note length (seconds) | 0.5-5.0 |
| p4 | Amplitude | Overall volume (dBFS) | -40 to 0 |
| p5 | Filter Env Time | How long filter evolves | 0.3-3.0 |
| p6 | Amp Env Time | How long amplitude evolves | 0.3-3.0 |
| p7 | Filter Cutoff | Base brightness (Hz) | 300-2000 |
| p8 | Resonance | Filter Q (emphasis) | 0.3-2.0 |
| p9 | Pan Position | Initial stereo placement | 0.0-1.0 |
| p10 | LFO Frequency | Pan modulation speed (Hz) | 0-5 |
| p11 | LFO Depth | Pan modulation amount | 0.0-1.0 |

**LFO Effects:**
- LFO Freq = 0 → no panning movement (static position)
- LFO Freq = 0.1-0.5 → slow drift/sway
- LFO Freq = 0.5-2 → auto-pan effect
- LFO Freq = 3-5 → tremolo/vibrato effect
- LFO Depth controls how far panning moves from initial position

### Instrument 2: `wind_still` (Fixed Wind with Simple Fade)

| Field | Parameter | Description | Typical Range |
|-------|-----------|-------------|---------------|
| p1 | Instrument | Always `"wind_still"` | - |
| p2 | Start time | When note begins (seconds) | 0+ |
| p3 | Duration | Note length (seconds) | 0.5-10.0 |
| p4 | Amplitude | Overall volume (dBFS) | -40 to 0 |
| p5 | Attack Time | Fade-in duration (seconds) | 0.1-1.0 |
| p6 | Release Time | Fade-out duration (seconds) | 0.1-2.0 |
| p7 | Filter Cutoff | Brightness (Hz, fixed) | 300-2000 |
| p8 | Resonance | Filter Q (emphasis) | 0.3-2.0 |
| p9 | Pan Position | Stereo placement (fixed) | 0.0-1.0 |

### Common Sound Characteristics (Both Instruments)

**Amplitude (dBFS scale):**
- 0 dBFS → full scale (maximum, use carefully!)
- -6 dBFS → half amplitude (loud)
- -12 dBFS → quarter amplitude (moderate)
- -20 dBFS → soft
- -40 dBFS → very quiet

**Filter Cutoff:**
- Higher cutoff (1200-2000 Hz) → breathy, bright, flute-like
- Lower cutoff (300-600 Hz) → dark, rumbling, low wind

**Resonance:**
- Higher resonance (>1.0) → more tonal, whistle-like
- Lower resonance (<0.7) → pure noise, airy

**Pan Position:**
- 0.0 = full left, 0.5 = center, 1.0 = full right

## Architecture Details

### Signal Flow

**wind_motion (Evolving Wind):**
```
Noise Generator (L/R separate)
    ↓
Filter Cutoff Envelope (shared L/R)
    ↓
State Variable Filter (SVF, low-pass mode)
    ↓
Amplitude Envelope (shared L/R)
    ↓
VCA (Volume Control Amplifier)
    ↓
LFO-Modulated Equal-Power Panning (k-rate)
    ↓
Stereo Output
```

**wind_still (Fixed Wind):**
```
Noise Generator (L/R separate)
    ↓
State Variable Filter (SVF, low-pass mode, FIXED cutoff)
    ↓
Attack/Sustain/Release Envelope
    ↓
VCA (Volume Control Amplifier)
    ↓
Equal-Power Panning (i-rate, fixed)
    ↓
Stereo Output
```

### Envelope Shapes

**wind_motion - Filter Envelope** (controls brightness evolution):
- 10% rise time: 0 → 1 (attack)
- 70% sustain: 1 → 0.3 (decay)
- 20% release: 0.3 → 0.1 (tail)
- Applied as: `finalCutoff = baseCutoff + (envelope * baseCutoff * 2)`

**wind_motion - Amplitude Envelope** (controls volume evolution):
- 5% rise time: 0 → 1 (attack)
- 85% sustain: 1 → 0.7 (body)
- 10% release: 0.7 → 0 (fadeout)

**wind_still - Amplitude Envelope** (simple fade in/out):
- Attack phase: 0 → 1 (fade in)
- Sustain phase: 1 → 1 (steady)
- Release phase: 1 → 0 (fade out)
- Duration: `attack + sustain + release = total duration`

**Stereo Panning:**
- Uses equal-power panning law for constant perceived loudness
- Left gain = sqrt(1 - pan), Right gain = sqrt(pan)
- `wind_motion`: k-rate panning (modulated by LFO)
- `wind_still`: i-rate panning (fixed position)
- Both mix noise sources before panning (maintains stereo width)

### Key Csound Opcodes Used

- `rand` - White noise generator
- `svfilter` - State variable filter (returns LP, HP, BP outputs)
- `linseg` - Linear segment envelope generator
- `lfo` - Low-frequency oscillator (for pan modulation)
- `limit` - Clamp values to valid range
- `sqrt` - Square root (for equal-power panning)
- `ampdbfs` - Convert dBFS to linear amplitude
- `outs` - Stereo output

## Modifying the Synthesizer

### Adding new sound presets
Edit the `<CsScore>` section and add new `i` statements with different parameters. Use `"wind_motion"` for evolving, moving textures or `"wind_still"` for steady, sustained tones.

**Example presets:**
```csound
; Gentle breeze (no movement)
i "wind_motion" 0 3.0 -12 1.5 2.5 1000 0.6 0.5 0 0

; Swaying wind (slow auto-pan)
i "wind_motion" 4 5.0 -10 2.0 4.0 800 0.8 0.5 0.2 0.3

; Steady low rumble
i "wind_still" 10 8.0 -8 0.5 1.0 400 0.9 0.5
```

### Changing the synthesis algorithm
Edit the `<CsInstruments>` section, specifically `instr wind_motion` or `instr wind_still`. The Csound language documentation is at https://csound.com/docs/manual/index.html

### Adjusting global settings
Change `sr`, `ksmps`, `nchnls`, or output format flags in `<CsOptions>`.

## Dependencies

**Required:**
- Csound 6.x or later (tested with Csound 6.18)

**Installation (MINGW64/Windows):**
```bash
# Download from https://csound.com/download.html
# Or use package manager if available
```

## Repository Structure

This wind synthesizer is located in the **csound_instruments** repository:

```
csound_instruments/
├── wind_synth/          # This instrument (wind/breath synthesis)
│   ├── wind_synth.csd   # Main Csound file
│   ├── README.md        # User documentation
│   └── CLAUDE.md        # This file
├── CLAUDE.md            # Repository-level guidance
└── [future instruments] # Additional Csound synthesizers
```

Each instrument is **self-contained** and can be used independently. The repository serves as a collection of diverse Csound synthesis examples, from simple noise-based textures to more complex modeled instruments.
