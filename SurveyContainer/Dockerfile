FROM gcr.io/dmautoscripts/github.com/precisionlivestockmanagement/dmbaser:a8e27e7216f723c43da5cf3c1b3bfbd33fd96896


RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install pandoc -y
RUN apt-get install gnupg -y
RUN apt-get install gnupg1 -y
RUN apt-get install gnupg2 -y
RUN apt-get install software-properties-common -y
RUN gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv 9BDB3D89CE49EC21
RUN gpg --export --armor 9BDB3D89CE49EC21 | apt-key add -
#RUN add-apt-repository "deb http://archive.ubuntu.com/ubuntu/ hirsute main universe"
#RUN add-apt-repository "deb http://archive.ubuntu.com/ubuntu/ hirsute-backports main restricted universe"
#RUN add-apt-repository "deb http://archive.ubuntu.com/ubuntu/ hirsute-security main restricted universe"
RUN apt-get update
RUN apt-get install texlive-xetex -y
#RUN apt-get install texlive-fonts-recommended -y
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
RUN tar -xvf install-tl-unx.tar.gz
#RUN apt-get install ttf-mscorefonts-installer -y
#RUN apt-get install msttcorefonts -y
RUN apt-get install xzdec -y
RUN wget https://www.tug.org/fonts/getnonfreefonts/install-getnonfreefonts
RUN texlua install-getnonfreefonts
RUN getnonfreefonts --sys arial-urw
RUN mktexlsr
RUN tlmgr init-usertree
#RUN tlmgr update --self
#RUN tlmgr update --all
#ENV PATH="/usr/local/texlive/2018/bin/x86_64-linux:${PATH}"
RUN fc-cache -f -v

RUN R -e "devtools::install_github('yihui/tinytex')"

RUN R -e "install.packages(c('knitr', 'ggplot2','grid','gridExtra', 'RSQLite','DBI','mongolite','scales','png','jpeg','kableExtra','blastula'), repos='https://cloud.r-project.org/',Ncpus=4)"

RUN R -e "install.packages(c('qualtRics'), repos='https://cloud.r-project.org/',Ncpus=4)"

RUN R -e "install.packages(c('pander'), repos='https://cloud.r-project.org/',Ncpus=4)"


RUN apt-get update
RUN apt-get install -y apt-utils \
    r-cran-rmarkdown \
    r-cran-magick
    #libghc-pandoc-dev

RUN mkdir /root/app
COPY app /root/app

RUN mkdir /root/supp
COPY supp /root/supp

EXPOSE 87

ENTRYPOINT ["Rscript", "/root/app/main.R"]
