FROM node:latest

ENV CC clang
ENV CXX clang++

# Install clang
RUN apt-get update
RUN apt-get install -y clang

# Install cmake
RUN curl -sSL https://cmake.org/files/v3.5/cmake-3.5.2-Linux-x86_64.tar.gz | tar -xzC /opt
ENV PATH /opt/cmake-3.5.2-Linux-x86_64/bin/:$PATH

ADD Ostrich-Node Ostrich-Node
ADD server server

# Install Kyoto Cabinet
ADD install-kc.sh install-kc.sh
RUN ./install-kc.sh

ADD Ostrich-Node Ostrich-Node
ADD server server

# Install Ostrich-Node
RUN cd Ostrich-Node && npm install --unsafe-perm
RUN cd Ostrich-Node && npm run test
RUN cd Ostrich-Node && npm link

# Install LDF server
RUN cd server && npm link ostrich && npm install

# Running
WORKDIR server
ENTRYPOINT ["node", "bin/ldf-server"]
CMD ["--help"]
