# Dockerfile: tuckn/blogsync

[x-motemen/blogsync](https://github.com/x-motemen/blogsync)のDockerイメージ。
ポータブルに動作します。

## 背景

上記blogsyncの`post`コマンドが、Windows 10でうまく動作しなかったので作成しました。
標準入力の部分がコマンドプロンプトで動作しない？

Goがインストールされていない環境でも、最新のblogsyncを使えるようになります。

## インストール

1 Dockerをインストールします。

[Get Docker | Docker Documentation](https://docs.docker.com/get-docker/)

2 このイメージを`pull`します。

```console
C:>docker pull tuckn/blogsync
```

3 `docker images`コマンドで`tuckn/blogsync`イメージが存在するか確認します。

```console
C:\>docker images
REPOSITORY        TAG       IMAGE ID       CREATED          SIZE
tuckn/blogsync    latest    xxxxxxxxxxxx   12 minutes ago   934MB
```

4 はてなブログ管理用のフォルダ（今回の例は`D:\HatenaBlog`）を作成し、そこに移動します。

```console
C:\>cd /d "D:\HatenaBlog"
D:\HatenaBlog>
```

上記`/d`オプションは、異なるドライブに移動する場合にのみ付与します。

5 設定ファイル格納用のフォルダを`.config\blogsync\config.yaml`に作成します。
例えば、上記で示した`D:\HatenaBlog`の場合は、`D:\HatenaBlog\.config\blogsync\config.yaml`に作成します。

```console
D:\HatenaBlog\
└─ .config\
    └─ blogsync\
      └─ config.yaml
```

*config.yaml*に以下の内容を書き込み、保存します。

```yaml
<ブログID>.hatenablog.com:
  username: <はてなID>
  password: <APIキー>
default:
  local_root: /root/blogs
```

保存するファイルのエンコード形式はUTF8が適切でしょう。

ブログIDは、おそらく「はてなID」を小文字にしたものだと思われますが、正確な情報は探せませんでした…。
APIキーは、はてなブログの設定 > 詳細設定 > AtomPubで確認できます。

5 *blogs*フォルダを作成します。

```console
D:\HatenaBlog\
├─ .config\
└─ blogs\ ←
```

このフォルダ中にブログファイルが格納されます。

5、6の設定に不安がある方は、このリポジトリにある`.\samples`フォルダをコピーして使ってください。

## 使用方法

### 動作確認

まずは、`list`コマンドで動作を確認してみてください。
コマンドプロンプトで、上記で作成した管理用のフォルダ（上記例だと`D:\HatenaBlog\`フォルダ）に移動し、以下のコマンドを実行します。

```console
D:\HatenaBlog>docker run --rm -v %CD%\.config:/root/.config tuckn/blogsync list
```

以下のように、管理されているブログが表示されれば動作しています。

```cmd
xxxxx.hatenablog.com /root/blogs/xxxxx.hatenablog.com
```

> [!TIP]
`docker run`コマンドにより、`blogsync`コマンドがDebian（Linux系OS）上で動作します。
上記の例の場合、Windows上の`D:\HatenaBlog\`フォルダがLinux上の`/root/`として扱われます。

> [!TIP]
`%CD%`はカレントフォルダパスを示しており、上記の例なら`"D:\HatenaBlog"`となります。
以下のように、`%CD%`の変わりにフルパスで指定しても動作します。

```console
C:\>docker run --rm -v C:\Users\MyName\.config:/root/.config tuckn/blogsync list
```

相対パス表記では正常に動作しません。

### ブログ全記事の取得

`pull`コマンドを用いて、はてなブログに投稿した全記事（下書き含む）のファイルを取得できます。

```console
D:\HatenaBlog>docker run --rm -v %CD%\.config:/root/.config -v %CD%\blogs:/root/blogs tuckn/blogsync pull xxxxx.hatenablog.com
       GET ---> https://blog.hatena.ne.jp/xxxxx/xxxxx.hatenablog.com/atom/entry
       200 <--- https://blog.hatena.ne.jp/xxxxx/xxxxx.hatenablog.com/atom/entry
     fresh remote=2020-01-23 21:14:25 +0900 +0900 > local=0001-01-01 00:00:00 +0000 UTC
     store /root/blogs/xxxxx.hatenablog.com/entry/2020/01/01/123456.md
```

実行すると、上記の例なら`D:\HatenaBlog\xxxxx.hatenablog.com`というフォルダが作成され、その中に記事が格納されます。

```console
D:\HatenaBlog\
├─ .config\
│  └─ blogsync\
│     └─ config.yaml
└─ blogs\
  └─ xxxxx.hatenablog.com\
     └─ entry\
        ├─ _draft\
        ├─ 2017\
        ...
```

### コマンドの簡略化

このように、このDockerコマンドは長くなるので、簡略化したバッチファイルを用意しています。
このリポジトリの`./samples/scripts/`フォルダにある`.cmd`ファイルです。
実行する場合、はてなブログ管理用のフォルダ（今回の例だと`D:\HatenaBlog`）から実行してください。

```console
D:\HatenaBlog\ ←
├─ .config\
├─ blogs\
└─ scripts\
        ├─ blogsync.cmd
        ...
```

この位置関係の場合、以下が`blogsync pull`の実行例です。

```console
D:\HatenaBlog>scripts\blogsync.cmd pull xxxxx.hatenablog.com
or
D:\HatenaBlog>scripts\blogsync_pull.cmd pull <ブログID>
```

結果

```console
       GET ---> https://blog.hatena.ne.jp/xxxxx/xxxxx.hatenablog.com/atom/entry
       200 <--- https://blog.hatena.ne.jp/xxxxx/xxxxx.hatenablog.com/atom/entry
```

#### 下書き用スクリプト

```console
D:\HatenaBlog>scripts\blogsync_post_draft.cmd <ブログID> PREP
```

結果

```console
      POST ---> https://blog.hatena.ne.jp/xxxxx/xxxxx.hatenablog.com/atom/entry
       201 <--- https://blog.hatena.ne.jp/xxxxx/xxxxx.hatenablog.com/atom/entry
     store /root/blogs/xxxxx.hatenablog.com/entry/_draft/9999999999999999999.md
/root/blogs/xxxxx.hatenablog.com/entry/_draft/9999999999999999999.md
```

#### 下書き削除用スクリプト

```console
D:\HatenaBlog>scripts\blogsync_remove_draft.cmd <ブログID> 9999999999999999999.md
```

結果

```console
    DELETE ---> https://blog.hatena.ne.jp/xxxxx/xxxxx.hatenablog.com/atom/entry/9999999999999999999
       200 <--- https://blog.hatena.ne.jp/xxxxx/xxxxx.hatenablog.com/atom/entry/9999999999999999999
```

## License

MIT

Author 2020 [Tuckn](https://github.com/tuckn)