# CADM1 Glycosylation and Coarse-Grained Membrane Modelling

This exercise investigated how glycosylation may influence the surface shielding and membrane orientation of the transmembrane cell adhesion protein CADM1.

The workflow followed three main stages:

1. rapid prediction of glycan conformations and membrane interactions using GlycoSHIELD,
2. construction and simulation of a coarse-grained glycoprotein in an explicit lipid membrane using Martini 3 and GROMACS,
3. structural and orientation analysis of the resulting molecular dynamics trajectory.

The biological hypothesis explored during the workshop was that glycans located close to the membrane may restrict the conformational space available to the glycan layer and thereby influence the preferred orientation of the CADM1 ectodomain.

## Notebooks

```text
GlycoSHIELD_tut_fixed3.ipynb
exercise_glycoprotein_ver1.ipynb
analysis.ipynb
```

---

## Part 1: GlycoSHIELD analysis of CADM1 glycosylation

The first part focused on modelling glycan conformations on the surface of CADM1 and evaluating glycan shielding and possible steric interactions with the membrane.

The CADM1 structure was obtained from the AlphaFold Protein Structure Database, while annotated glycosylation sites were retrieved from UniProt.

Six glycosylation sites were analysed:

```text
67, 101, 113, 165, 304, 308
```

Man9 glycan conformers from the GlycoSHIELD conformer library were grafted onto these sites.

For each glycosylation site, GlycoSHIELD tested multiple pre-sampled glycan conformations. Conformers producing steric clashes with the protein were rejected, while compatible conformers were retained.

The number of accepted conformers was used as a measure of conformational accessibility.

### Glycan conformational accessibility

Without a membrane boundary, the accepted conformer counts were:

| Glycosylation site | Accepted conformers |
|---:|---:|
| 67 | 2369 |
| 101 | 1748 |
| 113 | 2511 |
| 165 | 1643 |
| 304 | 2397 |
| 308 | 888 |

The results show that conformational accessibility depends strongly on the glycosylation site. Residue 113 allowed the largest number of Man9 conformers, whereas residue 308 was the most sterically restricted by the protein environment.

### Glycan shielding

The collective ensemble of accepted glycan conformers was used to represent the glycan brush surrounding CADM1.

Solvent-Accessible Surface Area (SASA) analysis was then used to estimate how strongly different regions of the protein were shielded by glycans.

Relative shielding was calculated as:

\[
\Delta SASA_i =
1 -
\frac{SASA_i^{glyc}}{SASA_i^{bare}}
\]

where:

- `SASA_bare` represents solvent accessibility without glycans,
- `SASA_glyc` represents solvent accessibility in the presence of glycans.

A value close to 0 indicates little shielding, while larger values indicate stronger glycan-mediated protection of the protein surface.

The analysis showed that glycan shielding is spatially heterogeneous and that different regions of CADM1 experience different levels of steric protection.

### Effect of the membrane boundary

To investigate how the membrane could restrict glycan conformations, the CADM1 transmembrane helix was oriented approximately along the Z axis.

The membrane surface was represented by a geometric boundary at:

```text
z = 0
```

Glycan conformers extending into the membrane region were rejected.

The resulting occupancies were:

| Glycosylation site | No membrane | With membrane |
|---:|---:|---:|
| 67 | 2369 | 0 |
| 101 | 1748 | 600 |
| 113 | 2511 | 2505 |
| 165 | 1643 | 1610 |
| 304 | 2397 | 2397 |
| 308 | 888 | 792 |

The strongest membrane-induced restrictions were observed for residues 67 and 101.

Residue 67 lost all accepted conformers:

```text
2369 → 0
```

while residue 101 decreased from:

```text
1748 → 600
```

corresponding to a loss of approximately 66% of its previously accessible conformations.

The effect was much weaker for the remaining sites.

These results indicate that glycan accessibility depends not only on the local protein environment but also on the spatial position of the glycan relative to the membrane.

### Biological interpretation

Restriction of glycan conformations by the membrane reduces the number of configurations available to the glycan layer and therefore represents a possible conformational entropic penalty.

This leads to the hypothesis that a more upright orientation of the CADM1 ectodomain could be favorable because it would allow the glycan brush to extend further away from the membrane and retain greater conformational freedom.

Possible biological implications include:

- altered accessibility of CADM1 adhesion interfaces,
- regulation of spacing between neighboring cell membranes,
- modulation of CADM1 interactions with other membrane proteins,
- changes in the geometry of adhesion complexes,
- potential effects on receptor organization and downstream signal transduction.

These implications are hypotheses derived from the structural model rather than effects directly demonstrated by this analysis.

---

## Part 2: Coarse-grained glycoprotein modelling and molecular dynamics

The second part extended the rapid GlycoSHIELD analysis toward an explicit molecular dynamics model containing the glycosylated protein and a lipid membrane.

### Coarse-graining the protein

The starting all-atom protein structure was converted into a coarse-grained representation using `martinize2` and the Martini force field.

The conversion generated the coarse-grained protein coordinates and corresponding topology required for molecular dynamics simulations.

An Elastic Network Model was included to help preserve the overall protein fold during the coarse-grained simulation.

### Building the glycoprotein

Two N-linked glycosylation sites were selected:

```text
A 304 MAN5
A 308 MAN5
```

For this part of the workflow, MAN5 glycans were used rather than the Man9 glycans used during the initial GlycoSHIELD screening.

The Glycomarinate workflow was used to construct the coarse-grained glycoprotein.

`marinate_pdb` used GlycoSHIELD to select sterically compatible glycan conformers for the selected glycosylation sites and generated the initial coarse-grained glycoprotein structure:

