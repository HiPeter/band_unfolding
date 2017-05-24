######################################################################
## BandUP: Band Unfolding code for Plane-wave based calculations             
######################################################################
###### Copyright (C) 2013-2017 Paulo V. C. Medeiros - pvm20@cam.ac.uk
##### Please visit http://www.ifm.liu.se/theomod/compphys/band-unfolding

BandUP is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

BandUP is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with BandUP.  If not, see <http://www.gnu.org/licenses/>.

<!-- =========================================================== -->
#### Plane-wave codes currently supported by BandUP
-----------------------------------------------
    * At the moment, BandUP can parse wavefunctions generated by: 
        * VASP
        * Quantum ESPRESSO
        * ABINIT
        * CASTEP (tested with academic version; currently available only upon request)
    * If you use another plane-wave (PW) code and would like to have 
      support to it added in BandUP
        * Please *send me a subroutine to read the wavefunctions
          produced by your code*. Take a look at the routines we have
          already implemented for the other PW codes to have an idea
          of how your subroutine's interface should look like. I am 
          more than happy to assist you with this.
        * If you don't know how to write such a subroutine, then
          of course, I'll do my best to help you out anyway, so please
          contact me. Due to limitations in time and resources,
          however, I cannot unfortunately guarantee I'll be able to do 
          this as quickly as you (and I, for that matter) might wish

<!-- =========================================================== -->
#### How to compile BandUP
-----------------------------------------------
    * Run the "build" script: ./build
        * Please *run "./build -h" for more information* (usage,        
          choosing compilers, etc.)
    * A symlink named "bandup" will be created in this directory 
      if compilation is successful. 
        * This is a single executable that wraps all BandUP main
          functionalities:
            * Getting SC-Kpoints pre-unfolding (task "kpts-sc-get")
            * Actual unfolding code (task "unfold")
            * Plotting (task "plot")
            * Atom/orbital-decomposed unfolded band structure 
             (task "projected-unfold", currently only for VASP)
    * If installation doesn't go well, please double-check the system
      requirements below abd make sure they have all been fulfilled. 
      If you still cannot install BandUP after having done this, then
      please contact us. But I insist: *Check the system requirements 
      first*. Most installation problems reported to us are caused by 
      failure to do so

<!-- =========================================================== -->
#### How to use BandUP
-----------------------------------------------
    * The easiest way to understand how BandUP works is to go through
      the examples under the "tutorial" directory
    * If what you want to do is not covered by the tutorials, then 
      *please run BandUP with the option "-h"* to see a list of all
      supported options and for more information about usage
    * If you have done as indicated above, and still cannot find what
      you want, then please contact us

<!-- =========================================================== -->
#### System requirements:
-----------------------------------------------
    * Preferably Linux
        * Might work in other environments based on Unix
    * Fortran 95 and C compilers
        * Preferably Intel compilers (ifort and icc), v>=15.0.3
        * Should work with GNU compilers (gfortran and gcc) v>=5.2 too
    * Python 2.X (X>=7) (NB: Mandatory since BandUP V3.0.0)
        * You might need to install the following packages (but try
          running the code before worrying about this -- you might 
          already have them) 
            * numpy 
            * scipy
            * matplotlib
            * six
        * Optional: Either PyQt4 or PyQt5
            * This only needed only you wish to use the GUI version of
              the plotting tool.
            * If the GUI doesn't work with you, you can keep using the
              plotting tool in the command line, just as usual. 
              I'd appreciate, however, it if you'd let me
              know should this happen -- even though I can't promise
              to provide quick assistance with GUI-related issues, as 
              everything can be done without it.
        * If you don't have any of the Python packages listed above,
          you can easily install them using, e.g., pip. For instance,
                        "pip install --user matplotlib"
          should make matplotlib available in your Python install
        * Standard python library modules used (just for reference, as 
          they come with python; the list might even be incomplete):
            * argparse
            * os
            * sys
            * time
            * subprocess
            * fractions
            * json
            * shutil
            * collections
            * glob
            * pickle
            * errno
            * itertools
            * warnings
        * *Please let me know if I've forgotten to list any other
          non-standard python package!
            
<!-- =========================================================== -->
#### Publications:
-----------------------------------------------
    * If you use BandUP (or any part or modified version of it) in
      your work, you should:
          * State EXPLICITLY that you've used the BandUP code (or 
            a modified version of it).
          * Read and cite the following papers (and the appropriate
            references therein):

            >>> Phys. Rev. B 89, 041407(R) (2014) 
                <http://dx.doi.org/10.1103/PhysRevB.89.041407>

            >>> Phys. Rev. B 91, 041116(R) (2015) 
                <http://dx.doi.org/10.1103/PhysRevB.91.041116>

      * An appropriate way of acknowledging the use of BandUP in your
        publications would be, for instance, adding a sentence like: 
          "The unfolding has been performed using the BandUP code",
        followed by the citation to our papers.

