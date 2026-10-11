# Validation record

The companion runner was executed on 2026-10-11 using MATLAB **R2026a Update 4**, version `26.1.0.3312084`, on Windows. The MATLAB batch process exited with code 0 and the numerical checks passed. See the machine-readable [MATLAB receipt](provenance/matlab_validation.json).

| Check | Result |
|---|---|
| Annual energy: 6 regions, 2 turbines | PASS; maximum absolute error 0.004397660494 kWh |
| Annual hydrogen and surplus: 6 regions, 4 columns | PASS; maximum absolute error 0.004739528173 in the applicable column's units |
| Economic table: 6 regions, 4 columns | PASS; maximum absolute error 0.000494482406 in the applicable column's units |
| Monthly energy balance for both turbines | PASS; absolute residual below 1e-8 kWh |
| Monthly electrolyzer capacity | PASS |
| Finite annual outputs and nonnegative hydrogen/surplus | PASS |
| Original MATLAB script byte identity | PASS; SHA-256 recorded in the source manifest |

The historical tables were printed to two decimal places for energy/hydrogen/surplus and three decimal places for economic values. The comparison thresholds are 0.0050001 and 0.0005001 respectively. The observed differences fall within those rounding thresholds; the numerical equations were not changed.

The run produced four CSV files, the model variables in a MAT file, five EPS figures, three generated table fragments, and a JSON validation receipt. Generated outputs remain local and are ignored by Git. An old success receipt is removed before a new run so a failed run cannot leave a stale `PASS` report.

No other MATLAB release or operating system has been tested. No new wind measurement campaign or empirical validation is claimed. Rendering can change across MATLAB installations; the acceptance checks compare numerical values, not figure bytes.
