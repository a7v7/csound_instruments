# Csound Instruments

A collection of standalone audio synthesis instruments built with [Csound](https://csound.com/), demonstrating various sound design techniques and DSP concepts using high-level audio programming.

## Overview

This repository contains self-contained Csound-based synthesizers and sound generators. Each instrument is a complete audio synthesis system with its own documentation, demonstrating different approaches to sound design - from noise-based textures to modeled instruments.

**What is Csound?**

Csound is a powerful, domain-specific audio programming language for sound synthesis and composition. It combines signal generators, filters, effects, and control structures in a text-based format, making it ideal for both artistic sound design and educational DSP exploration.

## Instruments

### Wind Synthesizer
**Location:** `wind_synth/`

A noise-based synthesizer that creates realistic wind and breath-like sounds using state variable filters and dynamic envelope shaping.

**Features:**
- Two instruments: evolving textures with LFO panning, and steady drones
- Stereo noise generation for natural spatial width
- SVF filters with resonance control for tonal shaping
- Independent filter and amplitude envelopes

**Quick start:**
```bash
cd wind_synth
csound wind_synth.csd                    # Render to WAV file
csound -o dac wind_synth.csd             # Real-time playback
```

[Read full documentation →](wind_synth/README.md)

---

*More instruments coming soon...*

## Quick Start

### Prerequisites

**Install Csound:**

*Windows (MINGW64):*
- Download from https://csound.com/download.html

*macOS:*
```bash
brew install csound
```

*Linux:*
```bash
sudo apt-get install csound
```

**Verify installation:**
```bash
csound --version
```

### Running an Instrument

Navigate to any instrument directory and run its `.csd` file:

```bash
cd wind_synth
csound wind_synth.csd              # Creates wind_synth.wav
```

**Common options:**
```bash
csound -o dac instrument.csd       # Real-time audio output
csound -o custom.wav instrument.csd # Custom output filename
csound --sample-rate=96000 ...     # Override sample rate
csound -d -o dac ...               # Enable debug messages
```

## Repository Structure

```
csound_instruments/
├── wind_synth/              # Wind/breath synthesizer
│   ├── wind_synth.csd       # Csound synthesis definition
│   ├── README.md            # Instrument documentation
│   └── CLAUDE.md            # AI assistant guidance
├── CLAUDE.md                # Repository-level AI guidance
├── LICENSE                  # MIT License
└── README.md                # This file
```

Each instrument is **self-contained** with:
- `.csd` file - Complete Csound synthesis code
- `README.md` - Usage guide, parameters, and sound design tips
- `CLAUDE.md` - Technical architecture notes for AI assistants

## Csound File Format

All instruments use the `.csd` (Csound Document) format, which combines three sections:

```xml
<CsoundSynthesizer>
<CsOptions>
  <!-- Command-line flags: output file, bit depth, etc. -->
</CsOptions>
<CsInstruments>
  <!-- Synthesis code: instruments, signal flow, DSP -->
</CsInstruments>
<CsScore>
  <!-- Musical events: note triggers, timing, parameters -->
</CsScore>
</CsoundSynthesizer>
```

## Creating New Instruments

To add a new instrument to this collection:

1. **Create directory:**
   ```bash
   mkdir my_instrument
   cd my_instrument
   ```

2. **Create `.csd` file** with synthesis code
   - Define global settings (`sr`, `ksmps`, `nchnls`)
   - Implement instruments (`instr 1`, `instr 2`, etc.)
   - Add score events (`i1 0 2.0 ...`)

3. **Add `README.md`** documenting:
   - What the instrument does
   - Parameter descriptions and ranges
   - Example usage and presets
   - Sound design techniques

4. **Test thoroughly:**
   ```bash
   csound --syntax-check-only my_instrument.csd
   csound -o dac my_instrument.csd
   ```

5. **Optional: Add `CLAUDE.md`** for complex instruments
   - Architecture details
   - Signal flow diagrams
   - Implementation notes

## Sound Design Philosophy

Each instrument in this repository demonstrates specific DSP concepts:

- **Subtractive synthesis** - Filtering rich sources (noise, sawtooth) to shape timbre
- **Envelope control** - Dynamic parameter modulation over time
- **Stereo imaging** - Spatial positioning and width techniques
- **Modulation** - LFOs, envelopes, and parameter automation

The goal is to create **musically useful** and **educationally clear** instruments that showcase both artistic sound design and technical DSP implementation.

## Resources

### Csound Documentation
- [Csound Manual](https://csound.com/docs/manual/index.html) - Complete opcode reference
- [Csound FLOSS Manual](https://flossmanual.csound.com/) - Tutorials and best practices
- [Csound Community](https://csound.com/community.html) - Forums and discussions

### Learning Csound
- Start with simple instruments (oscillators, filters)
- Understand rate types: i-rate, k-rate, a-rate
- Study signal flow: source → processing → output
- Experiment with parameter ranges and combinations

## Contributing

Contributions are welcome! When adding new instruments:

- Keep each instrument self-contained
- Document parameters and usage clearly
- Include example scores demonstrating the instrument's capabilities
- Follow existing naming conventions and structure
- Test on multiple platforms if possible

## License

MIT License - See [LICENSE](LICENSE) file for details.

## Acknowledgments

Built with [Csound](https://csound.com/), developed by Barry Vercoe and maintained by an active open-source community.
