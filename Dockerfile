FROM archlinuxjp/archlinux-test:latest

ENV AUR_PACKAGE zsh

RUN pacman --noconfirm -Syyu && \
    pacman --noconfirm -S base-devel yajl sudo rsync gzip tar

RUN groupadd -r yaourt && \
    useradd -r -g yaourt yaourt
RUN mkdir -p /tmp/yaourt && mkdir -p /home/yaourt/bin && \
    chown -R yaourt:yaourt /tmp/yaourt && \
    chown -R yaourt:yaourt /home/yaourt

ADD etc/sudoers /etc/sudoers.d/yaourt
RUN echo -e '[archlinuxfr]\nSigLevel = Never\nServer = http://repo.archlinux.fr/$arch' >> /etc/pacman.conf
RUN pacman -Sy yaourt --noconfirm

#ENV PASS root
#RUN echo yaourt:$PASS | chpasswd

# add : user script
ADD bin/test.sh /home/yaourt/bin
USER root
RUN chmod a+wrx /home/yaourt/bin

USER yaourt
env PATH $PATH:/home/yaourt/bin
RUN yaourt --noconfirm -Sa $AUR_PACKAGE
RUN which test.sh 
RUN which zsh
CMD /bin/bash
