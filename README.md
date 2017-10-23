# ccs-v7-ci
Dockerfile to build a code composer studio v7 container for continues integration/build/test

# To download on TI site :
- CCS7.3.0.00019_linux-x64.tar.gz
- ti_cgt_tms470_16.9.4.LTS_linux_installer_x86.bin
- libudev0_175-0ubuntu19_i386.deb
- CC3200SDK_1.3.0 folder which you can get by running the sdk exe on windows.


# To use it:
 
## build
docker build -t ccs .

## run
docker run -ti -v C:\\workspace\\roomzscreen:/workdir ccs /bin/bash

## import project
/opt/ti/ccsv7/eclipse/eclipse -noSplash -data "/workspace" -application com.ti.ccstudio.apps.projectImport -ccs.location /workdir/<projectName>/

## build
/opt/ti/ccsv7/eclipse/eclipse -noSplash -data "/workspace" -application com.ti.ccstudio.apps.projectBuild  -ccs.workspace -ccs.setBuildOption com.ti.ccstudio.buildDefinitions.C6000_6.1.compilerID.QUIET_LEVEL com.ti.ccstudio.buildDefinitions.C6000_6.1.compilerID.QUIET_LEVEL.VERBOSE
