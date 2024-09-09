# fp_reservation
## フィナンシャルプランナーとの相談時間を予約するアプリの実行手順

1. **Dockerのビルドとコンテナの起動**  
   以下のコマンドを実行して、アプリケーションをビルド・起動してください。

   ```bash
   docker compose build
   docker compose up -d
   ```

2. **データベースの作成**  
   データベースを作成するために、以下のコマンドを実行します。

   ```bash
   docker-compose exec web rails db:create
   ```

3. **データベースのマイグレーション**  
   データベースのマイグレーションを行います。

   ```bash
   docker-compose exec web rails db:migrate
   ```

4. **コンテナ内で `bash` を実行**  
   コンテナ内で `bash` シェルに入ります。

   ```bash
   docker-compose run web bash
   ```

   - 警告メッセージが表示された場合、`--remove-orphans` フラグを使用して孤立したコンテナを削除できます。
   
5. **`make all` コマンドの実行**  
   コンテナ内で、以下のコマンドを実行してRidgepoleによるスキーマの適用を行います。

   ```bash
   make all
   ```

   これにより、データベースにスキーマが適用されます。

6. **コンテナを終了**  
   `bash` シェルを終了して、コンテナから抜けます。

   ```bash
   exit
   ```

---

この手順に従って、フィナンシャルプランナー予約アプリの環境をセットアップしてください。