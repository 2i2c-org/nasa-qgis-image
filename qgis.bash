#!/bin/bash -l

function maximize_qgis_window() {
    # Set the desired size
    desired_width=1680
    desired_height=999 # or 1050
    while true; do
        window_id=$(wmctrl -l | grep 'QGIS' | awk '{print $1}')
        if [ -n "$window_id" ]; then
            window_info=$(wmctrl -lG | grep "$window_id")
            width=$(echo "$window_info" | awk '{print $5}')
            height=$(echo "$window_info" | awk '{print $6}')
            if [ "$width" -lt "$desired_width" ] || [ "$height" -lt "$desired_height" ]; then
                echo "QGIS window is smaller than $desired_width x $desired_height. Maximizing..."
                wmctrl -i -r "$window_id" -b add,maximized_vert,maximized_horz
            else
                echo "QGIS window is at least $desired_width x $desired_height"
            fi
        else
            echo "QGIS window not found"
        fi
        sleep 2
    done
}

# Start QGIS
qgis & maximize_qgis_window
