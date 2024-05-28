FROM quay.io/jupyter/minimal-notebook:2024-03-14

USER root

COPY setup-scripts /opt/setup-scripts/

# Set DISPLAY env variable, so processes know where to open GUI windows.
# Allows python processes running in notebooks to open windows in the GUI.
ENV DISPLAY=":1.0"

# Setup Linux Desktop
RUN /opt/setup-scripts/setup-linux-desktop.bash

COPY startup-scripts /usr/local/bin/start-notebook.d/

# env variables used by downstream images for setting up desktop files or
# mime associations. Consumed by the startup-scripts in startup-scripts/
ENV DESKTOP_FILES_DIR /opt/desktop-files
ENV MIME_FILES_DIR /opt/mime-files
RUN mkdir -p ${DESKTOP_FILES_DIR} ${MIME_FILES_DIR}

# Enable the following line to allow the jovyan user to run sudo commands without a password
# RUN echo "jovyan ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN apt-get update && apt-get -y install wmctrl

USER ${NB_UID}

# Setup qgis

RUN mamba install -c conda-forge --yes \
    qgis \
    qgis-plugin-manager

COPY --chown=1000:1000 setup-qgis-plugins.bash /tmp/setup-qgis-plugins.bash
RUN /tmp/setup-qgis-plugins.bash && rm /tmp/setup-qgis-plugins.bash

COPY qgis.desktop ${DESKTOP_FILES_DIR}/qgis.desktop

# Copy files to autostart folder, so that QGIS auto-starts when opening the Desktop
# See: https://manpages.ubuntu.com/manpages/focal/en/man1/xdg-autostart.1.html
COPY qgis.desktop /etc/xdg/autostart/qgis.desktop

COPY maximized-qgis.bash /usr/local/bin

COPY qgis.xml ${MIME_FILES_DIR}/qgis.xml
