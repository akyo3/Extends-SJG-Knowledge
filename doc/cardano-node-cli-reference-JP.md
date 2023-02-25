本記事は [Cardano Node CLI Reference](https://github.com/input-output-hk/cardano-node/blob/master/doc/reference/cardano-node-cli-reference.md) を[AKYO-POOL](https://akyo.org/)の[Akyo](https://github.com/akyo3)が日本語翻訳したものです。

---
# Cardano Node CLI リファレンス

コマンドラインインターフェース（CLI）は、鍵の生成、トランザクションの構築、証明書の作成、その他の重要なタスクを実行するためのツール群を提供します。 サブコマンドの階層構造で構成され、各階層にはコマンドの構文とオプションに関する独自の文書が組み込まれています。

このセクションでは、中核となる `cardano-cli` コマンドとそれに関連するサブコマンドのリファレンスを提供します。


**cardano-cli -h** : `cardano-cli`の使い方。

**cardano-cli** : `cardano-cli`のコマンド一式は以下の通りです。
* `address`: 支払いアドレスコマンド
* `stake-address`: ステークアドレスコマンド
* `transaction`: トランザクションコマンド
* `node`: ノード操作コマンド
* `stake-pool`: ステークプールコマンド
* `query`: ノードクエリーコマンド。 このグループのコマンドは、CARDANO_NODE_SOCKET_PATH環境変数から取得したUnixドメインソケットを持つローカルノードに問合せを行います。
* `genesis`: ジェネシスブロックコマンド
* `text-view`: トランザクションやアドレスなど、ディスクに保存されたテキストビューファイルを扱うためのコマンド
* `governance`: ガバナンスコマンド
* `key`: Key utility commands
* `byron`: Byron specific commands
* `help`: 全てのヘルプを表示する
* `version`: cardano-cliのバージョンを表示する

**cardano-cli address** : `address` コマンドは以下のサブコマンドを含んでいます。
* `key-gen`: 単一のアドレスキーペアを作成
* `key-hash`: アドレスのハッシュを標準出力に表示
* `build`: 支払い先アドレスを構築し、オプションでステークアドレスに委任することが可能
* `build-script`: トークンロックスクリプトを構築
* `info`: アドレスに関する詳細を出力

**cardano-cli stake-address** : `stake-address` コマンドは以下のサブコマンドを含んでいます。
* `key-gen`: 単一のアドレスキーペアを作成
* `build`: ステークアドレスを構築
* `key-hash`: ステーク検証キーのハッシュを表示
* `registration-certificate`: 登録証明書を作成
* `delegation-certificate`: ステークアドレス委任証明書を作成
* `deregistration-certificate`: 登録抹消証明書を作成

**cardano-cli transaction** : `transaction`コマンドは以下のサブコマンドを含んでいます。
* `build-raw`: 低レベルのトランザクションを構築します (フラグは、`--cardano-mode`, `--byron-mode`, `--shelley-mode` を使用します。)
* `build`: 自動的にバランスの取れたトランザクションを構築 (手数料を自動計算します)
* `sign`: トランザクションに署名
* `assemble`: トランザクション目撃者とトランザクション本体を結合し、トランザクションを生成
* `witness`: トランザクションを目撃する
* `submit`: CARANO_NODE_SOCKET_PATH環境変数から取得したUnixドメインソケットを持つローカルノードにトランザクションを提出 (フラグは、 `--cardano-mode`, `--byron-mode`, `--shelley-mode` を使用)
* `calculate-min-fee`: トランザクションの最低手数料を計算
* `calculate-min-required-utxo`: トランザクション出力に最低限必要なADAを計算
* `hash-script-data`: スクリプトデータのハッシュを計算 (datums)
* `txid`: トランザクションIDを取得
* `policyid`: ポリシーIDを取得
* `view`: トランザクションをきれいに表示

**cardano-cli node** : `node` コマンドは以下のサブコマンドを含んでいます。
* `key-gen`: ノードオペレーターのオフラインキーと新しい証明書発行カウンターのキーペアを作成
* `key-gen-KES`: ノードのKES操作キーのキーペアを作成
* `key-gen-VRF`: ノードのVRF操作キーのキーペアを作成
* `key-hash-VRF`: ノードのVRF操作キーのキーハッシュを作成
* `new-counter`: 特定の運用証明書ホットキーのKES進化回数を記録
* `issue-op-cert`: ノード運用証明書を発行

**cardano-cli stake-pool** : `stake-pool` コマンドは以下のサブコマンドを含んでいます。
* `registration-certificate`: ステークプール登録証明書を作成
* `de-registration-certificate`: ステークプールの登録抹消証明書を作成
* `id`: オフラインキーからプールIDを構築
* `metadata-hash`:  メタデータハッシュを取得

**cardano-cli query** : `query` コマンドは以下のサブコマンドを含んでいます。
* `protocol-parameters` (高度): ノードの現在のプールパラメータを取得 (`Ledger.ChainDepState` の生のダンプ)
* `tip`: ノードの現在のチップを取得 (slot number, hash, and block number)
* `stake-pools`: ノードの現在のステークプールIDのセットを取得
* `utxo`: ノードの現在のUTxOを、アドレスでフィルタリングして取得
* `ledger-state` (高度):  ノードの現在の状態をダンプ (`Ledger.NewEpochState`の生のダンプ)* `stake-distribution`: ノードの現在のステークプール ID のセットを取得
* `protocol-state` (高度): ノードの現在のプロトコル状態をダンプ
* `stake-address-info`: ステークアドレスでフィルタリングされた現在の委任と報酬アカウントを取得
* `stake-distribution`: ノードの現在の出資比率を取得
* `stake-snapshot` (高度): ステークプールのステークスナップショット情報を取得
* `pool-params` (高度): ステークプールの現在および将来のパラメータを取得
* `leadership-schedule`: 現在または次のエポックにおいて、ノードがスロットリーダーであるスロットを取得
* `kes-period-info` (高度): 運用証明書に関する診断情報を返却

**cardano-cli governance** : `governance` コマンドは以下のサブコマンドを含んでいます。
* `create-mir-certificate`: MIR (move instantaneous rewards 瞬時の報酬を移動) 証明書を作成
* `create-update-proposal`: 更新提案を作成
* `create-genesis-key-certificate`: ジェネシスキー証明書を取得

**cardano-cli genesis** : `genesis` コマンドは以下のサブコマンドを含んでいます。
* `key-gen-genesis`: ジェネシスキーペアを作成
* `key-gen-delegate`: ジェネシスデリゲートキーペアを作成
* `key-gen-utxo`: ジェネシスUTxOキーペアを作成
* `key-hash`: 公開鍵の識別子またはハッシュを出力
* `get-ver-key`: 署名キーから検証キーを導き出します
* `initial-addr`: 検証キーに基づいて最初のUTxOのアドレスを取得
* `initial-txin`: 検証キーに基づいて、初期UTxOのトランザクションIDを取得
* `create`: Genesis テンプレートから Genesis ファイルを作成し、Genesis キー、Delegation キー、Spending キーも作成
* `create-staked`: staked genesis fileの作成
* `hash`: ハッシュ値を取得

**cardano-cli text-view** : `text-view` コマンドは以下のサブコマンドを含んでいます。
* `decode-cbor`: テキストビューファイルをデコードされたCBORとして表示



## 上級者向けコマンド

`query kes-period-info`:  
このコマンドは、運用証明書と運用証明書発行カウンターに対して以下のチェックを実行します。
- 発行カウンターと運用証明書のカウンターは一致していますか？
- カウンターは、現在のノードの状態と一致していますか？
- 運用証明書で指定されているKESキーの有効期限は、現在のKESキーの有効期限内にありますか？
基本的に、カルダノ元帳仕様のOCERTルールの述語をチェックし、次のように診断情報を追加で表示します。:
```
✓ 運用証明書カウンターは、ノードプロトコル状態カウンターと一致する
✓ 運用証明書のkes期間が正しいKES期間内であること
{
    "qKesNodeStateOperationalCertificateNumber": 6,
    "qKesCurrentKesPeriod": 404,
    "qKesOnDiskOperationalCertificateNumber": 6,
    "qKesRemainingSlotsInKesPeriod": 3760228,
    "qKesMaxKESEvolutions": 62,
    "qKesKesKeyExpiry": "2022-03-20T21:44:51Z",
    "qKesEndKesInterval": 434,
    "qKesStartKesInterval": 372,
    "qKesSlotsPerKesPeriod": 129600
}
```

`query leadership-schedule`:  
このコマンドは、SPO の現在のエポックおよび次のエポックにおけるリーダーシップスロットを計算し、以下のように出力することができます。
```
     SlotNo                          UTC Time
-------------------------------------------------------------
     4073                   2021-12-29 17:26:54.998001755 UTC
     4126                   2021-12-29 17:27:00.298001755 UTC
     4206                   2021-12-29 17:27:08.298001755 UTC
     4256                   2021-12-29 17:27:13.298001755 UTC
     4309                   2021-12-29 17:27:18.598001755 UTC
     4376                   2021-12-29 17:27:25.298001755 UTC
     4423                   2021-12-29 17:27:29.998001755 UTC
     4433                   2021-12-29 17:27:30.998001755 UTC
```


`transaction build ... --calculate-plutus-script-cost`:  
`--calculate-plutus-script-cost`フラグを`transaction build`コマンドとともに使用すると、トランザクション本体内のPlutusスクリプトのコストを計算して、JSONとして出力されます。
```
[
    {
        "executionUnits": {
            "memory": 1700,
            "steps": 476468
        },
        "lovelaceCost": 133,
        "scriptHash": "67f33146617a5e61936081db3b2117cbf59bd2123748f58ac9678656"
    }
]
```
