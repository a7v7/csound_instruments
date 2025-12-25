# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Csound-based wind synthesizer** - one instrument within the csound_instruments repository. This repository contains a collection of standalone Csound synthesis projects, each demonstrating different sound design techniques using Csound's high-level audio programming language.

The synthesizer creates wind-like sounds using:
- **Noise generators** (separate left/right for stereo width)
- **State Variable Filters (SVF)** in low-pass mode for tone shaping
- **Envelopes** for dynamic filter cutoff (brightness) and amplitude control
- **VCAs** to apply amplitude shaping

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

- **Instrument architecture (instr 1):**
  - Noise generation → SVF filtering → Envelope shaping → VCA → Stereo output
  - All parameters are passed via p-fields (p3=duration, p4=amplitude, etc.)

**3. `<CsScore>`** - Musical score (note events)
- Format: `i1 start dur amp filterEnvTime ampEnvTime cutoff resonance pan`
- Example: `i1 0 2.0 0.3 0.8 1.5 1200 0.7 0.5`
  - Instrument 1, starts at 0s, 2s duration
  - Amplitude 0.3, filter envelope 0.8s, amp envelope 1.5s
  - Cutoff 1200Hz, resonance 0.7, center position (0.5)

## Sound Design Parameters

The wind synthesizer uses 9 p-fields:

| Field | Parameter | Description | Typical Range |
|-------|-----------|-------------|---------------|
| p1 | Instrument | Always `1` for this synth | 1 |
| p2 | Start time | When note begins (seconds) | 0+ |
| p3 | Duration | Note length (seconds) | 0.5-5.0 |
| p4 | Amplitude | Overall volume | 0.0-1.0 |
| p5 | Filter Env Time | How long filter evolves | 0.3-3.0 |
| p6 | Amp Env Time | How long amplitude evolves | 0.3-3.0 |
| p7 | Filter Cutoff | Base brightness (Hz) | 300-2000 |
| p8 | Resonance | Filter Q (emphasis) | 0.3-2.0 |
| p9 | Pan Position | Stereo placement | 0.0-1.0 |

**Sound characteristics:**
- Higher cutoff (1200-2000 Hz) → breathy, bright, flute-like
- Lower cutoff (300-600 Hz) → dark, rumbling, low wind
- Higher resonance (>1.0) → more tonal, whistle-like
- Lower resonance (<0.7) → pure noise, airy
- Pan position: 0.0 = full left, 0.5 = center, 1.0 = full right

## Architecture Details

### Signal Flow
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
Equal-Power Panning
    ↓
Stereo Output
```

### Envelope Shapes

**Filter Envelope** (controls brightness):
- 10% rise time: 0 → 1 (attack)
- 70% sustain: 1 → 0.3 (decay)
- 20% release: 0.3 → 0.1 (tail)
- Applied as: `finalCutoff = baseCutoff + (envelope * baseCutoff * 2)`

**Amplitude Envelope** (controls volume):
- 5% rise time: 0 → 1 (attack)
- 85% sustain: 1 → 0.7 (body)
- 10% release: 0.7 → 0 (fadeout)

**Stereo Panning** (controls left/right position):
- Uses equal-power panning law for constant perceived loudness
- Left gain = sqrt(1 - pan), Right gain = sqrt(pan)
- Mixes both noise sources before panning (maintains stereo width from filtering)

### Key Csound Opcodes Used

- `rand` - White noise generator
- `svfilter` - State variable filter (returns LP, HP, BP outputs)
- `linseg` - Linear segment envelope generator
- `sqrt` - Square root (for equal-power panning)
- `outs` - Stereo output

## Modifying the Synthesizer

### Adding new sound presets
Edit the `<CsScore>` section and add new `i1` statements with different parameters.

### Changing the synthesis algorithm
Edit the `<CsInstruments>` section, specifically `instr 1`. The Csound language documentation is at https://csound.com/docs/manual/index.html

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
