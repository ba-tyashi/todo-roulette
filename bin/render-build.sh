#!/usr/bin/env bash
# エラーが発生したらスクリプトを終了させる
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate

# コメントアウトを外して、カテゴリとキャラのデータを最新にする
bundle exec rails db:seed

# 本番環境の全キャラクターの必要経験値を 5 に強制上書きする
bundle exec rails runner "Character.update_all(required_exp: 5)"
