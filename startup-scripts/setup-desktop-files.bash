#!/bin/bash -l
set -euo pipefail
# This script is run on container startup, as a non-root user
# It copies any .desktop files it may find in a DESKTOP_FILES_DIR to the user's
# actual desktop, allowing image authors to put easy launcher icons for the
# user. It's done at startup time because $HOME is often mounted over by a
# persistent remote filesystem, hiding whatever is in the directory.

# Set nullglob, so we don't error out if there are no Desktop files to be found
shopt -s nullglob

APPLICATIONS_DIR="${HOME}/.local/share/applications"
DESKTOP_DIR="${HOME}/Desktop"

# Create directories (non-fatal if disk is full)
mkdir -p "${APPLICATIONS_DIR}" || echo "WARNING: Failed to create ${APPLICATIONS_DIR}"
mkdir -p "${DESKTOP_DIR}" || echo "WARNING: Failed to create ${DESKTOP_DIR}"

for desktop_file_path in ${DESKTOP_FILES_DIR}/*.desktop; do
    desktop_file_name="$(basename ${desktop_file_path})"

    # Copy desktop file to applications directory (non-fatal if disk is full)
    cp "${desktop_file_path}" "${APPLICATIONS_DIR}/." || echo "WARNING: Failed to copy ${desktop_file_name} to ${APPLICATIONS_DIR}"

    # Symlink application to desktop (non-fatal if disk is full)
    ln -sf "${APPLICATIONS_DIR}/${desktop_file_name}" "${DESKTOP_DIR}/${desktop_file_name}" || echo "WARNING: Failed to create desktop symlink for ${desktop_file_name}"
done

# Update desktop database (non-fatal if it fails)
update-desktop-database "${APPLICATIONS_DIR}" || echo "WARNING: Failed to update desktop database"
