# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains **Csound-based audio synthesis instruments** - a collection of standalone sound design projects using the Csound audio programming language. Each subdirectory represents a self-contained instrument or sound synthesis system.

**Key characteristics:**
- Language: Csound (high-level audio programming, .csd files)
- Output: Audio files (WAV) or real-time audio playback
- Architecture: Single-file .csd format (combines options, instruments, and score)
- Platform: Cross-platform (Windows/MINGW64, macOS, Linux)

## Repository Structure

```
csound_instruments/
├── wind_synth/          # Wind/breath synthesizer with noise + filters
│   ├── wind_synth.csd   # Main Csound file
│   ├── README.md        # Instrument documentation
│   └── CLAUDE.md        # Instrument-specific guidance
└── [future instruments] # Additional Csound instruments
```

Each instrument directory is **self-contained** with its own:
- `.csd` file (Csound synthesis definition)
- `README.md` (usage documentation)
- `CLAUDE.md` (AI assistant guidance)

## Common Commands

### Running Csound Instruments

**Basic rendering (output to file):**
```bash
cd wind_synth
csound wind_synth.csd
```

**Real-time playback:**
```bash
csound -o dac wind_synth.csd
```

**Custom output file:**
```bash
csound -o my_output.wav wind_synth.csd
```

**Override sample rate:**
```bash
csound --sample-rate=96000 wind_synth.csd
```

### Debugging and Development

**Show debug messages:**
```bash
csound -o dac -d wind_synth.csd
```

**List available audio devices:**
```bash
csound --devices
```

**Syntax check only (no rendering):**
```bash
csound --syntax-check-only wind_synth.csd
```

## Csound File Structure

All instruments use the `.csd` (Csound Document) format, which combines three sections:

**1. `<CsOptions>`** - Command-line parameters
- Output file/device (`-o`)
- Bit depth (`-3` = 24-bit)
- Message verbosity (`-m0` = silent)

**2. `<CsInstruments>`** - Synthesis code
- Global settings (`sr`, `ksmps`, `nchnls`, `0dbfs`)
- Instrument definitions (`instr 1`, `instr 2`, etc.)
- Signal flow: generators → filters → envelopes → output

**3. `<CsScore>`** - Musical events
- Note events (`i1 0 2.0 0.5 ...`)
- Format: instrument number, start time, duration, parameters
- End marker (`e`)

## Working with Csound Code

### Editing Instruments

**To modify synthesis algorithm:**
1. Navigate to instrument directory
2. Open the `.csd` file
3. Edit `<CsInstruments>` section (between `instr N` and `endin`)
4. Test changes: `csound -o dac instrument.csd`

**To add sound events:**
1. Edit `<CsScore>` section
2. Add new `i` statements with desired parameters
3. Events can overlap for layered sounds

### Parameter Conventions

Csound uses **p-fields** for note parameters:
- `p1` = instrument number (always)
- `p2` = start time in seconds (always)
- `p3` = duration in seconds (always)
- `p4+` = instrument-specific parameters (amplitude, cutoff, etc.)

### Rate Types

Csound variables have prefixes indicating their update rate:
- `i` prefix = **i-rate** (initialization, once per note)
- `k` prefix = **k-rate** (control rate, ksmps samples)
- `a` prefix = **a-rate** (audio rate, every sample)

Example:
```csound
iAmp = p4           ; Set once at note start
kEnv linseg 0, 1, 1 ; Updates every k-cycle
aSig rand 1.0       ; Updates every sample
```

## Architecture Patterns

### Common Signal Flow

Most instruments follow this DSP architecture:
```
Source (oscillator/noise)
    ↓
Filter (SVF, moogladder, etc.)
    ↓
Envelope Generator (linseg, adsr, etc.)
    ↓
VCA (amplitude control)
    ↓
Effects (optional: reverb, delay, etc.)
    ↓
Panning
    ↓
Stereo Output (outs)
```

### Stereo Techniques

**Equal-power panning** (constant perceived loudness):
```csound
iPanL = sqrt(1 - iPan)  ; Left gain (0-1)
iPanR = sqrt(iPan)      ; Right gain (0-1)
```

**Stereo width from dual sources:**
```csound
aNoise1 rand 0.5  ; Independent left noise
aNoise2 rand 0.5  ; Independent right noise
```

## Common Csound Opcodes

### Generators
- `rand` - White noise
- `oscil` - Sine/table oscillator
- `vco2` - Virtual analog oscillator
- `poscil` - Phase-sync oscillator

### Filters
- `svfilter` - State variable filter (LP/HP/BP outputs)
- `moogladder` - Moog-style lowpass
- `butterlp/butterhp` - Butterworth filters
- `comb` - Comb filter

### Envelopes
- `linseg` - Linear segments
- `expseg` - Exponential segments
- `adsr` - ADSR envelope
- `madsr` - MIDI-triggered ADSR

### Modulation
- `lfo` - Low-frequency oscillator
- `poscil` - General oscillator (can be used as LFO)

### Utilities
- `limit` - Clamp values to range
- `sqrt` - Square root
- `outs` - Stereo output

## Dependencies

**Required:**
- Csound 6.x or later (tested with 6.18)

**Installation:**

*Windows (MINGW64):*
Download from https://csound.com/download.html

*macOS:*
```bash
brew install csound
```

*Linux:*
```bash
sudo apt-get install csound
```

**Verification:**
```bash
csound --version
```

## Creating New Instruments

To add a new instrument to this repository:

1. Create new directory: `mkdir new_instrument_name`
2. Create `.csd` file with three sections (Options, Instruments, Score)
3. Add `README.md` documenting:
   - What the instrument does
   - Parameter descriptions
   - Example usage
   - Sound design tips
4. Optionally add `CLAUDE.md` for complex instruments
5. Test thoroughly with both file output and real-time playback

## Troubleshooting

**No sound output:**
- Verify Csound is installed: `csound --version`
- Check amplitude values (typically p4) are > 0
- For real-time: ensure `-o dac` is set
- For file: verify output path is writable

**Clicks/pops:**
- Increase `ksmps` value (e.g., 64, 128)
- Ensure envelopes have proper attack/release times (>0.01s)
- Check for division by zero or abrupt signal changes

**Distortion/clipping:**
- Reduce amplitude values
- Ensure `0dbfs = 1.0` is set (floating-point range)
- Check filter resonance isn't too high

**Audio device errors (real-time):**
- List devices: `csound --devices`
- Specify device: `csound -o dac3 wind_synth.csd`
- Try different buffer sizes: `csound -b512 -B2048 -o dac ...`

**Syntax errors:**
- Use `--syntax-check-only` flag
- Check matching `instr`/`endin` pairs
- Verify all variables have correct rate prefix (i/k/a)

## References

- [Csound Manual](https://csound.com/docs/manual/index.html) - Complete opcode reference
- [Csound FLOSS Manual](https://flossmanual.csound.com/) - Tutorial and best practices
- [Csound Community](https://csound.com/community.html) - Forums and support
