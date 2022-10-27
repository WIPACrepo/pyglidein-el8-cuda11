FROM nvidia/cuda:11.8.0-cudnn8-devel-rockylinux8

RUN dnf -y upgrade
RUN dnf -y install epel-release dnf-plugins-core

RUN dnf config-manager --set-enabled powertools

# osg repo
RUN dnf -y install http://repo.opensciencegrid.org/osg/3.6/osg-3.6-el8-release-latest.rpm

# well rounded basic system to support a wide range of user jobs
RUN dnf -y group install "Development Tools" "Scientific Support"

RUN dnf -y install \
           astropy-tools \
           bc \
           binutils \
           binutils-devel \
           cmake \
           # coreutils \
           curl \
           davix-devel \
           dcap-devel \
           # doxygen \
           # dpm-devel \
           fontconfig \
           gcc \
           gcc-c++ \
           gcc-gfortran \
           git \
           # glew-devel \
           glib2-devel \
           # glib2-devel \
           # glib-devel \
           # globus-gass-copy-devel \
           graphviz \
           gfal2 \ 
           gsl-devel \
           # gtest-devel \
           java-1.8.0-openjdk \
           java-1.8.0-openjdk-devel \
           json-c-devel \
           # lfc-devel \
           hdf5 \
           libaec-devel \
           libattr-devel \
           libgfortran \
           libGLU \
           libgomp \
           libicu \
           libquadmath \
           libssh2-devel \
           libtool \
           libtool-ltdl \
           libtool-ltdl-devel \
           libuuid-devel \
           libX11-devel \
           libXaw-devel \
           libXext-devel \
           libXft-devel \
           libxml2 \
           libxml2-devel \
        #    libXmu-devel \
        #    libXpm \
        #    libXpm-devel \
        #    libXt \
        #    mesa-libGL-devel \
           nano \
           python3-numpy \
           # octave \
           # octave-devel \
           # openldap-devel \
           openssh \
           openssh-server \
           openssl \
           osg-wn-client \
           p7zip \
           p7zip-plugins \
           python3-astropy \
           python3-devel \
           # R-devel \
           redhat-lsb \
           redhat-lsb-core \
           rsync \
           python3-scipy \
           srm-ifce-devel \
           stashcache-client \
           subversion \
           tcl-devel \
           # tcsh \
           time \
           tk-devel \
           vim \
           wget \
           xrootd-client-devel \
           zlib-devel \
           which

# osg
RUN dnf -y install osg-wn-client \ 
    # osg-ca-certs \
    && rm -f /etc/grid-security/certificates/*.r0

# htcondor - include so we can chirp
RUN dnf -y install condor

# Cleaning caches to reduce size of image
RUN dnf clean all

# required directories
RUN for MNTPOINT in \
        /cvmfs \
    ; do \
        mkdir -p $MNTPOINT ; \
    done

# make sure we have a way to bind host provided libraries
# see https://github.com/singularityware/singularity/issues/611
RUN mkdir -p /etc/OpenCL/vendors

ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:/.singularity.d/libs
ENV PATH=/usr/local/cuda/bin:/usr/local/bin:/usr/bin:/bin

# build info
RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt

