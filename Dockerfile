FROM asia.gcr.io/tcservices/tcbase-r:v2.0.0

MAINTAINER Dave Swain Stuart Charters "info@datamuster.net.au"

RUN apt-get update
RUN apt-get install -y apt-utils \
    libssl-dev \
    libjq-dev \
    libprotobuf-dev \
    protobuf-compiler \
    #libcurl4-openssl-dev \
    libxt-dev \
    libssh2-1-dev \
    openjdk-11-jdk \
    liblzma-dev \
    liblapack-dev \
    libmpfr-dev \
    libgdal-dev \ 
    libgeos++-dev \
    libproj-dev \
    libudunits2-dev\ 
    libv8-dev \
    libsasl2-dev \
    libxml2-dev \
    libcurl4-gnutls-dev \
    git \
    libsodium-dev \
    libsecret-1-dev \
    libcairo2-dev

#install the DMMongoDB package
RUN R -e 'install.packages(c("feather", "leaflet.extras", "shinyWidgets", "shinydashboard", dependencies = TRUE), repos="https://cloud.r-project.org/",Ncpus=4)'
RUN R -e "remotes::install_github('rstudio/DT')"
RUN R -e 'install.packages(c("spdplyr", dependencies = TRUE), repos="https://cloud.r-project.org/",Ncpus=4)'
RUN R -e "remotes::install_github('PrecisionLivestockManagement/DMApp')"
RUN R -e "remotes::install_github('anitazoechang/BEEF2021functions@main')"

# copy the app to the image
RUN mkdir /root/WOWweight
COPY WOWweight /root/WOWweight

 

COPY Rprofile.site /usr/lib/R/etc/

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/root/WOWweight')"]
