FROM ubuntu:16.04

LABEL maintainer="Cedric Gerber <gerber.cedric@gmail.com>"


#Install all packages needed
#see https://askubuntu.com/questions/551840/unable-to-locate-package-libc6-dbgi386-in-docker
#http://processors.wiki.ti.com/index.php/Linux_Host_Support_CCSv6

RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y \
  libc6:i386                    \
  libx11-6:i386                 \
  libasound2:i386               \
  libatk1.0-0:i386              \
  libcairo2:i386                \
  libcups2:i386                 \
  libdbus-glib-1-2:i386         \
  libgconf-2-4:i386             \
  libgcrypt20:i386              \
  libgdk-pixbuf2.0-0:i386       \
  libgtk-3-0:i386               \
  libice6:i386                  \
  libncurses5:i386              \
  libsm6:i386                   \
  liborbit2:i386                \
  libudev1:i386                 \
  libusb-0.1-4:i386             \
  libstdc++6:i386               \
  libstdc++6					\
  libxt6						\
  libxt6:i386                   \
  libxtst6:i386                 \
  libgnomeui-0:i386             \
  libusb-1.0-0-dev:i386         \
  libcanberra-gtk-module:i386   \
  gtk2-engines-murrine:i386     \
  libpython2.7				    \
  unzip         				\
  wget

# Install missing library
WORKDIR /ccs_install
RUN wget https://launchpad.net/ubuntu/+archive/primary/+files/libgcrypt11_1.5.3-2ubuntu4.2_amd64.deb && dpkg -i libgcrypt11_1.5.3-2ubuntu4.2_amd64.deb

#Install udev http://ucsolutions.blogspot.ch/2014/06/problems-during-installation-code.html
COPY libudev0_175-0ubuntu19_i386.deb /ccs_install/libudev0_175-0ubuntu19_i386.deb
RUN dpkg -i /ccs_install/libudev0_175-0ubuntu19_i386.deb

RUN export JAVA_TOOL_OPTIONS=-Xss1280k

#To avoid issue with /ccs/ccsv7/ccs_base/emulation/Blackhawk/Install/bh_driver_install.sh (Currently the setup is only used for building)
RUN mkdir /etc/udev/rules.d

#Files which define which ccs feature to install
COPY response_custom.txt /ccs_install

# To create a new one uncomment this
# RUN /ccs_install/CCS7.3.0.00019_linux-x64/ccs_setup_linux64_7.3.0.00019.bin --mode unattended --prefix /ccs/  --save-response-file /ccs/response.txt --skip-install true

#ADD automatically extracts the archive  
ADD CCS7.3.0.00019_linux-x64.tar.gz /ccs_install

# Install ccs in unattended mode
#https://e2e.ti.com/support/development_tools/code_composer_studio/f/81/t/374161
RUN /ccs_install/CCS7.3.0.00019_linux-x64/ccs_setup_linux64_7.3.0.00019.bin --mode unattended --prefix /opt/ti --response-file /ccs_install/response_custom.txt 	

#cleanup

COPY ti_cgt_tms470_16.9.4.LTS_linux_installer_x86.bin /ccs_install/ti_cgt_tms470_16.9.4.LTS_linux_installer_x86.bin
RUN /ccs_install/ti_cgt_tms470_16.9.4.LTS_linux_installer_x86.bin --prefix /opt/ti --unattendedmodeui minimal

COPY CC3200SDK_1.3.0/ /opt/ti/CC3200SDK_1.3.0

COPY ti_replace_variable.py /scripts/ti_replace_variable.py

# TODO: do this in the same step as the ADD and RUN install to remove 800MB in the image.
#RUN rm -r /ccs_install

RUN PATH=$PATH:/opt/ti/ccsv7/eclipse

# workspace folder for CCS
RUN mkdir /workspace

# directory for the ccs project
VOLUME /workdir
WORKDIR /workdir


# if needed
#ENTRYPOINT []