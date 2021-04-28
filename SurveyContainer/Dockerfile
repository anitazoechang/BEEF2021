FROM gcr.io/dmautoscripts/github.com/precisionlivestockmanagement/dmbaser:a8e27e7216f723c43da5cf3c1b3bfbd33fd96896

RUN R -e "install.packages(c('knitr', 'ggplot2','grid','gridExtra', 'RSQLite','DBI','mongolite','scales','png','jpeg','kableExtra','blastula'), repos='https://cloud.r-project.org/',Ncpus=4)"

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
