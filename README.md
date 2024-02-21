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

4 はてなブログ管理用のディレクトリを作成し、そこに移動します。

```console
C:\>cd /d "D:\HatenaBlog"
D:\HatenaBlog>
```

上記`/d`オプションは、異なるドライブに移動する場合にのみ付与します。

5 設定ファイル格納用のフォルダを`".\.config\blogsync\config.yaml"`に作成します。
例えば、上記で示した`"D:\HatenaBlog"`の場合は、`"D:\HatenaBlog\.config\blogsync\config.yaml"`に作成します。

```console
D:\HatenaBlog\
└─ .config\
    └─ blogsync\
      └─ config.yaml
```

*config.yaml*に以下の内容を書き込み、保存します。

```yaml
<ユーザー名>.hatenablog.com:
  username: <ユーザー名>
  password: <APIキー>
default:
  local_root: /root/blogs
```

保存するファイルのエンコード形式はUTF8が適切でしょう。
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
コマンドプロンプトで、上記で作成した管理用のディレクトリ（.configディレクトリと同じ階層）に移動し、以下のコマンドを実行します。

```console
D:\HatenaBlog>docker run --rm -v %CD%\.config:/root/.config tuckn/blogsync list
```

以下のように、管理されているブログが表示されれば動作しています。

```cmd
xxxxx.hatenablog.com /root/blogs/xxxxx.hatenablog.com
```

なお、`%CD%`はカレントディレクトリパスを示しており、上記の例なら`"D:\HatenaBlog"`となります。
以下のように、`%CD%`の変わりにフルパスで指定しても動作します。

```console
C:\>docker run --rm -v C:\Users\MyName\.config:/root/.config tuckn/blogsync list
```

相対パス表記では正常に動作しません。

### 全ブログ記事の取得

`pull`コマンドを用いて、すでに投稿済みの全記事を取得できます。

```console
D:\HatenaBlog>docker run --rm -v %CD%\.config:/root/.config -v %CD%\blogs:/root/blogs tuckn/blogsync pull xxxxx.hatenablog.com
       GET ---> https://blog.hatena.ne.jp/xxxxx/xxxxx.hatenablog.com/atom/entry
       200 <--- https://blog.hatena.ne.jp/xxxxx/xxxxx.hatenablog.com/atom/entry
     fresh remote=2020-01-23 21:14:25 +0900 +0900 > local=0001-01-01 00:00:00 +0000 UTC
     store /root/blogs/xxxxx.hatenablog.com/entry/2020/01/01/123456.md
```

実行すると、上記の例なら`D:\HatenaBlog\xxxxx.hatenablog.com`というディレクトリが作成され、その中に記事が格納されます。

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
このリポジトリの`./samples/blogsync.cmd`がそれです。
はてなブログ管理用のディレクトリ（今回の例だと`D:\HatenaBlog`）などにコピーして使ってください。
これを用いると、本来のblogsyncと同じコマンドを実行できるようになります。

```console
D:\HatenaBlog>blogsync pull xxxxx.hatenablog.com
       GET ---> https://blog.hatena.ne.jp/xxxxx/xxxxx.hatenablog.com/atom/entry
       200 <--- https://blog.hatena.ne.jp/xxxxx/xxxxx.hatenablog.com/atom/entry
```

必要に応じて、このバッチファイル内の`%CD%`を書き換えてください。

## License

MIT

Author 2020 [Tuckn](https://github.com/tuckn)