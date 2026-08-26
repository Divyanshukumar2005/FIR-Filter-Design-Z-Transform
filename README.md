# FIR Filter Design using the Z-Transform

A small MATLAB project that designs two first-order FIR filters — a low-pass and a high-pass — starting from their Z-domain transfer functions, and checks their behavior by plotting the frequency response.

## Why

Most intro DSP courses teach you to write a difference equation and just trust that it filters the way it's supposed to. This project goes the other way: start from `H(z)`, derive the difference equation algebraically using MATLAB's Symbolic Math Toolbox, and then verify the result against the frequency response you'd expect on paper.

| Filter | H(z) | Difference equation |
|---|---|---|
| Low-Pass  | `(z + 1) / z` | `y[n] = x[n] + x[n-1]` |
| High-Pass | `(z - 1) / z` | `y[n] = x[n] - x[n-1]` |

The low-pass filter averages two consecutive samples, so fast changes get smoothed out while slower trends survive. The high-pass filter subtracts consecutive samples instead, so it does the opposite — it kills slow-moving/DC content and keeps the sharp, fast-changing parts. It's essentially a first-order discrete derivative, which is why it's useful for things like edge detection or removing a DC offset from a signal.

## How it works

1. Define `H(z)` symbolically for each filter using `syms`.
2. Pull out the numerator and denominator polynomials with `numden` and convert them to plain coefficient vectors using `sym2poly` — these are the coefficients `freqz` actually needs.
3. Run `freqz` on the coefficients to get the magnitude (dB) and phase (degrees) response across the normalized frequency range `0` to `π`.
4. Plot both and save them to `images/` so the results here stay reproducible.

Both filters are handled by the same `analyze_filter` function in the script, so there's no copy-pasted logic between the LPF and HPF sections — just two calls with a different `H(z)` each.

## Results

**High-pass** — attenuates near DC, opens up as frequency increases toward Nyquist:

![High Pass Filter response](images/high_pass_filter_response.png)

**Low-pass** — the mirror image: strong near DC, rolls off toward Nyquist:

![Low Pass Filter response](images/low_pass_filter_response.png)

The two responses are complementary, which is exactly what you'd expect from `(z+1)/z` and `(z-1)/z` — they match the theoretical prediction from the transfer functions.

## Running it

You'll need MATLAB with the **Symbolic Math Toolbox** installed.

```matlab
fir_filter_design
```

This prints the numerator/denominator coefficients for both filters to the console, opens a figure for each, and (re)saves the corresponding PNGs into `images/`.

## Repository structure

```
.
├── fir_filter_design.m   # Main script — defines both filters and calls analyze_filter
├── images/
│   ├── high_pass_filter_response.png
│   ├── low_pass_filter_response.png
│   └── filter_response.fig   # Editable MATLAB figure
└── README.md
```

## License

MIT — see [LICENSE](LICENSE).
