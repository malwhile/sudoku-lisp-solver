FROM ubuntu:latest

# Install SBCL (Steel Bank Common Lisp)
RUN apt-get update && apt-get install -y \
    sbcl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy the lisp files
COPY *.lisp /app/

# Set the entry point to sbcl
ENTRYPOINT ["sbcl"]
CMD ["--version"]
