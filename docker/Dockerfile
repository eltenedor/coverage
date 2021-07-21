FROM perl:latest
RUN cpanm --notest Module::Build Devel::Cover
RUN cpanm --notest Devel::Cover::Report::Codecov
WORKDIR /usr/src/app
CMD ["/bin/bash"]
