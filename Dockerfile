FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive
ENV USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends ubuntu-desktop && \
    apt-get install -y gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal && \
    apt-get install -y tightvncserver && \
	apt-get install -y wget && \
	apt-get install -y tar && \
    mkdir /root/.vnc
	
# Install Choregraphe Suite 2.5.10
RUN wget -P /root/ https://community-static.aldebaran.com/resources/2.5.10/Choregraphe/choregraphe-suite-2.5.10.7-linux64-setup.run
RUN chmod +x /root/choregraphe-suite-2.5.10.7-linux64-setup.run
RUN /root/choregraphe-suite-2.5.10.7-linux64-setup.run --mode unattended --installdir /opt/Aldebaran --licenseKeyMode licenseKey --licenseKey 654e-4564-153c-6518-2f44-7562-206e-4c60-5f47-5f45 
RUN rm /root/choregraphe-suite-2.5.10.7-linux64-setup.run

# Install pynaoqi 2.5.10 library
RUN wget -P /root/ https://community-static.aldebaran.com/resources/2.5.10/Python%20SDK/pynaoqi-python2.7-2.5.7.1-linux64.tar.gz
RUN tar -xvzf /root/pynaoqi-python2.7-2.5.7.1-linux64.tar.gz -C /root/
RUN rm /root/pynaoqi-python2.7-2.5.7.1-linux64.tar.gz
ENV PYTHONPATH /root/pynaoqi-python2.7-2.5.7.1-linux64/lib/python2.7/site-packages
ENV LD_LIBRARY_PATH /opt/Aldebaran/lib/

# Setup VNC
ADD xstartup /root/.vnc/xstartup
ADD passwd /root/.vnc/passwd

RUN chmod 600 /root/.vnc/passwd
RUN chmod 755 /root/.vnc/xstartup

CMD /usr/bin/vncserver :1 -geometry 1600x900 -depth 24 && tail -f /root/.vnc/*:1.log

EXPOSE 5901