<!-- =========================================================== -->
#### IMPORTANT: Major changes in V3.0.0:
-----------------------------------------------
    * As of May 2017, you should use the *executable "bandup"* for 
      *all BandUP tasks*. This is a Python script that provides an
      interface to the fortran binaries "get_SCKPTS_pre_BandUP.x" and 
      "BandUP.x" that needed to be executed directly in previous 
      versions. The new "bandup" executable also provides a "plot" 
      task which reimplements the previously available plotting tool 
      "plot_unfolded_EBS_BandUP.py" and its GUI -- both of which no
       longer exist as individual scripts since V3.0.0.
    * The individual fortran executables maintain back-compatibility, 
      but the older (V<3) bash scripts provided in the tutorials will 
      most likely not work with the script "bandup" in BandUP V>3. The
      tutorials have been updated and provide new bash scripts that 
      are compatible with BandUP V3. These new scripts are much 
      simpler than their previous counterparts. If you were using the
      deprecated scripts in your actual calculations (which you didn't
      need to), please replace them by the new ones to be able to use
      BandUP V3. Note, nonetheless, that you still don't necessarily 
      need any bash script to run BandUP. The scripts provided in the 
      tutorials serve primarily as practical tools to illustrate how 
      BandUP can be executed from the command line.
    * The *general syntax for bandup* is now:
                    bandup <task> <task_options>
    * *If you keep the directory structure used in the examples*, then
      BandUP will look for input/output files on the appropriate 
      directories (step_1*, step_2*, etc.). Otherwise, you'll need to
      copy/link them manually to wherever you intend to run BandUP,
      or, alternatively, you'll need to use the task-specific options
      to inform BandUP about the location of these files  
    * Running *"bandup -h"* with will print help about the available 
      tasks and general usage
    * Running *"bandup <task> -h"* will print specific help for the 
      requested task

<!-- =========================================================== -->
#### Tips (some of which highligh things already mentioned above):
-----------------------------------------------
    * BandUP accepts some *optional command line arguments and flags*.
      To find out more about them, *please don't be shy to use '-h'!*
        * Running *"bandup -h"* with will print help about the
          available tasks and general usage
        * Running *"bandup <task> -h"* will print specific help for
          the requested task
    * Since BandUP's plotting task has a lot of different options,
      I've given it a GUI. You can launch it by using the option
      "--gui" when launching BandUP with the task "plot".
        * This requires that either PyQt4 or PyQt5 is available in
          your python install. If the GUI doesn't work for you, 
          however, you can still make the plots using the command line
    * It might be handy placing a symlink to the "bandup" executable
      in some directory that belongs to your PATH. Alternatively (but 
      less desirably), you can include the current directory in your
      PATH is you prefer to do so. In either case, you'll then be able
      to use BandUP in whataver directory you're working at.


<!-- =========================================================== -->
#### Please mind that:
-----------------------------------------------
    * Although we have very limited time and resources, we do our best
      to provide good user support. You can help us to continue to do
      so by makink sure to *do the following before writing to us for
      assistance*:
        * Cerify that all system requirements are met
        * Certify that you are using the latest version of BandUP
        * *Make use of the help ("-h") options*. Most of the times,
          what you need is already explained there! 
    * I've tried to make compilation as simple as possible - and it
      has indeed worked fine with many combinations of compilers, OSs
      and computers. I cannot, however, guarantee that it will always
      work smoothly. You might eventually need to play a bit with the
      scripts and, very rarely, with the Makefiles and source code.
    * In the calculations and tests I've performed with BandUP so far, 
      I've mostly used intel compilers (v. 15.0.3) and, a few times,
      also GNU compilers (v. 5.2). I *believe* you should have no
      problem using other versions of ifort/icc, as well as more 
      recent versions of gfortran/gcc. Mind, however, that I cannot 
      guarantee that this will always be the case. It is better to 
      make sure you use the supported compilers (the GNUs are free)
    * Last, but not least: Always check the results with a critical
      eye, specially if they don't look the way you think they are
      supposed to. Please notify me if weird stuff happens and you
      think it's the code's fault (but do double-check first)!

<!-- =========================================================== -->
#### For developers/collaborators: Semantic versioning and other conventions
-----------------------------------------------
The idea here (as of v3.0.0-beta.1) is to automate semantic versioningi -- fully
for any development branche, and at least partially for master. To this end, the
following workflow must be adopted:
(i)    Every time something new is to be introduced in the code, use the "devel" branch
       or create another branch if appropriate. If working on an existing branch, then,
       before doing anything, make sure to pull in any eventual new changes from master
       (which should be up-to-date with the remote master).
       Once you are happy with the code in the branch, and are convinced that it has no
       obvious bugs, then go to (ii).
(ii)   Make sure again the code to be merged has been tested and has no obvious bugs.
(ii)   Before making the commit to be merged into master, the value attributed to the 
       constant "tag_for_push" (in the file "constants_and_types_mod.f90" under "src") 
       must be updated. This must be done in accordance with the semantic versioning 
       set of conventions (2.0) -- see <http://semver.org>.
(iii)  After making sure to comply with the items above, merge the branch into master 
(iv)   Before pushing the merge commit, it must be tagged. Moreover: The created tag
       must be (a) identical to the value attributed to "tag_for_push" in item (ii),
       and (b) annotated -- see <https://git-scm.com/book/en/v2/Git-Basics-Tagging>.
       I use script for (iii) and (iv). I retrieves the value of "tag_for_push" from 
       this file, merges the changes made in the branch into master, and then 
       automatically creates the appropriate annotated tag with a message I choose.
(v)    Now, double-check everything. This is the last chance to correct mistakes in a 
       straightforward manner.
(vi)   Finally, push to the remote repo.
By doing so, you will help me greatly and things are very likely to go smooth.
Now, if you don't know git, but have implemented something you think would help
improve BandUP and wants to share it with me, please send the file(s) to me via
email. But I recommend you learn git if you are modifying BandUP source files.

##### Have fun!
