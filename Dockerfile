FROM opensuse/leap:15.0

EXPOSE 80 443 2222 24
COPY baseline /baseline
RUN /baseline/repository.sh
RUN /baseline/setup.sh
COPY preflight /preflight
RUN /preflight/setup.sh
CMD ["/bin/bash", "/app/init.sh"]
#CMD ["/bin/bash"]
