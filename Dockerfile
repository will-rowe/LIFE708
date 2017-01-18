################################################################################################
# This is the Dockerfile for the LIFE708 teaching materials
################################################################################################
FROM ubuntu:14.04
MAINTAINER Will Rowe <will.rowe@liverpool.ac.uk>


################################################################################################
# Install core packages
################################################################################################
RUN apt-get update && apt-get install -y \
  curl \
  cmake \
  dh-autoreconf \
  git \
  libhdf5-serial-dev \
  libncurses5-dev \
  make \
  nano \
  unzip \
  wget \
  --force-yes


################################################################################################
# Install Java, Python (2 + 3) and BioPython
################################################################################################
RUN apt-get install -y \
  default-jre \
  python2.7 \
  python3 \
  python-dev \
  python-pip \
  python3-pip \
  python-virtualenv \
  python-numpy \
  python-matplotlib \
  python-biopython=1.63-1


################################################################################################
# Install Artemis and ACT
################################################################################################
RUN cd /opt && \
  wget --no-check-certificate ftp://ftp.sanger.ac.uk/pub/resources/software/artemis/artemis.tar.gz && \
  tar -xvf artemis.tar.gz && \
  rm -rf /opt/artemis.tar.gz


################################################################################################
# Install Cutadapt and PySam using pip
################################################################################################
RUN pip install --install-option="--prefix=/usr" cutadapt==1.10
RUN pip install pysam==0.9.0


################################################################################################
# Install NCBI-blast
################################################################################################
RUN cd /opt && \
  wget --no-check-certificate ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.6.0+-x64-linux.tar.gz && \
  tar -xvf ncbi-blast-2.6.0+-x64-linux.tar.gz && \
  ln -s /opt/ncbi-blast-2.6.0+/bin/* /usr/local/bin/ && \
  rm -rf ncbi-blast-2.6.0+-x64-linux.tar.gz


################################################################################################
# Install Prodigal
################################################################################################
RUN cd /opt && \
  wget --no-check-certificate https://github.com/hyattpd/Prodigal/releases/download/v2.6.3/prodigal.linux -O prodigal && \
  ln -s /opt/prodigal /usr/local/bin/prodigal


################################################################################################
# Install Prokka and dependencies
################################################################################################
RUN cd /opt && \
  apt-get install -y libdatetime-perl libxml-simple-perl libdigest-md5-perl bioperl && \
  git clone git://github.com/tseemann/prokka.git && \
  prokka/bin/prokka --setupdb && \
  ln -s /opt/prokka/bin/* /usr/local/bin/


################################################################################################
# Install Samtools v1.3.1
################################################################################################
RUN cd /opt && \
  wget --no-check-certificate https://github.com/samtools/samtools/releases/download/1.3.1/samtools-1.3.1.tar.bz2 && \
  tar -xvf samtools-1.3.1.tar.bz2 && \
  cd samtools-1.3.1 && \
  ./configure && \
  make && \
  make PREFIX=/opt/samtools-1.3.1 install && \
  ln -s /opt/samtools-1.3.1/bin/* /usr/local/bin/ && \
  rm -rf /opt/samtools-1.3.1.tar.bz2


################################################################################################
# Install SMALT and dependencies
################################################################################################
RUN cd /opt && \
    apt-get install -y zlib1g-dev libncurses5-dev libncursesw5-dev && \
    wget http://downloads.sourceforge.net/project/mummer/mummer/3.23/MUMmer3.23.tar.gz && \
    tar -zxf MUMmer3.23.tar.gz && \
    cd MUMmer3.23 && \
    make && \
    mkdir bin && \
    mv annotate combineMUMs delta-filter dnadiff exact-tandems gaps m* n* p* r* sh* ./bin && \
    ln -s /opt/MUMmer3.23/bin/* /usr/local/bin/ && \
    cd .. && \
    for x in `find MUMmer3.23/ -maxdepth 1 -executable -type f`; do cp -s $x . ; done && \
    rm -rf MUMmer3.23.tar.gz && \
    wget http://downloads.sourceforge.net/project/smalt/smalt-0.7.6-bin.tar.gz && \
    tar -zxf smalt-0.7.6-bin.tar.gz && \
    cp smalt-0.7.6-bin/smalt_x86_64 /usr/local/bin/smalt && \
    rm -rf smalt-0.7.6-bin.tar.gz


################################################################################################
# Install SPAdes
################################################################################################
RUN cd /opt && \
  wget --no-check-certificate http://cab.spbu.ru/files/release3.9.1/SPAdes-3.9.1-Linux.tar.gz && \
  tar -xvf SPAdes-3.9.1-Linux.tar.gz && \
  ln -s /opt/SPAdes-3.9.1-Linux/bin/* /usr/local/bin/ && \
  rm -rf SPAdes-3.9.1-Linux.tar.gz


################################################################################################
# Install Velvet
################################################################################################
RUN cd /opt && \
  git clone git://github.com/dzerbino/velvet && \
  cd velvet && \
  make color && \
  ln -s /opt/velvet/velvet* /usr/local/bin/


################################################################################################
# Install VSearch
################################################################################################
RUN cd /opt && \
  git clone git://github.com/torognes/vsearch && \
  cd vsearch && \
  ./autogen.sh && \
  ./configure && \
  automake && \
  make && \
  make install && \
  cp ./bin/vsearch /usr/local/bin/ && \
  rm -rf /opt/vsearch


################################################################################################
# Install additional software using apt-get
################################################################################################
RUN apt-get install -y \
  bedtools=2.17.0-1 \
  bowtie2=2.1.0-2 \
  bwa=0.7.5a-2 \
  cd-hit=4.6.1-2012-08-27-2 \
  fastqc=0.10.1+dfsg-2 \
  fastx-toolkit=0.0.14-1 \
  HMMER=3.1b1-3 \
  --force-yes


################################################################################################
# Clone the github repo, add any python/shell scripts, create bash profile and clean cache
################################################################################################
RUN cd /opt && \
  git clone https://github.com/will-rowe/LIFE708.git && \
  mkdir /opt/scripts && \
  find /opt/LIFE708/scripts/ -type f -name '*.py' -exec cp {} /opt/scripts/ \; && \
  find /opt/LIFE708/scripts/ -type f -name '*.sh' -exec cp {} /opt/scripts/ \; && \
  ln -s /opt/scripts/* /usr/local/bin/ && \
  cp /opt/LIFE708/bashrc ~/.bashrc && \
  rm -rf /var/lib/apt/lists/*


################################################################################################
# Define working directory and define default command for container launch
################################################################################################
RUN mkdir /SCRATCH
WORKDIR /SCRATCH
CMD ["bash"]
