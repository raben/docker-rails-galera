FROM centos:7
MAINTAINER rabe_ame rabe.ame@gmail.com

# 必要なパッケージをインストール
RUN yum update -y
RUN yum install -y tar wget sudo vim-enhanced git gcc make zlib-devel openssl-devel curl gcc-c++ readline-devel ruby-devel libxml2 libxml2-devel libxslt libxslt-devel mariadb-client mariadb-devel patch

# 開発用ユーザーを作成
RUN useradd -m -s /bin/bash docker
RUN echo 'docker:password' | chpasswd
RUN echo 'docker ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/docker

# 開発用ユーザーに切り替え
USER docker
ENV HOME /home/docker

# ruby インストール
RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN ~/.rbenv/bin/rbenv install 2.2.2
RUN echo 'eval "$(~/.rbenv/bin/rbenv init -)"' >> ~/.bashrc
RUN bash -l -c "source ~/.bashrc"
RUN ~/.rbenv/bin/rbenv global 2.2.2

# .gemrcを作成
RUN echo 'gem: --no-ri --no-rdoc' > ~/.gemrc

# rails インストール
# nokogiri エラー出る為別途オプションつけてインストール
RUN bash -l -c 'gem install nokogiri -- --use-system-libraries'
RUN bash -l -c 'gem install rails -v 4.2.1'

# clean up
RUN yum clean all

ADD ./scripts/run.sh /run.sh
ADD ./scripts/init.sh /init.sh
ADD ./configs/unicorn.rake /tmp/
ADD ./configs/unicorn.rb /tmp/

USER root
RUN chmod 0755 /run.sh
RUN chmod 0755 /init.sh
RUN chown docker.docker /tmp/unicorn.rake
RUN chown docker.docker /tmp/unicorn.rb

USER docker
WORKDIR $HOME
CMD ["/run.sh"]
