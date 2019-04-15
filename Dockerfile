FROM yihui8776/myjupyter:v1.0
MAINTAINER Wangyaohui <wangyaohui8776@sina.com>

#安装依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
        rsync \
        software-properties-common \
        unzip \
        golang \
        git \
        libjpeg-turbo8-dev \
        && \
        apt-get clean \
        && \
       rm -rf /var/lib/apt/lists/*
RUN rm -rf /usr/bin/lsb_release

# 重新notebook配置
COPY jupyter_notebook_config.py /root/.jupyter/

# 拷贝 sample notebooks.
COPY notebooks /notebooks

# Jupyter运行脚本
COPY run_jupyter.sh /
RUN chmod +x  /run_jupyter.sh
RUN chmod +x /notebooks

# 根据需要增加Python库
COPY requirements.txt /requirements.txt

RUN pip3 install --upgrade pip && \
    pip3 install --no-cache-dir -r /requirements.txt

#tensoflow
RUN pip3 install tensorflow --ignore-installed numpy

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888
# SSH
EXPOSE 22

WORKDIR "/notebooks"

CMD ["/run_jupyter.sh", "--allow-root"]

