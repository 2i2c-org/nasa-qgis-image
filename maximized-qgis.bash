#!/bin/bash -l

function maximize_qgis_window() {
    # Obtain the current screen resolution
    screen_resolution=$(xdpyinfo | grep 'dimensions:' | awk '{print $2}')
    desired_width=$(echo $screen_resolution | cut -d'x' -f1)
    desired_height=$(echo $screen_resolution | cut -d'x' -f2)
    # Retry parameters
    max_retries=20
    count=0
    while true; do
        window_id=$(wmctrl -l | grep 'QGIS' | awk '{print $1}')
        if [ -n "$window_id" ]; then
            window_info=$(wmctrl -lG | grep "$window_id")
            width=$(echo "$window_info" | awk '{print $5}')
            height=$(echo "$window_info" | awk '{print $6}')
            # Maximize the QGIS window in case it does not have maximum width and height
            if [ "$width" -lt "$desired_width" ] || [ "$height" -lt "$desired_height" ]; then
                echo "Maximizing QGIS window..."
                wmctrl -i -r "$window_id" -b add,maximized_vert,maximized_horz
            else
                echo "QGIS window is at least $desired_width x $desired_height"
            fi
        else
            echo "QGIS window not found, retrying..."
        fi
        sleep 2
        ((count++))
        if [ "$count" -ge "$max_retries" ]; then
            echo "Max retries reached. Stopping the attempt to maximize QGIS window."
            break
        fi
    done
}

# Start QGIS
qgis & maximize_qgis_window
