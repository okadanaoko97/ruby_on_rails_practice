FROM ruby:3.0.2

# Node.jsのインストールに必要なパッケージを追加
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean

# nvmのインストール
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
    && export NVM_DIR="$HOME/.nvm" \
    && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
    && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" \
    && nvm install 14

# yarnパッケージ管理ツールをインストール
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y yarn

# その他の必要なパッケージのインストール
RUN apt-get update -qq && \
    apt-get install -y nodejs postgresql-client

# ワーキングディレクトリの設定とファイルのコピー
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp

# コンテナ起動時に実行されるスクリプトの追加
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# メインプロセスの開始
CMD ["rails", "server", "-b", "0.0.0.0"]
