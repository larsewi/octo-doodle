FROM ubuntu:latest as base

################################################################################
# Create a stage for building/compiling the application.
#
# The following commands will leverage the "base" stage above to generate
# a "hello world" script and make it executable, but for a real application, you
# would issue a RUN command for your application's build process to generate the
# executable. For language-specific examples, take a look at the Dockerfiles in
# the Awesome Compose repository: https://github.com/docker/awesome-compose
FROM base as build
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install --yes git
RUN apt install --yes gcc
RUN apt install --yes make
RUN apt install --yes libc-dev
RUN apt install --yes build-essential
RUN apt install --yes bison
RUN apt install --yes flex
RUN apt install --yes ntp
RUN apt install --yes pkg-config
RUN apt install --yes libpam0g-dev
RUN apt install --yes dpkg-dev
RUN apt install --yes debhelper
RUN apt install --yes fakeroot
RUN apt install --yes libexpat1-dev
RUN apt install --yes openssh-server

RUN dpkg --add-architecture i386
RUN apt update
RUN apt install --yes wine-development:i386
RUN apt install --yes mingw-w64
RUN apt install --yes bison
RUN apt install --yes flex
RUN apt install --yes ntp
RUN apt install --yes dpkg-dev
RUN apt install --yes python3
RUN apt install --yes debhelper
RUN apt install --yes pkg-config
RUN apt install --yes default-jre-headless
RUN apt install --yes psmisc
RUN apt install --yes zip
RUN apt install --yes libmodule-load-conditional-perl
RUN apt install --yes python3-pip

RUN apt remove --yes libltdl7
RUN apt remove --yes libltdl7:i386
RUN apt autoremove --yes
RUN apt clean


RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# COPY <<EOF /bin/hello.sh
# #!/bin/sh
# echo Hello world from $(whoami)! In order to get your application running in a container, take a look at the comments in the Dockerfile to get started.
# EOF
# RUN chmod +x /bin/hello.sh

################################################################################
# Create a final stage for running your application.
#
# The following commands copy the output from the "build" stage above and tell
# the container runtime to execute it when the image is run. Ideally this stage
# contains the minimal runtime dependencies for the application as to produce
# the smallest image possible. This often means using a different and smaller
# image than the one used for building the application, but for illustrative
# purposes the "base" image is used here.
FROM base AS final

# Create a non-privileged user that the app will run under.
# See https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
# ARG UID=10001
# RUN adduser \
#     --disabled-password \
#     --gecos "" \
#     --home "/nonexistent" \
#     --shell "/sbin/nologin" \
#     --no-create-home \
#     --uid "${UID}" \
#     appuser
# USER appuser

# Copy the executable from the "build" stage.
# COPY --from=build /bin/hello.sh /bin/

# What the container should run when it is started.
# ENTRYPOINT [ "/bin/hello.sh" ]
ENTRYPOINT service ssh start && bash
