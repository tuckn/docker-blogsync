REM blogsync CLI with <A Current Working Direcotry>\.config settings
@ECHO ON

docker run --rm --volume %CD%\.config:/root/.config --volume %CD%\blogs:/root/blogs tuckn/blogsync %*
