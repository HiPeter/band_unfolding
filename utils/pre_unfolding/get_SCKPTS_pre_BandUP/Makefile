# Adapted from: 
#     Makefile-Fortran: A Makefile for a simple Fortran project
#     Copyright (C) 2009 Davide Cesari, dcesari <at> arpa.emr.it
#     Available at http://www.webalice.it/o.drofa/davide/makefile-fortran/makefile-fortran.html
#     Distributed according to the GNU GPL license.
#     This makefile works with the GNU make command, the one find on
#     GNU/Linux systems and often called gmake on non-GNU systems
# ======================================================================
# Declarations
# ======================================================================
# The compiler
FC = ifort
# Required flags: "-assume byterecl" is required for the compilation of the read_wavecar_mod module
FCFLAGS = -assume byterecl 
# Shared memory parallelization
FCFLAGS += -openmp -parallel
# Flags for maximum performance, portability, etc. Comment (or modify) as necessary.
FCFLAGS += -O2 -no-ipo # ipo was causing a few problems.
# Enable/disable warnings and remarks
FCFLAGS += -diag-disable remark

# Aliases
current_dir = $(shell pwd)
BandUP_src_folder = $(current_dir)/../../../src/
cla_folder = $(BandUP_src_folder)/external/claf90
spglib_folder = $(BandUP_src_folder)/external/spglib-1.5.2
vasp_related_modules_folder = $(BandUP_src_folder)/vasp_related_modules
qe_related_modules_folder = $(BandUP_src_folder)/qe_related_modules
abinit_related_modules_folder = $(BandUP_src_folder)/abinit_related_modules
espresso_folder = $(BandUP_src_folder)/external/espresso-5.1_modules_for_BandUP
QE_modules=$(espresso_folder)/Modules
QE_iotk=$(espresso_folder)/iotk/src
QE_flib=$(espresso_folder)/flib
QE_clib=$(espresso_folder)/clib

# libraries needed for linking
LIBS = $(spglib_folder)/src/.libs/libsymspg.a
LIBS += $(QE_modules)/libqemod.a $(QE_flib)/ptools.a $(QE_flib)/flib.a $(QE_clib)/clib.a $(QE_iotk)/libiotk.a
# Additional module search paths
FCFLAGS += -I$(espresso_folder)/Modules -I$(espresso_folder)/iotk/src

# Folders containing needed sources
vpath %.f90 $(cla_folder)
vpath %.f90 $(spglib_folder)/example
vpath %.f90 $(BandUP_src_folder)
vpath %.f90 $(vasp_related_modules_folder)
vpath %.f90 $(qe_related_modules_folder)
vpath %.f90 $(abinit_related_modules_folder)

# List of executables to be built within the package
SRC = main_get_SCKPTS_pre_BandUP.f90
OBJ = ${SRC:.f90=.o}
EXE = get_SCKPTS_pre_BandUP.x

# "make" builds all
all: $(EXE)

cla.o: kinds.o
math_mod.o: constants_and_types_mod.o spglib_f08.o
general_io_mod.o: constants_and_types_mod.o math_mod.o
cla_wrappers_mod.o: general_io_mod.o kinds.o cla.o constants_and_types_mod.o
read_vasp_files_mod.o: constants_and_types_mod.o math_mod.o general_io_mod.o strings_mod.o
write_vasp_files_mod.o: constants_and_types_mod.o math_mod.o general_io_mod.o strings_mod.o
read_wavecar_mod.o: constants_and_types_mod.o math_mod.o general_io_mod.o
read_qe_wavefunctions_mod.o: constants_and_types_mod.o cla_wrappers_mod.o math_mod.o general_io_mod.o
read_abinit_wavefunctions_mod.o: constants_and_types_mod.o math_mod.o general_io_mod.o
io_routines_mod.o: constants_and_types_mod.o math_mod.o cla_wrappers_mod.o strings_mod.o \
                   general_io_mod.o read_vasp_files_mod.o write_vasp_files_mod.o \
                   read_wavecar_mod.o read_qe_wavefunctions_mod.o read_abinit_wavefunctions_mod.o
band_unfolding_routines_mod.o: constants_and_types_mod.o cla_wrappers_mod.o math_mod.o \
                               general_io_mod.o io_routines_mod.o
$(OBJ): cla.o kinds.o constants_and_types_mod.o cla_wrappers_mod.o spglib_f08.o math_mod.o \
        io_routines_mod.o read_wavecar_mod.o read_vasp_files_mod.o write_vasp_files_mod.o \
        read_qe_wavefunctions_mod.o read_abinit_wavefunctions_mod.o band_unfolding_routines_mod.o
$(EXE): cla.o kinds.o constants_and_types_mod.o cla_wrappers_mod.o spglib_f08.o math_mod.o \
        band_unfolding_routines_mod.o general_io_mod.o read_wavecar_mod.o read_vasp_files_mod.o \
        read_qe_wavefunctions_mod.o read_abinit_wavefunctions_mod.o write_vasp_files_mod.o \
        strings_mod.o io_routines_mod.o $(OBJ)
# ======================================================================
# General rules
# ======================================================================
$(EXE): $(OBJ)
	$(FC) $(FCFLAGS) $(LDFLAGS) $^ $(LIBS) -o $@

%.o: %.f90
	$(FC) $(FCFLAGS) -c $<

%.o: %.F90
	$(FC) $(FCFLAGS) -c $<

# Utility targets
.PHONY: clean veryclean

clean:
	rm -f *.o *.mod *.MOD

veryclean: clean
	rm -f *~ $(EXE)
