FROM openjdk:8

# パッケージ管理システムのアップデート
RUN apt-get -y update && apt-get -y upgrade

# localeの設定
RUN apt-get -y install locales && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

# timezone (Asia/Tokyo)の設定
ENV TZ JST-9

# vim以外にも使いそうなもの一応インストール
RUN apt-get install -y vim git zip unzip less wget

# MySQLコンテナ接続確認するときのためにMySQL-clientをインストール
RUN apt-get install -y default-mysql-client

# embulkをインストール(https://www.embulk.org/)
RUN curl --create-dirs -o ~/.embulk/bin/embulk -L "https://dl.embulk.org/embulk-latest.jar"
RUN chmod +x ~/.embulk/bin/embulk
RUN echo 'export PATH="$HOME/.embulk/bin:$PATH"' >> ~/.bashrc
RUN . ~/.bashrc

# MySQL取得とBigQuery投入用のプラグインを入れておく
RUN ~/.embulk/bin/embulk gem install embulk-input-mysql \
&& ~/.embulk/bin/embulk gem install embulk-output-bigquery

WORKDIR /root