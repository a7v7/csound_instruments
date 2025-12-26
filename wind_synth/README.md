# Wind Synthesizer (Csound)

A Csound-based wind synthesizer that creates realistic wind and breath-like sounds using noise generators, state variable filters, and envelope shaping. This project provides two instruments with different characteristics for varied sound design possibilities.

![wind_synth-csound test.drawio](C:\dev\csound_instruments\wind_synth\wind_synth-csound test.drawio.png)

## Overview

The wind synthesizer uses a **noise → filter → envelope → VCA** signal path to create wind-like textures. It generates separate noise sources for left and right channels, filters them through state variable filters (SVF), and shapes the result with dynamic envelopes.

**Key Features:**
- Stereo noise generation for natural width
- State variable filters (SVF) in low-pass mode
- Two distinct instruments: evolving textures and steady drones
- LFO-based auto-panning (Instrument 1)
- Simple fade-in/fade-out control (Instrument 2)
- Equal-power stereo panning

## Quick Start

### Running the synthesizer

```bash
# Render to audio file (default: wind_synth.wav)
csound wind_synth.csd

# Real-time audio output
csound -o dac wind_synth.csd

# Custom output file
csound -o my_wind.wav wind_synth.csd

# Override sample rate
csound --sample-rate=96000 wind_synth.csd
```

### Output format
- **Sample rate:** 48000 Hz (default)
- **Channels:** 2 (stereo)
- **Bit depth:** 24-bit
- **Format:** WAV

## Instruments

### Instrument 1: `wind_motion` - Evolving Wind with LFO Panning

Complex, evolving wind textures with dynamic filter and amplitude envelopes, plus optional LFO-based auto-panning.

**Parameters:**
```
i "wind_motion" start dur amp(dBFS) filterEnvTime ampEnvTime cutoff resonance pan lfoFreq lfoDepth
```

| Field | Parameter | Description | Typical Range |
|-------|-----------|-------------|---------------|
| p2 | Start | Note start time (seconds) | 0+ |
| p3 | Duration | Note length (seconds) | 0.5-10.0 |
| p4 | Amplitude | Overall volume (dBFS) | -40 to 0 |
| p5 | Filter Env Time | Filter evolution duration | 0.3-5.0 |
| p6 | Amp Env Time | Amplitude evolution duration | 0.3-5.0 |
| p7 | Filter Cutoff | Base brightness (Hz) | 300-2000 |
| p8 | Resonance | Filter Q/emphasis | 0.3-2.0 |
| p9 | Pan | Stereo position (0=L, 0.5=C, 1=R) | 0.0-1.0 |
| p10 | LFO Freq | Auto-pan speed (Hz, 0=off) | 0.0-5.0 |
| p11 | LFO Depth | Auto-pan amount (0=off) | 0.0-1.0 |

**Amplitude Scale (dBFS):**
- **0 dBFS** = Full scale (maximum, use carefully!)
- **-6 dBFS** = Half amplitude (loud)
- **-12 dBFS** = Quarter amplitude (moderate)
- **-20 dBFS** = Soft
- **-40 dBFS** = Very quiet

**Envelope Behavior:**
- **Filter envelope:** Brightness evolves from 0 → peak → mid → low over filter env time
- **Amplitude envelope:** Volume rises → sustains → falls over amp env time
- **LFO:** Sine wave modulation continuously moves pan position

**Example:**
```csound
; Slow evolving wind with gentle auto-panning
i "wind_motion" 0 5.0 -8 2.5 4.0 800 1.0 0.5 0.2 0.4
```

### Instrument 2: `wind_still` - Fixed Wind with Simple Fade

Steady wind drones with fixed filter, level, and pan settings. Sound fades in, sustains steadily, then fades out.

**Parameters:**
```
i "wind_still" start dur amp(dBFS) attack release cutoff resonance pan
```

| Field | Parameter | Description | Typical Range |
|-------|-----------|-------------|---------------|
| p2 | Start | Note start time (seconds) | 0+ |
| p3 | Duration | Total note length (seconds) | 1.0-10.0 |
| p4 | Amplitude | Fixed volume level (dBFS) | -40 to 0 |
| p5 | Attack | Fade-in time (seconds) | 0.1-2.0 |
| p6 | Release | Fade-out time (seconds) | 0.1-2.0 |
| p7 | Filter Cutoff | Fixed brightness (Hz) | 300-2000 |
| p8 | Resonance | Filter Q/emphasis | 0.3-2.0 |
| p9 | Pan | Fixed stereo position (0=L, 0.5=C, 1=R) | 0.0-1.0 |

**Envelope Behavior:**
- **Attack:** 0 → 1 over attack time
- **Sustain:** Holds at 1 for (duration - attack - release)
- **Release:** 1 → 0 over release time

**Example:**
```csound
; Steady dark wind drone, panned left
i "wind_still" 0 6.0 -6 0.5 0.8 400 0.8 0.2
```

## Sound Design Guide

### Brightness Control (Filter Cutoff)

| Cutoff Range | Character |
|--------------|-----------|
| 300-500 Hz | Dark, rumbling, low wind |
| 600-900 Hz | Mid-range, natural wind |
| 1000-1500 Hz | Bright, airy, breeze-like |
| 1500-2000 Hz | Very bright, breathy, flute-like |

### Resonance (Filter Q)

| Resonance | Character |
|-----------|-----------|
| 0.3-0.6 | Gentle filtering, pure noise |
| 0.7-1.0 | Moderate emphasis, shaped tone |
| 1.1-1.5 | Strong emphasis, tonal quality |
| 1.6-2.0 | Very strong, whistle-like peaks |

### LFO Settings (Instrument 1 only)

