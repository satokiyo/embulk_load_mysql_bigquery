# Embulk で MySQL から BigQuery にデータ転送

ローカル環境に Embulk コンテナと MySQL コンテナを建てる。
MySQL のデータを Embulk を使って、リモート環境の BigQuery に転送する。

## BigQuery

テーブルはあえて用意しないで、プロジェクトとデータセットだけ作成しておきます。

※転送先にテーブルが無い場合、embulk が自動でテーブル作成&データ投入してくれる。

- Embulk から BigQuery に転送するための権限を持ったサービスアカウントを作成する。

- 作成したサービスアカウントの秘密鍵を作成ダウンロードする。

- この秘密鍵の入った Json ファイルを Embulk 転送時に使うので、わかるところに保存しておいてください。

## ローカル環境

docker-compose を使って Embulk と MySQL のコンテナ環境を作成する。

以下、ローカル環境全体のディレクトリ構成です。

```
$ tree
.
├── docker-compose.yml
├── embulk
│   ├── Dockerfile
│   └── service_account_iam_key.json
└── mysql
    ├── Dockerfile
    ├── ddl
    │   ├── init.sql
    │   ├── insert_departments.sql
    │   └── insert_employee.sql
    └── my.cnf
```

- 公開鍵の配置
  BigQuery にアクセスするための service_account の秘密鍵を、Dockerfile と同じ階層に配置する。
  名前は「service_account_iam_key.json」としました。

```
├── embulk
│   ├── Dockerfile
│   └── service_account_iam_key.json
```

### 以下の手順で起動

```bash
$ docker-compose build --no-cache

$ docker-compose up -d

$ docker exec -it embulk_etl /bin/bash
```

ネットワーク接続チェック Embulk コンテナ →MySQL コンテナ
以下のように接続確認します。

```bash

mysql -h mysql_etl -u fuka_user training -p
Enter password:

MySQL [training]>
```

### bq インストール

（参考：https://cloud.google.com/sdk/docs/install#deb）

```bash
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

apt-get update && apt-get install google-cloud-sdk

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-sdk -y

# 以下のように接続確認します。
gcloud init --console-only

gcloud auth login
# Go to the following link in your browser:

#    https://accounts.google.com/o/oauth2/auth?response_type=省略~

# Enter verification code:

bq ls
# 表示されれば接続確認ok

```

### embulk 実行

departments テーブルの転送

```bash
embulk guess conf/embulk_guess_departments.yml -o conf/embulk_load_departments.yml

embulk preview -G conf/embulk_load_departments.yml

embulk run conf/embulk_load_departments.yml
```

employees テーブルの転送

```bash
embulk guess conf/embulk_guess_employees.yml -o conf/embulk_load_employees.yml

embulk preview -G conf/embulk_load_employees.yml

embulk run conf/embulk_load_employees.yml
```
