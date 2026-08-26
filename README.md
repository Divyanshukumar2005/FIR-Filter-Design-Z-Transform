# FIR Filter Design using the Z-Transform

A small MATLAB project that designs two first-order FIR filters — a low-pass and a high-pass — starting from their Z-domain transfer functions, and verifies the design three different ways: frequency response, pole-zero map, and impulse response.

## Contents

- [Why](#why)
- [How it works](#how-it-works)
- [Results](#results)
- [Running it](#running-it)
- [Repository structure](#repository-structure)
- [What I'd add next](#what-id-add-next)
- [License](#license)

## Why

Most intro DSP courses teach you to write a difference equation and just trust that it filters the way it's supposed to. This project goes the other way: start from `H(z)`, derive the difference equation algebraically using MATLAB's Symbolic Math Toolbox, and then check the result three separate ways instead of just eyeballing one plot.

| Filter | H(z) | Difference equation |
|---|---|---|
| Low-Pass  | `(z + 1) / z` | `y[n] = x[n] + x[n-1]` |
| High-Pass | `(z - 1) / z` | `y[n] = x[n] - x[n-1]` |

The low-pass filter averages two consecutive samples, so fast changes get smoothed out while slower trends survive. The high-pass filter subtracts consecutive samples instead, so it does the opposite — it kills slow-moving/DC content and keeps the sharp, fast-changing parts. It's essentially a first-order discrete derivative, which is why it's useful for things like edge detection or removing a DC offset from a signal.

Both are also a good sanity check for the "FIR" part of the name: a system is only truly FIR if its impulse response actually dies out after a finite number of samples, rather than that just being assumed.

## How it works

1. Define `H(z)` symbolically for each filter using `syms`.
2. Pull out the numerator and denominator polynomials with `numden`, then convert them to plain coefficient vectors using `sym2poly` — this is the form `freqz`, `zplane`, and `impz` all expect.
3. Find the poles and zeros with `roots`, and check stability by confirming every pole lies inside the unit circle.
4. Plot three views of the same system for each filter, and save all of them to `images/`:
   - **Frequency response** (`freqz`) — magnitude in dB and phase in degrees, `0` to `π`
   - **Pole-zero map** (`zplane`) — where the poles/zeros actually sit relative to the unit circle
   - **Impulse response** (`impz`) — confirms the response is finite, which is the entire point of "FIR"

Both filters are handled by the same `analyze_filter` function in the script, so there's no copy-pasted logic between the LPF and HPF sections — just two calls with a different `H(z)` each.

## Results

**High-pass** — attenuates near DC, opens up as frequency increases toward Nyquist. Pole-zero map shows the zero sitting on the unit circle at `z = 1` (DC), which is exactly why DC gets killed:

![High Pass Filter frequency response](images/high_pass_frequency_response.png)
![High Pass Filter pole-zero map](images/high_pass_pole_zero_map.png)
![High Pass Filter impulse response](images/high_pass_impulse_response.png)

**Low-pass** — the mirror image: strong near DC, rolls off toward Nyquist. Here the zero sits at `z = -1` (Nyquist) instead:

![Low Pass Filter frequency response](images/low_pass_frequency_response.png)
![Low Pass Filter pole-zero map](images/low_pass_pole_zero_map.png)
![Low Pass Filter impulse response](images/low_pass_impulse_response.png)

The two frequency responses are complementary, which is exactly what you'd expect from `(z+1)/z` and `(z-1)/z`. Both impulse responses are non-zero for only 2 samples, confirming both systems are genuinely FIR — there's no pole anywhere except at the origin, so nothing "rings" or decays indefinitely.

## Running it

You'll need MATLAB with:
- **Symbolic Math Toolbox** — for the `syms`/`numden`/`sym2poly` steps
- **Signal Processing Toolbox** — for `freqz`, `zplane`, and `impz`

```matlab
fir_filter_design
```

This prints the coefficients, zeros, poles, and a stability check for both filters to the console, opens three figures per filter, and (re)saves the corresponding PNGs into `images/`.

## Repository structure

```
.
├── fir_filter_design.m   # Main script — defines both filters and calls analyze_filter
├── images/
│   ├── low_pass_frequency_response.png
│   ├── low_pass_pole_zero_map.png
│   ├── low_pass_impulse_response.png
│   ├── high_pass_frequency_response.png
│   ├── high_pass_pole_zero_map.png
│   ├── high_pass_impulse_response.png
│   └── filter_response.fig   # Editable MATLAB figure
└── README.md
```

## What I'd add next

- Generalize `analyze_filter` to accept arbitrary-order `H(z)` instead of hardcoding two first-order cases
- Run both filters on an actual noisy test signal (not just the theoretical response) to show the filtering effect directly
- Compare against `fir1`/`designfilt` to see how a "designed from scratch" filter stacks up against MATLAB's built-in filter design tools

## License

MIT — see [LICENSE](LICENSE).
