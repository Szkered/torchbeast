FROM nvidia/cuda:11.2.2-cudnn8-devel-ubuntu20.04
ARG DEBIAN_FRONTEND=noninteractive
RUN ln -sf /user/local/cuda-11.2 /usr/local/cuda

RUN sed -i "s/archive.ubuntu.com/mirror.0x.sg/g" /etc/apt/sources.list

# Install dependencies
COPY apt_install.txt .
RUN apt-get update && apt-get install -y `cat apt_install.txt`

RUN ln -s /usr/bin/python3 /usr/bin/python

# Config pip
RUN python3 -m pip config set global.index-url http://pypi.ai.seacloud.garenanow.com/root/dev
RUN python3 -m pip config set global.trusted-host pypi.ai.seacloud.garenanow.com

RUN pip install --upgrade cmake

RUN pip install gym[accept-rom-license] torch==1.7.1+cu110 torchvision==0.8.2+cu110 torchaudio===0.7.2 -f https://download.pytorch.org/whl/torch_stable.html

# install TorchBeast.
WORKDIR /src/torchbeast
COPY .git /src/torchbeast/.git
RUN git reset --hard
RUN git submodule update --init --recursive
RUN pip install nest/
RUN pip install -r requirements.txt
RUN python setup.py install

CMD ["/bin/bash"]
