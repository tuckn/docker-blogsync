# Dockerfile: blogsync

[x-motemen/blogsync](https://github.com/x-motemen/blogsync)のDockerイメージ。
ポータブルに動作します。

## 背景

上記blogsyncの`post`コマンドが、Windows 10でうまく動作しなかったので作成しました。
標準入力の部分がコマンドプロンプトで動作しない？

## インストール

Dockerをインストールします。

[Get Docker | Docker Documentation](https://docs.docker.com/get-docker/)

このイメージを`pull`します。

```console
> docker pull tuckn/blogsync
```

はてなブログ管理用のディレクトリを作成し、そこに移動します。

```console
> cd "D:\HatenaBlog"
```

設定ファイル格納用のフォルダを`".\.config\blogsync\config.yaml"`に作成します。
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

APIキーは、はてなブログの設定 > 詳細設定 > AtomPubで確認できます。

## 使用方法

### 動作確認

まずは、`list`コマンドで動作を確認してみてください。
コマンドプロンプトで、上記で作成した管理用のディレクトリ（.configディレクトリと同じ階層）に移動し、以下のコマンドを実行します。

```console
D:\HatenaBlog> docker run --rm -v %CD%\.config:/root/.config blogsync list
xxxxx.hatenablog.com /root/blogs/xxxxx.hatenablog.com
```

上記のように、管理されているブログが表示されれば動作しています。

ここで、`%CD%`はカレントディレクトリパスを示しており、上記の例なら`"D:\HatenaBlog"`となります。
以下のように、フルパスで指定しても動作します。

```console
C:\My Works> docker run --rm -v C:\Users\MyName\.config:/root/.config blogsync list
```

相対パス表記では正常に動作しません。

### 全ブログ記事の取得

`pull`コマンドを用いて、すでに投稿済みの全記事を取得できます。

```console
D:\HatenaBlog> docker run --rm -v %CD%\.config:/root/.config -v %CD%:/root/blogs blogsync pull xxxxx.hatenablog.com
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
└─ xxxxx.hatenablog.com\
   └─ entry\
      ├─ 2017\
      ...
```

### コマンドの簡略化

このようにDockerコマンドは長いので、簡略化したバッチファイルを用意しています。
このリポジトリの`./scripts/blogsync.cmd`がそれです。
これを用いると、本来のblogsyncと同じコマンドで実行できるようになります。

```console
D:\HatenaBlog> blogsync pull xxxxx.hatenablog.com
       GET ---> https://blog.hatena.ne.jp/xxxxx/xxxxx.hatenablog.com/atom/entry
       200 <--- https://blog.hatena.ne.jp/xxxxx/xxxxx.hatenablog.com/atom/entry
```

必要に応じて、このバッチファイル内の`%CD%`を書き換えてください。

## License

MIT

Author 2020 [Tuckn](https://github.com/tuckn)