```text
glyco_CG.pdb
```

The corresponding molecular topology was generated using `marinate_top`.

This step used a graph-based representation of the protein and glycans and connected glycan topology to the targeted asparagine residues using N-glycosylation linkage parameters.

The resulting glycoprotein topology was stored in:

```text
glyco_CG.itp
```

### Explicit membrane model

Unlike the first GlycoSHIELD analysis, where the membrane was represented only as a geometric boundary, this stage introduced an explicit lipid bilayer.

The glycoprotein was embedded in a POPC membrane using INSANE.

The resulting system contained:

```text
glycosylated protein
+
POPC lipid bilayer
+
coarse-grained water
+
Na+ and Cl- ions
```

The system was solvated using Martini coarse-grained water and neutralized with NaCl at a concentration of:

```text
0.15 M
```

### Molecular dynamics workflow

The prepared glycoprotein-membrane system was subjected to the standard molecular dynamics workflow:

```text
Energy minimization
        ↓
NVT equilibration
        ↓
NPT equilibration
        ↓
Production MD
```

Energy minimization was used to remove unfavorable contacts introduced during system construction.

NVT equilibration stabilized the system temperature at constant volume, while NPT equilibration allowed the system pressure, density and simulation box dimensions to adjust before production dynamics.

The workshop used shortened simulations for demonstration purposes:

| Stage | Simulation time |
|---|---:|
| NVT | 0.5 ns |
| NPT | 1 ns |
| Production MD | 5 ns |

The production simulation was performed without the position restraints used during equilibration, allowing the glycoprotein, glycans and membrane to evolve dynamically.

### Post-processing

Periodic boundary conditions were corrected using GROMACS trajectory processing tools so that molecules remained whole and the membrane could be visualized as a continuous bilayer.

Water and ions were removed from the visualization trajectory to reduce file size and simplify structural analysis.

This stage produced a simulation-ready framework in which glycan dynamics, membrane interactions and protein orientation can be investigated explicitly rather than approximated using a static membrane boundary.

---

## Part 3: Structural and orientation analysis

The molecular dynamics trajectory was analysed using MDAnalysis.

The analysed system contained thousands of coarse-grained beads and 201 trajectory frames.

Two structural regions were defined for orientation analysis:

```text
Ig domain
Transmembrane helix
```

The analysis focused on two complementary aspects:

1. structural deviation of the protein during the trajectory,
2. orientation of the extracellular domain relative to the membrane.

### Protein RMSD

Protein RMSD was calculated relative to the initial structure.

The RMSD increased rapidly during the beginning of the trajectory and subsequently fluctuated approximately within the range of several angstroms.

The trajectory therefore shows structural rearrangement relative to the starting structure rather than a completely rigid protein configuration.

At later stages of the analysed trajectory, the RMSD fluctuated mainly around approximately:

```text
4–7 Å
```

indicating continued conformational motion of the coarse-grained protein.

### Orientation analysis

The Z axis was treated as the membrane normal.

Three angles were calculated for every trajectory frame:

```text
Ig-domain axis vs membrane normal
Ig-domain axis vs transmembrane helix axis
Transmembrane helix axis vs membrane normal
```

#### Ig domain relative to the membrane normal

The Ig-domain axis remained at a large angle relative to the Z axis during most of the analysed trajectory.

Typical values were approximately:

```text
65–90°
```

This indicates that the extracellular domain remained strongly tilted relative to the membrane normal rather than adopting a consistently upright configuration.

#### Ig domain relative to the transmembrane helix

The angle between the Ig-domain axis and the transmembrane helix was also generally large:

```text
approximately 60–90°
```

showing substantial bending between the extracellular domain and the membrane-spanning region.

#### Transmembrane helix relative to the membrane normal

In contrast, the transmembrane helix remained much more closely aligned with the membrane normal.

Most values were approximately:

```text
5–25°
```

This indicates that the membrane-spanning helix maintained its expected orientation within the lipid bilayer while the extracellular domain showed considerably greater tilt.

---

## Overall interpretation

Together, the three stages provide a workflow for investigating how glycosylation may influence the structure and membrane orientation of CADM1.

The first GlycoSHIELD analysis showed that the conformational freedom of glycans depends strongly on their spatial environment. Introducing a membrane boundary caused a particularly strong reduction in accessible conformers at selected glycosylation sites.

This supports a possible mechanism in which glycan-membrane steric interactions create an entropic pressure that could favor orientations in which the glycan brush extends away from the membrane.

The coarse-grained modelling workflow then extended this static conformational analysis into an explicit molecular system containing the glycoprotein, POPC membrane, solvent and ions.

Finally, trajectory analysis showed that the transmembrane helix remained relatively aligned with the membrane normal, while the extracellular Ig domain remained strongly tilted and dynamically fluctuated during the analysed trajectory.

Therefore, the simulations provide a framework for investigating the proposed glycan-mediated orientation mechanism, but they do not by themselves demonstrate that glycosylation causes CADM1 to adopt an upright orientation.

A direct test of this hypothesis would require comparison between:

```text
glycosylated CADM1
        vs
unglycosylated CADM1
```

preferably using multiple independent and substantially longer molecular dynamics simulations.

Such a comparison would make it possible to determine whether glycosylation systematically changes the distribution of ectodomain tilt angles, glycan-membrane contacts and the conformational behavior of CADM1.

---

## Tools and methods

The workflow used:

- AlphaFold Protein Structure Database
- UniProt
- GlycoSHIELD
- Glycomarinate
- Polyply
- Martini 3
- martinize2
- INSANE
- GROMACS
- MDAnalysis
- NumPy
- pandas
- Matplotlib
- py3Dmol