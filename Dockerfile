FROM ubuntu:16.04

ARG password
ARG user

# Make sure the package repository is up to date.
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y git

# Install SSH server
RUN apt-get install -y openssh-server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

# Install JDK 8
RUN apt-get install -y openjdk-8-jdk

# Add user to the image
RUN adduser --quiet $user
# Set password for user
RUN echo "$user:$password" | chpasswd

RUN mkdir /home/$user/.m2

RUN chown -R $user:$user /home/$user/.m2/ 

RUN apt-get install -y maven
# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
