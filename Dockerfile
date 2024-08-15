FROM quay.io/jupyter/minimal-notebook:2024-06-24

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

USER ${NB_UID}

COPY --chown=1000:1000 setup-qgis-plugins.bash /tmp/setup-qgis-plugins.bash
RUN /tmp/setup-qgis-plugins.bash && rm /tmp/setup-qgis-plugins.bash

COPY qgis.desktop ${DESKTOP_FILES_DIR}/qgis.desktop

COPY qgis.xml ${MIME_FILES_DIR}/qgis.xml

COPY environment.yml /tmp/environment.yml
RUN mamba env update --prefix /opt/conda/envs/notebook --file /tmp/environment.yml && \
    mamba clean -a