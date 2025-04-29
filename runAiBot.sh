# Build the image
docker build -t job-applier-bot .

# Allow X11 access (run once per session)
xhost +local:root

# Run the container
docker run -it --rm \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v ~/.Xauthority:/root/.Xauthority \  # For X11 auth
  job-applier-bot