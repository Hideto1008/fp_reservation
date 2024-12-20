# フィナンシャルプランナー予約システム

このアプリは、ユーザーがフィナンシャルプランナー（FP）との相談時間を予約できるシステムです。
FPは予約枠を設定し、ユーザーはその空き枠を選択して予約を行います。

## 構成

### docs
要件定義書、実体関連図、ページ遷移図などを格納しています。

### fp_app
予約アプリの核となる部分です。

## 特徴

- **予約単位**: 1枠30分
- **予約可能時間**:
  - **平日**: 10:00 ~ 18:00
  - **土曜日**: 11:00 ~ 15:00
  - **日曜日**: 休業

- FPはログイン後、自分の予約可能時間をスケジュールに指定できます。
- ユーザーはログイン後、各FPのスケジュールを確認し、空いている時間に予約を作成できます。
- ユーザー・FPともに、マイページで予約履歴を確認できます。

## デモ動画

以下に、ユーザー側とFP側それぞれのデモ動画を示します。

---

### ユーザー側

https://github.com/user-attachments/assets/e9ba1ee9-60b7-4aa1-939d-aad9c521172f

### FP側

https://github.com/user-attachments/assets/50fb1ea2-09e0-4991-b8ef-83bf57082718

---

## セットアップ手順

以下の手順に従って、アプリケーションをセットアップしてください。

### 1. リポジトリをクローン

以下のコマンドでリポジトリをクローンします。

```bash
git clone git@github.com:Hideto1008/fp_reservation.git
```

クローン後、プロジェクトディレクトリに移動します。

```bash
cd fp_reservation
cd fp_app
```

### 2. .envファイルを作成

以下のコマンドを実行して.envファイルを作成します（.envファイルの中身は編集不要）

```bash
touch .env
```

### 3. Dockerのビルドとコンテナの起動

以下のコマンドを実行して、アプリケーションをビルド・起動します。

```bash
docker compose up --build -d
```

### 4. Docker環境でのコマンド操作

以下のコマンドを実行して、Docker環境内でコマンドを実行できるようにします。

```bash
docker exec -it fp_app /bin/bash
```

### 5. データベースの作成

以下のコマンドを実行して、データベースを作成します。

```bash
rails db:create
```

### 6. データベースのマイグレーション

以下のコマンドを実行して、データベースのマイグレーションを行います。

```bash
make
```

### 7. 非同期処理の更新

以下のコマンドを実行して、`whenever` gemを使ってのアプリ内で使用する非同期処理の設定を更新します。

```bash
bundle exec whenever --update-crontab
```

### 8. アプリケーションの起動

以下のコマンドを実行してRailsアプリを起動します。

```bash
rails s
```

ブラウザで `http://localhost:3000/` にアクセスし、以下の画面が表示されればセットアップ完了です！

<img width="742" alt="スクリーンショット 2024-12-09 9 43 10" src="https://github.com/user-attachments/assets/a10b32ff-c3ae-4b77-9d32-d2a816f8d047">


### 9. コンテナの終了

以下のコマンドを実行して、`bash` シェルを終了し、コンテナから抜けます。

```bash
exit
```

その後、以下のコマンドを実行してコンテナを停止します。

```bash
docker compose down
```

## 使用技術

- **バックエンド**: Ruby on Rails
- **フロントエンド**: HTML.slim, CSS, JavaScript
- **データベース**: MySQL
- **インフラ**: Heroku
- **環境構築**: Docker
- **コード管理**: Git
- **CI/CD**: GitHub Actions
