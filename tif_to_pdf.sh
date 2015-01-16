#!/bin/sh
convert $1 out%d.jpg # tifファイルからjpgファイルを作成
convert -trim -fuzz 20% out*.jpg # jpgの余白を削除
convert out*.jpg "${1}.png" # pdfファイルにまとめる

