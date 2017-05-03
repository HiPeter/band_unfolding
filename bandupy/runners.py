from subprocess import Popen, PIPE, STDOUT
import os
import sys
# Imports from within the package
from .constants import BANDUP_BIN, WORKING_DIR
from .files import (
    mkdir,
    create_bandup_input,
    create_bandup_plot_input,
)
from .plot import (
    print_opening_message,
    BandUpPlot, 
    produce_figure,
)
from .vasp import procar2bandup
from .orbital_contributions import get_unfolded_orb_projs

def run_bandup(args):
    #start_dir = os.getcwd()
    start_dir = WORKING_DIR
    # Running BandUP
    os.chdir(args.results_dir)
    bandup_run_options = [BANDUP_BIN] + args.argv
    with open("out_BandUP.dat", 'w') as f:
        bandup_run = Popen(bandup_run_options, stdout=PIPE, stderr=STDOUT)
        for line in iter(bandup_run.stdout.readline, ''):
            sys.stdout.write(line)
            f.write(line)
    if(args.orbitals):
        get_orbital_projections_and_duals(args)
    os.chdir(start_dir)

def make_plot(args):
    print_opening_message()
    os.chdir(args.plotdir)
    plot = BandUpPlot(args)
    produce_figure(plot)

def run_requested_task(args):
    if(args.main_task=='unfold'):
        mkdir(args.results_dir, ignore_existing=True)
        create_bandup_input(args)
        run_bandup(args)
    elif(args.main_task=='plot'):
        mkdir(args.plotdir, ignore_existing=True)
        create_bandup_plot_input(args)
        make_plot(args)
    elif(args.main_task=='pre-unfold'):
       pass
    if(args.main_task=='projected-unfold'):
        get_unfolded_orb_projs(args, clip_contributions=True, verbose=True)
    else:
        print 'Task "%s" not available.'%(args.main_task)

def get_orbital_projections_and_duals(args):
    if(args.qe or args.castep or args.abinit):
        raise ValueError('Orbital projections not yet implemented for current PW code!')
    else:
        procar2bandup(fpath=os.path.join(args.wavefunc_calc_dir, 'PROCAR'))