| LFO Freq | LFO Depth | Effect |
|----------|-----------|--------|
| 0.0 | 0.0 | No panning movement (static) |
| 0.1-0.3 Hz | 0.3-0.5 | Slow, wide drift |
| 0.5-1.0 Hz | 0.2-0.4 | Gentle swaying |
| 2.0-4.0 Hz | 0.2-0.3 | Fast tremolo panning |
| 5.0+ Hz | 0.1-0.2 | Vibrato-like flutter |

### Common Sound Presets

**Gentle Breeze:**
```csound
i "wind_still" 0 8.0 -10.5 0.5 1.0 1200 0.6 0.5
```

**Dark Storm:**
```csound
i "wind_motion" 0 10.0 -4.5 3.0 8.0 350 1.2 0.5 0.15 0.5
```

**Fluttering Wind:**
```csound
i "wind_motion" 0 5.0 -8 1.5 4.0 1400 0.8 0.5 3.0 0.3
```

**Steady Drone (Background):**
```csound
i "wind_still" 0 20.0 -12 1.0 2.0 600 0.7 0.5
```

**Wind Gust:**
```csound
i "wind_motion" 0 1.5 -3 0.5 1.2 1800 0.5 0.5 0 0
```

## Technical Details

### Signal Flow

**`wind_motion` (Evolving):**
```
Noise Gen (L/R) → SVF Filter → Filter Env → Amp Env → VCA → LFO Pan → Stereo Out
```

**`wind_still` (Fixed):**
```
Noise Gen (L/R) → SVF Filter (fixed) → Fade Env → VCA → Pan (fixed) → Stereo Out
```

### Csound Opcodes Used

- `rand` - White noise generator
- `svfilter` - State variable filter (returns LP, HP, BP outputs)
- `linseg` - Linear segment envelope generator
- `lfo` - Low frequency oscillator (`wind_motion`)
- `limit` - Value clamping (`wind_motion`)
- `sqrt` - Square root (equal-power panning)
- `ampdbfs` - Convert dBFS to linear amplitude
- `outs` - Stereo output

### Equal-Power Panning

Both instruments use equal-power panning to maintain constant perceived loudness across the stereo field:

```csound
kPanL = sqrt(1 - kPan)  ; Left gain
kPanR = sqrt(kPan)      ; Right gain
```

This prevents volume dips when sounds move through the center position.

## Editing the Score

The score section (`<CsScore>`) defines the musical events. Each line starting with `i` triggers an instrument.

**Format:**
```
i[instrument] [start] [param3] [param4] ...
```

**Tips:**
- Times are in seconds
- Events can overlap to create layered textures
- Use `e` to mark the end of the score
- Comments start with `;`

**Example score:**
```csound
<CsScore>
; Layer multiple wind sounds
i "wind_still" 0 10.0 -10.5 0.5 1.0 800 0.7 0.3   ; Background left
i "wind_still" 0 10.0 -10.5 0.5 1.0 1200 0.6 0.7  ; Background right
i "wind_motion" 2 5.0 -8 2.0 4.0 1500 0.8 0.5 0.3 0.4  ; Foreground evolving
e
</CsScore>
```

## Dependencies

**Required:**
- Csound 6.x or later

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

## File Structure

```
csound_instruments/
├── wind_synth/
│   ├── wind_synth.csd   # Main Csound file (instruments + demo score)
│   ├── wind_synth.orc   # Orchestra file (instruments only, no score)
│   ├── README.md        # This file
│   └── CLAUDE.md        # AI assistant guidance
├── CLAUDE.md            # Repository-level AI assistant guidance
└── [future instruments] # Additional Csound synthesizers
```

**Note:** `wind_synth.csd` and `wind_synth.orc` contain the same instrument definitions. The `.csd` file includes a demonstration score showcasing both instruments, while the `.orc` file contains only the instrument definitions for use with separate score files (`.sco`).

## Repository Overview

This wind synthesizer is part of the **csound_instruments** repository - a collection of standalone Csound-based audio synthesis instruments. Each instrument in this repository is self-contained and demonstrates different synthesis techniques and sound design approaches using Csound's high-level audio programming language.

## Advanced Usage

### Real-time MIDI Control

Csound supports MIDI input. To use MIDI controllers:

```csound
; Add to instrument definition
iNote cpsmidi        ; Get MIDI note as frequency
iVel ampmidi 1       ; Get MIDI velocity
```

### Multiple Output Files

Render different sections separately:

```bash
# Edit score to isolate specific events, then:
csound -o section1.wav wind_synth.csd
# Edit again for next section
csound -o section2.wav wind_synth.csd
```

### Parameter Automation

Use k-rate envelopes for dynamic parameter changes:

```csound
; Dynamic resonance sweep
kRes linseg 0.5, p3*0.5, 1.5, p3*0.5, 0.5
```

## Troubleshooting

**No sound output:**
- Check that `-o dac` is set for real-time, or valid filename for file output
- Verify amplitude values (p4) are reasonable dBFS levels (e.g., -12 to -6 dBFS)
- Ensure Csound is properly installed

**Clicks/pops:**
- Increase `ksmps` value (e.g., `ksmps = 128`)
- Ensure attack/release times aren't too short (>0.01s)

**Distortion:**
- Reduce amplitude values (p4) - try -12 dBFS or lower
- Lower resonance (p8) values
- Check that `0dbfs = 1.0` is set

**Audio device errors (real-time):**
- List devices: `csound --devices`
- Specify device: `csound -o dac3 wind_synth.csd`

## License

MIT License - See repository [LICENSE](../LICENSE) file.

## Further Reading

- [Csound Manual](https://csound.com/docs/manual/index.html)
- [Csound FLOSS Manual](https://flossmanual.csound.com/)
- [Repository Documentation](../CLAUDE.md)
