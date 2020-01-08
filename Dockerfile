# put the maya tarball on the same directory (Autodesk_Maya_..._Linux_64bit.tgz)
# put your license key instead of the XXXXX
# change ricou and its id, home dir... to yours

FROM centos:centos7

MAINTAINER marcus@abstractfactory.io

RUN yum update -y && yum install -y epel-release && \
    yum install -y \
        vim \
        bash \
        libXp \
        libXmu \
        libXpm \
        libXi \
        libtiff \
        compat-libtiff3 \
        libpng12 \
        libXinerama \
        elfutils \
        gcc \
        gstreamer-plugins-base.x86_64 \
        gamin \
        glxgears \
        less \
        mesa-utils \
        mesa-libGLU \
        mesa-libGL-devel \
        tigervnc-server \
        xorg-x11-apps \
        xorg-x11-server-Xorg \
        xorg-x11-fonts-ISO8859-1-100dpi \
        xorg-x11-fonts-ISO8859-1-75dpi \
        xorg-x11-fonts-75dpi \
        xorg-x11-fonts-100dpi \
        xterm \
        x11vnc \
        wget \
    && \
    yum groupinstall -y X11 && \
    yum groups install -y "Xfce" && \
    yum clean all

RUN echo "exec /usr/bin/xfce4-session" >> /etc/X11/xinit/xinitrc

# Maya installation
#ADD Autodesk_Maya_2019_Linux_64bit.tgz /maya
ADD Autodesk_Maya_2019_2_Update_Linux_64bit.tgz /maya
RUN cd /maya && \
    echo "MAYA_LICENSE=657K1" > License.env && \
    echo "MAYA_LICENSE_METHOD=standalone" >> License.env && \
    rpm -ivh Maya*.rpm bifrost.rpm adlmapps*.rpm adlmflexnetclient*rpm && \
    cp License.env /usr/autodesk/maya/bin/ && \
    export LD_LIBRARY_PATH=/opt/Autodesk/Adlm/R14/lib64/ && \
    /usr/autodesk/maya/bin/adlmreg -i X XXXXX XXXXX XXXX.X.X.X XXX-XXXXXXXX /var/opt/Autodesk/Adlm/Maya2019/MayaConfig.pit && \
    sh unix_installer.sh && \
    rm -r /maya && \
    ln -s /usr/lib64/libtinfo.so.5 /usr/autodesk/maya2019/lib/
# Make mayapy the default Python
# RUN echo alias hpython="\"/usr/autodesk/maya/bin/mayapy\"" >> ~/.bashrc && \
#     echo alias hpip="\"mayapy -m pip\"" >> ~/.bashrc

# Setup environment
ENV MAYA_LOCATION=/usr/autodesk/maya/
ENV PATH=$MAYA_LOCATION/bin:$PATH
ENV PYTHONPATH=/usr/local/lib/python2.7/site-packages:/opt/solidangle/mtoa/2019/scripts/:/usr/autodesk/maya/lib/python2.7/site-packages/
# Enable playblasts with Quicktime
ENV LIBQUICKTIME_PLUGIN_DIR=/usr/autodesk/maya/lib

RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    pip install --target=/usr/local/lib/python2.7/site-packages/ \
        nose \
        mock \
        unittest2 \
        numpy


RUN echo 'root:tito' | chpasswd
RUN useradd --uid 1000 ricou
#USER ricou
#WORKDIR /home/ricou
#ENV DISPLAY unix:0.0
