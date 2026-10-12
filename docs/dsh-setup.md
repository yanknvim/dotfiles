# dsh (DeepSeek Harness) 導入手順メモ

調査日: 2026-10-12
対象: dsh `0.2.0-rc.2`（この NixOS 環境の `llm-agents.dsh`）

出典は一次情報のみ: upstream リポジトリの該当タグのドキュメント、npm パッケージの実物、nixpkgs 本体とその issue、手元の `/nix/store` の実物。
`$...` の付いたパスは upstream のドキュメント/コードからの引用。

## 0. 結論（先に）

- upstream が案内する導入は 3 系統 + デスクトップ: **npx**、**ソースから**、**Python SDK**、Electron デスクトップ。NixOS で常用するなら `llm-agents.dsh` が素直（現状は §6 の障害あり）。
- 初回起動時に `$DSH_HOME`（既定 `~/.dsh`）へ profile が自動生成される。profile は「bundle の patch 層を重ねたもの」。
- モデル設定は Web UI の **Settings → Models**、または `DEEPSEEK_API_KEY`。Web UI で入れた鍵は `$DSH_HOME/.credentials.yaml` に保存される。
- プラグイン管理（`dsh plugin`）だけ **pnpm** が要る。この環境には pnpm が入っていない（`which pnpm` が失敗）。
- **NixOS の from-source Node では dsh が起動時に fatal で落ちる**（upstream 未修正）。x86_64 の原因は nixpkgs hardening の `zerocallusedregs` で、dsh が使う node だけ `hardeningDisable = [ "zerocallusedregs" ]` で再ビルドすれば直る（この環境で実測確認済み。§6.4 / §6.5）。

## 1. インストール手段（upstream の案内）

| 手段 | コマンド | 条件・備考 |
| --- | --- | --- |
| npx（最短） | `npx @deepseek-ai/dsh web` | Node.js が必要。既定で `http://127.0.0.1:3080` を配信し、ローカル起動なら既定ブラウザを開く。`--no-open` で抑止。SSH 経由だと URL を表示するだけ |
| ソースから | `git clone` → `pnpm install` → `pnpm run build` → `pnpm dsh web` | `pnpm run build` が成果物を用意する。`pnpm dsh` はビルド済み成果物を使う |
| Python SDK | `python -m pip install deepseek-harness-sdk` | Python 3.10+。ネイティブ runtime wheel と `dsh` コマンドが同梱され、**システム Node 不要**。Linux x64/arm64, macOS 14+ arm64, Windows x64 |
| デスクトップ (Electron) | （公開インストーラの記載はリポジトリ内に見つからず。開発起動は `pnpm run dev:desktop`） | Web UI の Electron シェル。既定ポートは `19387`（Web の 3080 とは別）。`desktop` という profile 名は予約済みで CLI からは起動できない。npm 版 dsh からはデスクトップの profile を操作できない |

