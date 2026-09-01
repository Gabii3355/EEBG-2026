## Repository structure

```text
broken/
└── gromacs_gpu.slurm

copylogs/
└── copylogs.slurm

iwontruns/
├── iwontrun_1.slurm
├── iwontrun_2.slurm
├── iwontrun_3.slurm
└── iwontrun_4.slurm

modules/
└── addmodule.slurm
```

### Broken GROMACS job

This exercise focused on diagnosing and fixing a misconfigured GROMACS batch job running under SLURM.

The job initially failed because of several independent configuration problems. The debugging process involved inspecting SLURM error logs and correcting the batch script step by step.

The following issues were identified and resolved:

1. An unavailable GROMACS module was replaced with a compatible module.
2. The GROMACS input `.tpr` file was copied from `$SLURM_SUBMIT_DIR` to the job-specific `$SCRATCHDIR`.
3. A GPU was explicitly requested from SLURM because `gmx mdrun` was configured to use GPU acceleration.
4. An insufficient memory allocation (`10 MB`) causing an Out Of Memory (OOM) termination was removed.
5. The corrected job successfully completed a 10,000-step (20 ps) GROMACS run and produced timing and performance information.

### Copying simulation logs

This exercise focused on managing input and output files between the SLURM submission directory and the job scratch directory.

The GROMACS `.tpr` input file was copied from `$SLURM_SUBMIT_DIR` to `$SCRATCHDIR`, where a short 3000-step molecular dynamics run was executed using two MPI tasks on CPU.

After the calculation, the generated `md.log` file was copied back to `$SLURM_SUBMIT_DIR` to preserve the simulation log outside the temporary job directory.


### Diagnosing SLURM jobs (`iwontrun`)

This exercise focused on diagnosing SLURM jobs that could not be executed as expected.

Four small batch scripts with different wall-time and memory requests were submitted to the tutorial partition. The scripts were used to investigate how requested resources and scheduler constraints affect job execution.

### HPC software modules

Practiced software environment configuration using the Lmod module system. Available GROMACS installations were inspected to identify a 2024 release compiled with MPI support.

A compatible module hierarchy consisting of GCC, OpenMPI, and GROMACS was loaded, and the configuration was verified by running a short MPI-based GROMACS calculation.
