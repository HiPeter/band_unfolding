#!/bin/bash

ulimit -s unlimited
export OMP_NUM_THREADS=8 # Choose 1 if you do not want openmp parallelization. I normally use n_cores/2
working_dir=`pwd`

bandup_folder="${HOME}/work/band_unfolding/BandUP" # Path to where BandUP is. Modify this line to suit your folder tree.
BandUp_exe=${bandup_folder}/BandUP_bin/BandUP.x
plot_script=${bandup_folder}/utils/post_unfolding/plot/plot_unfolded_EBS_BandUP.py
common_plot_folder=${working_dir}/plot
inputs_for_plot_folder="${working_dir}/input_files_plot"

sc_calc_folder="${working_dir}/../step_1_get_converged_CHGCAR"
E_Fermi=`grep 'E-fermi' "${sc_calc_folder}/OUTCAR" | tail -1 | awk '{split($0,array," ")} END{print array[3]}'`


wavecar_calc_dir="${working_dir}/../step_3_get_SC_wavefunctions_to_be_used_for_unfolding"
pcbz_kpts_folder="${working_dir}/../step_2_get_kpts_to_be_used_in_the_SC_band_struc_calcs/input_files"
prim_cell_lattice_file_folder="${working_dir}/../step_2_get_kpts_to_be_used_in_the_SC_band_struc_calcs/input_files"
prim_cell_lattice_file="${prim_cell_lattice_file_folder}/prim_cell_lattice.in"
supercell_lattice_file="${working_dir}/../step_2_get_kpts_to_be_used_in_the_SC_band_struc_calcs/input_files/supercell_lattice.in"

for dir in "K-G_G-M_M-K"
do
echo "Getting EBS along direction ${dir}..."
current_wavecar_folder="${wavecar_calc_dir}/to_unfold_onto_pcbz_direc_${dir}"
current_band_unfolding_folder="band_unfolding_onto_direc_${dir}"
KPOINTS_prim_cell_file=${pcbz_kpts_folder}/KPOINTS_prim_cell_${dir}.in

rm -rf ${current_band_unfolding_folder}
mkdir -p ${current_band_unfolding_folder}
cd ${current_band_unfolding_folder}

rm -f KPOINTS_prim_cell.in
cp $KPOINTS_prim_cell_file KPOINTS_prim_cell.in
rm -f prim_cell_lattice.in
cp $prim_cell_lattice_file prim_cell_lattice.in
rm -f supercell_lattice.in
cp $supercell_lattice_file supercell_lattice.in

if [ "$dir" == 'K-G_G-M_M-K' ]; then
    emin="-20.0"
    emax="  5.0"
    dE=0.100
else
    emin="-1.2"
    emax=" 1.2"
    dE=0.050
fi
cat >energy_info.in <<!
${E_Fermi} # E-fermi
${emin}
${emax}
${dE}
!

# Running BandUP
ln -s ${current_wavecar_folder}/WAVECAR WAVECAR
rm -f exe.x
ln -s $BandUp_exe exe.x
./exe.x | tee out_BandUP_dir_${dir}.dat 
rm -f exe.x

# Producing the plot
mkdir -p ${inputs_for_plot_folder}
cp -f $KPOINTS_prim_cell_file ${inputs_for_plot_folder}
cp -f $prim_cell_lattice_file ${inputs_for_plot_folder}
cat >"${inputs_for_plot_folder}"/energy_info_for_dir_${dir}.in <<!
${E_Fermi} # E-fermi
${emin}
${emax}
${dE}
!
plot_folder="${common_plot_folder}/direction_${dir}"
rm -rf ${plot_folder}
mkdir -p ${plot_folder}
cp unfolded_EBS_not-symmetry_averaged.dat ${plot_folder}
cp unfolded_EBS_symmetry-averaged.dat ${plot_folder}
cp "${inputs_for_plot_folder}"/energy_info_for_dir_${dir}.in ${plot_folder}/energy_info.in
cp "${inputs_for_plot_folder}"/KPOINTS_prim_cell_${dir}.in ${plot_folder}/KPOINTS_prim_cell.in
cp "${inputs_for_plot_folder}"/prim_cell_lattice.in ${plot_folder}
ln -s ${plot_script} ${plot_folder}/plot_unfolded_EBS_BandUP.py

cd ${plot_folder}
    if [ "$dir" == 'K-G_G-M_M-K' ]; then
        ./plot_unfolded_EBS_BandUP.py unfolded_EBS_symmetry-averaged.dat --show --save &
    else
        ./plot_unfolded_EBS_BandUP.py unfolded_EBS_symmetry-averaged.dat -vmax 2 -vmin 0 --landscape --no_cb --show --save &
    fi
cd ${working_dir}

done

cd ${working_dir}
