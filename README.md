
# 概要

15分のハードニングイベントを作ってみた

# 起動

```bash
# やられサーバーの起動
curl -OL https://raw.githubusercontent.com/ayato-shitomi/ayato-hardening-for-cloud/refs/heads/main/init.sh && chmod +x ./init.sh && ./init.sh

# スコアボードの起動
python3 ./white-team/score.py

# スコアBOTの起動
python3 ./red-team/check.py
# 攻撃BOTの起動
python3 ./red-team/main.py
```

# テクニック

## 堅牢MAX

```bash
for i in {1..11}; do userdel -r user$i; done
userdel dev
echo "root:toor" | chpasswd
systemctl stop ftpd.service
sudo rm -rf /var/www/html/README.md
# yourname = request.args.get('name') or ""
```

# シナリオ

## ベーススコア

1分毎にサーバーにチェックが入り以下の項目がすべてクリアであればポイントが10ポイント加算される

- 80番ポートにてWEBサーバーが稼働している

## アディショナルスコア

攻撃を防ぐごとに以下のポイントが加算される

|時間|イベント|ポイント|
|:--|:--|:--|
|0min|スタート||
|10min|ユーザーへのブルートフォース|+50<br>+50|
|20min|vsftpdへの攻撃|+50<br>+100|
|25min|クレデンシャル情報の流出|+50<br>+100|
|30min|WEBアプリへの攻撃|+100<br>+100|
|40min|終了||

# レッドチームメモ

## ユーザーへのブルートフォース

デフォルトのユーザーへの攻撃を行う

- root: root
- user1: user1
- user6: user6
- user11: pass

侵入された場合

- `sg`ユーザーが作成される
- WEBサーバーが停止する

## vsftpdの脆弱性を利用した攻撃

vsftpdの脆弱性を利用した攻撃を行う

- RCEにより侵入される

侵入された場合

- `useradd test`により`test`ユーザーが作られる

## クレデンシャル情報の流出

WEBサーバーよりクレデンシャル情報が流出する

- `:8080/README.md`にリクエストが来る
- クレデンシャル情報が流出する

侵入された場合

- ホームページが改竄される

## WEBアプリへの攻撃

SSTIでWEBアプリへの攻撃を行う

- WEBサーバーに攻撃が来る
- サーバーが停止する

1回目のリクエスト

```
/app?name={{request.application.__globals__.__builtins__.__import__("os").popen("whoami").read()}}
```

```
/app?name={{request.application.__globals__.__builtins__.__import__("os").popen("sudo systemctl stop http-flask.service").read()}}
```