- 出典: [root README#Run](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.2.0-rc.2/README.md#run)、[Python SDK ガイド](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.2.0-rc.2/docs/user/guide/python-sdk.md)、[CLI README](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.2.0-rc.2/apps/cli/README.md)、[Desktop README](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.2.0-rc.2/apps/desktop/README.md)。
- npm パッケージは `bin: { dsh: "lib/bin.js" }` なので `npm i -g @deepseek-ai/dsh` も技術的には可能（package.json の `engines` 指定は無く、README の要求は「Node.js」のみ）。ただし upstream の README に記載があるのは npx とソースからの 2 つだけ。
- 実装側が想定している Node は 22/24/26（`dsh-app-boot` の「the supported Node 22/24/26 matrix」というコメント）。
- 位置づけ: developer preview で互換性破壊が起きる前提（[root README](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.2.0-rc.2/README.md)）。モデル生成コードと第三者プラグインを実行し、サンドボックスは保証ではない（[SAFETY.md](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.2.0-rc.2/SAFETY.md)）。

## 2. `$DSH_HOME` と配置

- Harness のユーザーデータは 1 か所に集約される。解決順は「明示設定 > `$DSH_HOME` > `~/.dsh`」。空/空白のみの `DSH_HOME` は未設定扱い。（`@deepseek-ai/dsh-home-paths` の実装、`resolveDshHome()`）
- `$DSH_HOME/profiles/<name>/` に profile がある。中身は `package.json`（`dsh.profile.bundles` の順序付きリスト + 外部プラグイン依存）、`cordis.patch.yml`（ユーザー自身の patch 層）、`pnpm-workspace.yaml`。
- ログは `$DSH_HOME/logs/`（起動失敗時は `startup-<timestamp>-<uuid>.log`）。出典: [CLI behavior reference](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.2.0-rc.2/apps/cli/reference/README.md)（startup diagnostics）。

## 3. 初回起動の流れ（Web UI）

1. `dsh web`（= `dsh --profile web`）。`web`/`headless`/`sdk`/`sdk-minimal`/`acp` は **初回に同梱テンプレートから自動生成**される。それ以外の名前は存在しないとエラーになり、`dsh plugin --profile <name> add <package>` を案内される。
2. 起動すると URL を表示する（既定 `http://127.0.0.1:3080`）。`--host` / `--port` / 繰り返し可の `--trusted-host` / `--no-open` は app 側の引数。
3. Web UI でワークスペースを選ぶ。**invoking directory（`dsh` を実行したディレクトリ）が既定のワークスペース root** だが、Web UI は明示的に追加するまで未選択（コンポーザが無効）。
4. セッションを開始してタスクを投げる。

- 出典: [Web UI ガイド](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.2.0-rc.2/docs/user/guide/index.md)、[CLI behavior reference](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.2.0-rc.2/apps/cli/reference/README.md)。
- 同梱テンプレート（`dsh-app-boot` の `PROFILE_TEMPLATES`）:

  | name | bundles |
  | --- | --- |
  | `web` | `@deepseek-ai/dsh-base`, `@deepseek-ai/dsh-web-app` |
  | `headless` | `@deepseek-ai/dsh-base`, `@deepseek-ai/dsh-headless` |
  | `sdk` | `@deepseek-ai/dsh-base`, `@deepseek-ai/dsh-sdk-app` |
  | `sdk-minimal` | `@deepseek-ai/dsh-sdk-minimal` |
  | `acp` | `@deepseek-ai/dsh-base`, `@deepseek-ai/dsh-acp-app` |

  例に `dsh tui` が出てくるが `tui` は同梱されていない（プラグインとして自分で入れる前提）。
- カスタム profile: `dsh rescue --from-default-profile web`。同梱名のまま別名は作れない（同梱名を target にするとエラー）。コピーされるのはテンプレートのみで、同名の同梱 profile は読まれない。
- 合成順（後勝ち）: `dsh.profile.bundles` の各 bundle patch → profile の `cordis.patch.yml` → `$DSH_HOME/cordis.patch.yml` → `--patch <path>`（argv 順）。patch は対象行の `config` を**丸ごと置換**する（キーの deep merge ではない）。
- 合成結果の確認: `--dump-default-config`（bundle 層のみ）、`--dump-config`（ユーザー層 + `--patch` 込み）、`--dump-config-schema`。dump は起動しないが、不足している profile ファイルは初期化する。
- 予約名 `desktop` は CLI から起動/dump できない。

## 4. モデルと認証情報

- Web UI: **Settings → Models** で DeepSeek の API キーを入れて保存する。フィールドは write-only（保存後は伏せた descriptor しか返らない）。鍵は `$DSH_HOME/.credentials.yaml` に保存され、設定側には credential 参照だけが残る。
- 資格情報の解決順（先勝ち）: 継承した環境変数 → `$DSH_HOME/.credentials.yaml` → invoking directory の `.env` → `$DSH_HOME/.env`。
- 既定のキー環境変数は `DEEPSEEK_API_KEY`（`dsh-llm-deepseek-api-key` の `apiKeyEnv` デフォルト）。検索（web_search）も `DEEPSEEK_API_KEY` を使い、`DEEPSEEK_SEARCH_BASE_URL` を受け付ける。プロキシ/自前エンドポイントは `DEEPSEEK_BASE_URL`。
- `.env` の扱い（`dsh-app-boot` の `loadLayeredEnv` / `isBootstrapOnly`）:
  - `$DSH_HOME/.env` と invoking directory の `.env` が読まれる。
  - `DSH_*` / `XDG_*` / `DYLD_*` / `SSL_CERT_*` / `NODE_TLS_REJECT_UNAUTHORIZED` などは **bootstrap-only** で、`.env` には書けない（書くと起動時にエラー）。プロキシ系（`HTTP_PROXY` 等）だけは `$DSH_HOME/.env` なら許可。
  - 環境変数側が既にあれば `.env` は上書きしない。
- 第三者プロバイダ: `llm-pi-ai` の row を profile の `cordis.patch.yml` に書く。`apiKeyEnv` / `api: openai-completions` / `baseURL` / `models` / `compat` など。カスタムエンドポイントの手順は providers ガイドが一次情報。
- テレメトリ: base bundle は DeepSeek の session-log upload（既定 on）と OTel upload（feedback 時）を積む。無効化は `DSH_TELEMETRY_DISABLED`（`dsh` の `resolveTelemetryPatch` が `session-telemetry-otel` 行を disabled にする）。
- 出典: [providers ガイド](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.2.0-rc.2/docs/user/guide/providers.md)、`@deepseek-ai/dsh-llm-deepseek-api-key` の README（`/nix/store/...-dsh-0.2.0-rc.2/.../dsh-llm-deepseek-api-key/README.md`）、[CLI behavior reference](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.2.0-rc.2/apps/cli/reference/README.md) の Shared deployment behavior、`dsh-app-boot` の実装。

## 5. プラグイン管理

- `dsh plugin --profile <name> <pnpm args>` は profile ディレクトリで **pnpm に転送する**。`pnpm` は管理コマンドのときだけ必要（起動には不要）。`pnpmCommand` の既定は `pnpm`（PATH から解決）。
- インストールされたパッケージが `dsh.bundle` 層を export していれば `dsh.profile.bundles` に記録される。有効/無効は Web の plugin ページまたは `plugin_manager` ツールから。
- 同梱されているが既定では無効の optional bundle: `@deepseek-ai/dsh-experimental-agent-team-profile`, `-voice-input-bundle`, `-auto-review`, `-schedule-bundle`。
- バージョン整合: 宣言された DSH peer range が `dsh --version` の runtime と照合される。非互換は**明示的な exact-version exemption** が要る:
  - `dsh plugin --profile <profile> version-exemptions`
  - `dsh plugin --profile <profile> allow-version <package@version> --dsh-version <runtime> --accept-risk`
  - `dsh plugin --profile <profile> revoke-version <package@version> --dsh-version <runtime>`
- インストール失敗・キャンセル時は `package.json` と `pnpm-lock.yaml` をスナップショットへ戻す（pnpm が落としたファイルは残り得る）。profile 書き込みはロックで直列化され、成功した bundle の無効化状態は package 更新をまたいで保持される。
- HMR が YAML で有効なら patch 変更は即時反映、無効なら再起動。
実際の追加手順（profile = `web` の例）:

```sh
# 1) まず profile を初期化（未生成なら）
dsh --profile web --dump-default-config >/dev/null

# 2) 追加。引数は profile ディレクトリで pnpm に転送される
dsh plugin --profile web add @scope/my-dsh-plugin        # レジストリ
dsh plugin --profile web add file:/abs/path/to/plugin    # ローカル
dsh plugin --profile web add github:org/repo             # git（prepare のビルド承認が必要）
dsh plugin --profile web add ./my-plugin.tgz             # ビルド済み tarball（承認不要）

# 3) 反映確認（HMR 無効なら再起動で反映）
dsh --profile web --dump-config | grep -n my-dsh-plugin

# 4) 削除
dsh plugin --profile web remove my-dsh-plugin
```

- add が成功すると、`dsh.bundle` 層を export しているパッケージが `dsh.profile.bundles` に記録され有効になる（"installation selects the bundle after pnpm succeeds"）。`dsh.bundle` を持たないパッケージは `not-a-bundle` で何も起きない。
- pnpm ≥10 は依存パッケージのビルドスクリプトを止める。git ソースのプラグインは `prepare` でビルドするため初回 add が失敗し、pnpm が `allowBuilds` のヒントを出し、dsh が profile の `pnpm-workspace.yaml` を指す。そこに出力されたキーを書いて再実行する。ローカルチェックアウトやビルド済み tarball は承認不要。Web UI 側は **Allow these scripts and retry** で承認できる。
- enable/disable だけを CLI でやるサブコマンドは無い（`dsh plugin` が横取りするのは `add`/`remove` と `version-exemptions` / `allow-version` / `revoke-version`）。bundle の有効/無効は Web の plugin ページ、または `cordis.patch.yml` / `plugin_manager` ツール経由。
- 出典例: `dsh plugin --profile tui add github:deepseek-harness/turtle-ui` → `dsh plugin --profile tui remove turtle-ui` → `dsh --profile tui`（[CLI behavior reference](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.2.0-rc.2/apps/cli/reference/README.md)）。

- 出典: [plugin-manager README](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.2.0-rc.2/packages/boot/plugin-manager/README.md)（特に [version compatibility and exemptions](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.2.0-rc.2/packages/boot/plugin-manager/README.md#version-compatibility-and-exemptions)）、[CLI README](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.2.0-rc.2/apps/cli/README.md)、[Python SDK ガイド](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.2.0-rc.2/docs/user/guide/python-sdk.md)。

## 6. NixOS 固有の注意（この環境の障害）

### 6.1 症状

`llm-agents.dsh`（nixpkgs の from-source Node でラップ）は起動時に fatal:

```
dsh: host preparation failed: node-addon-require-builtin unsupported:
Unsupported/no-getter (x64 sysv getter is not a recognized this->field accessor ...)
```

`--expose-internals` はラッパーが既に渡しているが無効。`dsh-app-boot` の `internalModules()` が **無条件に** addon を呼び、native `require` への降格分岐が無いため（0.2.0-rc.2 / 0.2.1-alpha.2 で確認）。

### 6.2 原因

`node-addon-require-builtin` は実行中の node バイナリを逆アセンブルし、getter のバイト列から V8 フィールド offset を復元する。このバイト列がビルドフラグに敏感で、nixpkgs ビルドでは一致しない。

- この環境（x86_64-linux, node 24.21.0）で addon が読んだ getter: `48 8b 87 00 02 00 00 31 ff c3` = `mov rax,[rdi+0x200]; xor edi,edi; ret`
- 最小 C 再現（gcc, `-O2`）:

  | フラグ | 生成コード |
  | --- | --- |
  | `-O2` | `movq 512(%rdi),%rax` ; `ret` |
  | `-O2 -fzero-call-used-regs=used-gpr` | `movq 512(%rdi),%rax` ; **`xorl %edi,%edi`** ; `ret` |
  | `-O2 -fno-omit-frame-pointer -mno-omit-leaf-frame-pointer` | 変化なし（x86_64 ではこの getter に前導が付かない） |

  → x86_64 の原因は nixpkgs の hardening `zerocallusedregs`（`-fzero-call-used-regs=used-gpr`）の `xor edi,edi`。nixpkgs の定義: [add-hardening.sh L180](https://github.com/NixOS/nixpkgs/blob/b4fd65b198c599cbe814fcb9f42d25d021595ec9/pkgs/build-support/cc-wrapper/add-hardening.sh#L180)（`hardeningDisable` で個別に切れる）。
- arm64（macOS）は原因が別で、cc-wrapper が全 aarch64/x86_64 ビルドに足す `-fno-omit-frame-pointer -mno-omit-leaf-frame-pointer` によるスタックフレーム前導。詳細と反証実験は [nixpkgs#565667 の aarch64-darwin コメント](https://github.com/NixOS/nixpkgs/issues/565667)。
- Node のバージョンを変えても直らない（nixpkgs ビルドである限り 24.14〜26.9 すべて失敗、複数報告）。公式 nodejs.org ビルドは同一バージョンで成功。

### 6.3 upstream の状況（2026-10-12 時点）

- `node-addon-require-builtin`: 最新 0.1.9 でも未修正。
- `dsh`: 最新 `0.2.1-alpha.2` の `dsh-app-boot` も `internalModules()` は無条件に addon を呼ぶ（実物を確認）。
- `--expose-internals` は 0.1.x では回避策だったが 0.2.0-rc.2 では効かない。`NODE_OPTIONS` には入れられない（`--expose-internals is not allowed in NODE_OPTIONS`）。
- 関連: dsh discussions [#690](https://github.com/deepseek-ai/deepseek-harness/discussions/690) / [#752](https://github.com/deepseek-ai/deepseek-harness/discussions/752) / [#113](https://github.com/deepseek-ai/deepseek-harness/discussions/113)、nixpkgs [#565667](https://github.com/NixOS/nixpkgs/issues/565667)（OPEN、修正 PR なし）。
- discussion #690 の推奨修正 #1 は「addon 失敗時に native require へ降格させる」。nixpkgs 側でフレームポインタ既定値を戻すのは ffmpeg/blender 等まで巻き込むため非現実的（同 issue のコメント）。

### 6.4 回避策の候補

| 案 | 内容 | 影響範囲 |
| --- | --- | --- |
| A. nodejs を override | dsh が使う node だけ `hardeningDisable = [ "zerocallusedregs" ]`（x86_64）で再ビルドして渡す。arm64 なら `NIX_CFLAGS_COMPILE = "-fomit-frame-pointer -momit-leaf-frame-pointer"`。**x86_64 では実測で効果を確認済み**（§6.5） | node のビルドのみ。他パッケージは再ビルドされない |
| B. dsh を patch | addon の入口、または `internalModules()` を「`--expose-internals` があれば native `require('internal/...')`」に降格させる（ラッパーは既にこのフラグを渡している） | dsh の JS のみ。upstream の推奨修正と同じ位置 |
| C. 公式 Node を使う | nodejs.org の prebuilt で dsh を起動する（NixOS では patchelf が要る） | 追加のラッパーが必要。upstream も「公式 Node なら動く」ことを確認 |

- 案 A の nix 断片（dsh は `nodejs` を引数に取るので `.override` で差し替えられる）:

  ```nix
  llm-agents = prev.llm-agents // {
    dsh = prev.llm-agents.dsh.override {
      # nixpkgs の hardening `zerocallusedregs` = -fzero-call-used-regs=used-gpr が
      # V8 getter の epilogue に xor を足し、addon のバイト列マッチを壊す。
      # node だけ再ビルドして外す（ffmpeg 等への波及なし）。
      # runtime に npm は不要なので nodejs-slim でよい（flake.nix に入れたのは slim）。
      nodejs = final.nodejs-slim.overrideAttrs {
        hardeningDisable = [ "zerocallusedregs" ];
      };
    };
  };
  ```

- 補足: nixpkgs の `dsh` 相当は `llm-agents.dsh`（`buildNpmPackage` + `makeWrapper node --expose-internals .../lib/bin.js`、`/bin/bash` を `bashInteractive` に置換）: [packages/dsh/package.nix](https://github.com/numtide/llm-agents.nix/blob/0080f911989ebe6385bffbd2d4f2b1259a16f4cf/packages/dsh/package.nix)、[hashes.json](https://github.com/numtide/llm-agents.nix/blob/0080f911989ebe6385bffbd2d4f2b1259a16f4cf/packages/dsh/hashes.json)。

### 6.5 検証ログ

- addon 単体（Node 24.21.0, nixpkgs ビルド）: `require('node-addon-require-builtin').requireBuiltin('internal/modules/esm/loader')` → `Unsupported/no-getter`。同条件で `node --expose-internals -e "require('internal/modules/esm/loader')"` は成功。
- `--expose-internals` 下で `internalModules()` が要求する 5 モジュール（esm/loader, cjs/loader, helpers, esm/utils, esm/resolve）が全て取れることを確認。
- worker thread は `execArgv` を継承し、worker 内でも `require('internal/...')` が使えることを確認（案 B が worker 側 `profile-resolution-bootstrap.js` でも効く根拠）。
- 案 A の実測（`nodejs-slim 24.21.0` を `hardeningDisable = [ "zerocallusedregs" ]` で再ビルド、16 コアで約 30 分）:

  ```text
  # 通常の nixpkgs Node
  getter bytes: 48 8b 87 00 02 00 00 31 ff c3   -> FAIL (Unsupported/no-getter)

  # hardeningDisable = [ "zerocallusedregs" ] で再ビルドした Node
  getter bytes: 48 8b 87 00 02 00 00 c3 ...
  parsed offset=0x200 pattern=linux-glibc-x64 mov-rax-[this-rdi] disp32
  RESULT: OK function
  ```

  さらにこの Node で dsh 本体を起動確認（`node .../dsh/lib/bin.js --profile web --no-open --port 0`）: addon 経由・`--expose-internals` 併用の両方で `dsh web: http://127.0.0.1:.../?token=...` まで到達。

  ```sh
  nix build --no-link --print-out-paths --impure --expr '
    let f = builtins.getFlake (toString ./.);
    in f.nixosConfigurations.sanatia.pkgs.nodejs-slim.overrideAttrs (old: {
      hardeningDisable = [ "zerocallusedregs" ];
    })'
  ```

- 参考（`.override` の評価確認、ビルドはしていない）: `pkgs.llm-agents.dsh.override { nodejs = pkgs.nodejs.overrideAttrs { hardeningDisable = [ "zerocallusedregs" ]; }; }` → 新しい drv が生成される。

## 7. 出典

- dsh リポジトリ（`dsh-v0.2.0-rc.2` タグ）: [README#Run](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.2.0-rc.2/README.md#run) / [apps/cli/README.md](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.2.0-rc.2/apps/cli/README.md) / [apps/cli/reference/README.md](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.2.0-rc.2/apps/cli/reference/README.md) / [docs/user/guide/index.md](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.2.0-rc.2/docs/user/guide/index.md) / [providers.md](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.2.0-rc.2/docs/user/guide/providers.md) / [python-sdk.md](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.2.0-rc.2/docs/user/guide/python-sdk.md) / [plugin-manager](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.2.0-rc.2/packages/boot/plugin-manager/README.md) / [SAFETY.md](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.2.0-rc.2/SAFETY.md)
- npm: `@deepseek-ai/dsh`（dist-tags: `latest=0.2.0-rc.2`, `alpha=0.2.1-alpha.2`）
- 手元の実物: `/nix/store/j180lw8q1g0mdxsp21swmnjbajc7my76-dsh-0.2.0-rc.2/lib/node_modules/@deepseek-ai/dsh/`（README、`lib/bin.js`、`dsh-app-boot` の `PROFILE_TEMPLATES` / `loadLayeredEnv` / `resolveTelemetryPatch`）
- NixOS: [nixpkgs#565667](https://github.com/NixOS/nixpkgs/issues/565667)、nixpkgs `b4fd65b198c599cbe814fcb9f42d25d021595ec9`
- dsh discussions: [#690](https://github.com/deepseek-ai/deepseek-harness/discussions/690) / [#752](https://github.com/deepseek-ai/deepseek-harness/discussions/752) / [#113](https://github.com/deepseek-ai/deepseek-harness/discussions/113)
