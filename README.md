# Slack Time Reporter

主な機能は2つ

* 勉強会の開催日が近くなったときに、お題を書くようSlack に通知を流します
* 勉強会の終了時刻になったとき、Slack に通知を流します

## 前提

### 勉強会

* 定期的に勉強会を開催する(eg. 偶数週土曜日)
* 開始時間、とくに終了時間が決まっている(eg. 13:00 ~ 15:30)
* [esa](https://esa.io) にその日のまとめや勉強会で使用するお題を毎回書く(テンプレートの使用)

### Heroku

* [Heroku Scheduler](https://devcenter.heroku.com/articles/scheduler) を利用する
* 10分間隔程度に設定する

## 設定

動作に必要な環境変数:

| 変数名 | 説明|
|---|---|
| WEBHOOK_URL | Slack の [Incoming WebHooks](https://slack.com/apps/A0F7XDUAZ-incoming-webhooks) |
| BOT_ICON_URL | Slack に通知されたときに表示されるアイコンのURL |
| ESA_TEAM_NAME | esa.io のチーム名 |
| ESA_CLASS_TEMPLATE_ID | esa.io に保存されている「お題」テンプレートID |
| ESA_KWL_TEMPLATE_ID |  esa.io に保存されている「振り返り」テンプレートID |
