################################################################################################
# This is the Dockerfile for the LIFE708 teaching materials
################################################################################################
# Base image
FROM ubuntu:14.04

# Maintainer
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
  vim \
  wget \
  --force-yes && \
  apt-get autoclean && \
  apt-get autoremove -y


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
# Install ABySS and dependencies
################################################################################################
RUN cd /opt && \
  git clone https://github.com/sparsehash/sparsehash && \
  cd sparsehash && \
  ./configure && \
  make && \
  make install && \
  cd /opt  && \
  git clone https://github.com/bcgsc/abyss && \
  cd /opt/abyss && \
  wget http://downloads.sourceforge.net/project/boost/boost/1.56.0/boost_1_56_0.tar.bz2 && \
  tar -xvf boost_1_56_0.tar.bz2 && \
  ./autogen.sh && \
  ./configure && \
  make && \
  make install


################################################################################################
# Install Artemis and ACT
################################################################################################
RUN cd /opt && \
  wget --no-check-certificate ftp://ftp.sanger.ac.uk/pub/resources/software/artemis/artemis.tar.gz && \
  tar -xvf artemis.tar.gz && \
  ln -s /opt/artemis/act /usr/local/bin/ && \
  ln -s /opt/artemis/art /usr/local/bin/ && \
  rm -rf /opt/artemis.tar.gz


################################################################################################
# Install Assembly Statistics
################################################################################################
RUN cd /opt && \
  git clone https://github.com/sanger-pathogens/assembly-stats && \
  mkdir assembly-stats/build && \
  cd assembly-stats/build && \
  cmake .. && \
  make && \
  make install


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
  ln -s /opt/prokka/bin/* /usr/local/bin/ && \
  apt-get autoclean && \
  apt-get autoremove -y && \
  ln -s /usr/bin/perl /usr/local/bin/perl && \
  wget ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/linux64.tbl2asn.gz && \
  gunzip linux64.tbl2asn.gz && \
  chmod a+rwx linux64.tbl2asn && \
  ln -s /opt/linux64.tbl2asn /usr/local/bin/tbl2asn


################################################################################################
# Install Prokka and dependencies
################################################################################################
RUN cd /opt && \
  mkdir PAGIT-install && \
  cd PAGIT-install && \
  wget ftp://ftp.sanger.ac.uk/pub/resources/software/pagit/PAGIT.V1.64bit.tgz && \
  tar -xvf PAGIT.V1.64bit.tgz && \
  bash ./installme.sh


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
   rm -rf smalt-0.7.6-bin.tar.gz && \
   apt-get autoclean && \
   apt-get autoremove -y


################################################################################################
# Install SPAdes
################################################################################################
RUN cd /opt && \
  wget --no-check-certificate http://cab.spbu.ru/files/release3.9.1/SPAdes-3.9.1-Linux.tar.gz && \
  tar -xvf SPAdes-3.9.1-Linux.tar.gz && \
  ln -s /opt/SPAdes-3.9.1-Linux/bin/* /usr/local/bin/ && \
  rm -rf SPAdes-3.9.1-Linux.tar.gz


################################################################################################
# Install SRAtoolkit
################################################################################################
RUN cd /opt && \
  wget http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz && \
  tar -xvf sratoolkit.current-ubuntu64.tar.gz && rm sratoolkit.current-ubuntu64.tar.gz && \
  ln -s /opt/sratoolkit.*/bin/* /usr/local/bin/


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
  --force-yes && \
  apt-get autoclean && \
  apt-get autoremove -y


################################################################################################
# Clone the github repo, add any python/shell scripts, create bash profile, clean cache and expose port
################################################################################################
RUN cd /opt && \
  git clone https://github.com/will-rowe/LIFE708.git && \
  mkdir /opt/scripts && \
  find /opt/LIFE708/scripts/ -type f -name '*.py' -exec cp {} /opt/scripts/ \; && \
  find /opt/LIFE708/scripts/ -type f -name '*.sh' -exec cp {} /opt/scripts/ \; && \
  ln -s /opt/scripts/* /usr/local/bin/ && \
  cp /opt/LIFE708/bashrc ~/.bashrc && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  apt-get autoclean && \
  apt-get autoremove -y && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/

#open ports private only
EXPOSE 8080

################################################################################################
# Define working directory and define default command for container launch
################################################################################################
RUN mkdir /MOUNTED-VOLUME-LIFE708 && \
  chmod a+rwx /MOUNTED-VOLUME-LIFE708
WORKDIR /MOUNTED-VOLUME-LIFE708
CMD ["bash"]
