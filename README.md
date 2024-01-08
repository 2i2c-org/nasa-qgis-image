# NASA QGIS image with Linux Desktop

An image for running QGIS in a Linux Desktop in the cloud,
with special focus on using various NASA related datasets.

# Test Locally

To build, run and test the image locally:

Checkout this repository, and in the code folder:

    docker build -t qgis .
    docker run -it -p 8888:8888 --security-opt seccomp=unconfined qgis

This should start the docker container and emit logs which give you a URL you can open in your browser, that looks something like:

    http://127.0.0.1:8888/lab?token=<token>

Paste this into your browser. You should see a Jupyter Lab interface. Click on the Desktop button to open the desktop with QGIS installed.
