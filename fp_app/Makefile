# デフォルトのターゲット
.PHONY: all
all: apply_dev apply_test

# 開発環境にスキーマを適用するターゲット
.PHONY: apply_dev
apply_dev:
	bundle exec ridgepole -c config/database.yml -E development --apply -f db/schemas/Schemafile

# テスト環境にスキーマを適用するターゲット
.PHONY: apply_test
apply_test:
	bundle exec ridgepole -c config/database.yml -E test --apply -f db/schemas/Schemafile
