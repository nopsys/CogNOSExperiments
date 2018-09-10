# Experiments
This repository aims at helping to automatically perform experiments to analyze different aspects of the CogNOS system. In addition, it also provides R script to process the resulting data and plot some information.

## Disclaimer
Running this set of experiments requires a complex configuration of virtual machines, operating systems, compilers, etc. 
This repository contains scripts to ease their construction as much as possible. However, note that there is still significant tasks that must be done manually.

## Dependencies

[CogNOS dependencies](https://github.com/nopsys/CogNOS/blob/master/Documentation/building.md), [Rebench](http://github.com/smarr/reBench/).

To run the bootloading experiments the user must have installed 3 VirtualBox VMs containing different operating systemns: 

- a Minix3.
- An Ubuntu server. 
- An Ubuntu Desktop.

If you are interested only on the performance experiments, the Ubuntu desktop is enough.

## Setup

### In the machine that will run the experiments
    
    git clone https://github.com/nopsys/CogNOSexperiments
    cd CogNOSexperiments
    scripts/setup.sh
    
### In the Ubuntu Desktop Machine    

    git clone https://github.com/nopsys/CogNOSexperiments
    cd CogNOSexperiments
    scripts/setup.sh -includeUnix
   
## Configuration
The name of the VMs and many other configuration parameters can be managed by editing [the configuration file](scripts/config.inc)

## Running
To run the Performance experiments:

    cd Performance
    sudo rebench cognos.conf

## Reports
The reporting infrastructure depends on [knitr](https://yihui.name/knitr/) to generate a latex file with all the information and the corresponding plots.

To generate this file (report.tex) and the images (images directory):
    
    cd Report
    ./compile.sh report.Rnw 

To copy report.tex and the images to another directory, for instance, a paper that uses this information:
   
    cd ..
    ./scripts/update-paper.sh
    
Note that previously, you will have to setup the target directory in [update-paper.sh](scripts/update-paper.sh)     
   
