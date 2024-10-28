# Use a base image with a compiler, like gcc
FROM gcc:latest

# Set working directory
WORKDIR /app

# Copy the source code and Makefile into the container
COPY . /app

# Build the firmware
RUN make

# Run the firmware and keep the container running
CMD ["sh", "-c", "./firmware && tail -f /dev/null"]
