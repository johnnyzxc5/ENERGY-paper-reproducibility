# ENERGY paper reproducibility

Companion MATLAB model and numerical reference results for **Techno-Economic Feasibility of Wind-Powered Hydrogen Production in Saudi Arabia: A Multi-Regional Assessment**, by Uriel Isaac Castilla Batun and Johnny Adrian Garcia Betancourt.

This repository contains the computational materials needed to reproduce the six-region wind energy, hydrogen production, surplus electricity, and economic calculations. The manuscript, its LaTeX sources, bibliography, and PDF are excluded. The repository has an independent Git history.

## Reproduce the calculations

Use MATLAB from the repository root:

```matlab
run_reproduction
```

Or run without opening the MATLAB desktop:

```powershell
matlab -wait -noFigureWindows -batch "run_reproduction"
```

MATLAB must be installed and licensed. If `matlab` is absent from `PATH`, run the command in MATLAB or use the full path to its executable. The model uses base MATLAB functions and embedded numerical inputs; no external dataset, Simulink model, or additional toolbox is required. The verified environment and results are recorded in [VALIDATION.md](VALIDATION.md).

The runner writes local outputs under `results/generated/`:

- `annual_energy.csv`, `annual_hydrogen_surplus.csv`, and `economic_results.csv` contain the recomputed annual tables at full precision.
- `monthly_results.csv` contains all 72 region/month combinations for both turbines.
- `model_results.mat` contains the numerical model variables.
- `validation.json` records comparison errors and the result of the energy balance and electrolyzer capacity checks.
- The original exporter also produces five EPS figures and three generated table fragments in its historical output folders. These local files are ignored by Git; they are not manuscript sources.

A successful run prints `PASS: all annual reference tables and monthly balance checks match.` A numerical mismatch raises an error and makes the batch command fail. Batch execution is recommended because the original script clears its own workspace, closes figures, and changes MATLAB graphics defaults.

## Included materials

| Path | Purpose |
|---|---|
| [`code/ESP2.m`](code/ESP2.m) | Original numerical script, preserved byte for byte |
| [`run_reproduction.m`](run_reproduction.m) | Portable entry point, CSV export, and reference checks |
| [`results/reference/`](results/reference/) | Three frozen CSV tables and five original EPS figures |
| [`provenance/source_manifest.json`](provenance/source_manifest.json) | Source commit, SHA-256 identities, and packaging transformations |
| [`CITATION.cff`](CITATION.cff) | Authors and citation metadata for this companion archive |

The CSV reference tables were converted from the original exported tables without changing their values or decimal precision. Their source files are identified by hash in the provenance manifest; no LaTeX files are included in this release.

## Computational scope

The model uses embedded monthly mean wind speeds for six regions and two turbine configurations: 600 kW at 50 m and 2300 kW at 100 m. It reconstructs power from the embedded interpolation nodes using `pchip`, multiplies by the hours in each month, and supplies a 39 kW electrolyzer at 50 kWh/kg of hydrogen. Remaining energy is exported to the grid.

The economic calculation uses the original assumptions: USD 1000/kW for the turbine and electrolyzer, an 8% discount rate, a 25-year lifetime, annual operation and maintenance at 1.5% of capital cost, and export revenue at USD 0.03/kWh. These are model inputs, not current market quotations. Negative hydrogen cost values follow the script's allocation of surplus electricity revenue.

This archive reproduces the embedded monthly model and its numerical outputs. It does not supply the underlying wind measurement time series or perform an independent resource assessment. Reference tolerances account for rounding: 0.0050001 for tables printed to two decimal places and 0.0005001 for the economic table printed to three decimal places. Figure rendering may vary by MATLAB version and platform; figure bytes are not the numerical acceptance criterion.

## Rights

Original computational software is licensed under [MIT](LICENSE). See [LICENSING.md](LICENSING.md) and [RIGHTS.md](RIGHTS.md) for the scope; frozen research artifacts and external material have separate rights.


## License

Original software is licensed under [MIT](LICENSE). See [LICENSING.md](LICENSING.md) for the covered paths and exclusions for manuscripts, research artifacts and third-party materials.
