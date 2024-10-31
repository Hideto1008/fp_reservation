# デフォルトのターゲット
.PHONY: all
all: apply_dev apply_test migrate_test

# 開発環境にスキーマを適用するターゲット
.PHONY: apply_dev
apply_dev:
	bundle exec ridgepole -c config/database.yml -E development --apply -f db/schemas/Schemafile

# テスト環境にスキーマを適用するターゲット
.PHONY: apply_test
apply_test:
	bundle exec ridgepole -c config/database.yml -E test --apply -f db/schemas/Schemafile

.PHONY: apply_github
apply_github:
	bundle exec ridgepole -c config/database.yml -E github --apply -f db/schemas/Schemafile

# GitHub環境のデータベースをマイグレート
.PHONY: migrate_github
migrate_github:
	bundle exec rails db:migrate RAILS_ENV=github

# テスト環境のデータベースをマイグレート
.PHONY: migrate_test
migrate_test:
	bundle exec rails db:migrate RAILS_ENV=test
