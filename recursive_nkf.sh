#!/bin/sh

# ${1}にはファイルの絶対パスが格納されている
echo "working on "${1##*/}
# 文字コードをutf-8へ上書き変換
nkf --overwrite -w8 ${1}
# 文字コードを見れる
# nkf -g ${1}
