#!/bin/sh

# 複数引数に対応したgetopt関数の派生ver
getoptx(){
	# 置換文字列
	div="=div="
	space="=space="
 	ARGS=$@
  	ARGS=`echo ${ARGS// /$space}|sed -e "s/\-/${div}/g"`
	# 配列に格納
  	OPTS=(${ARGS//$div/ })
  	itr_i=0

  	while test $itr_i -lt ${#OPTS[*]};do
  		OPT=(${OPTS[$itr_i]//$space/ })
    	# ${OPT[1]}に一つ目の引数、${OPT[2]}に二つ目の引数が格納されている
	# ;; は break
    	case ${OPT[0]} in
    	h)
    		echo "使い方: epsConverter.sh <fileName.jpg> <fileName2.jpg> ..."
	  	exit 0
    		;;
	\?)
		echo "invalid option"
    	  	exit 1
    		;;
    	esac
	# 複数引数に対応させるためのwhile
    	itr_i=`expr $itr_i + 1`
  	done
}

getoptx $@

for path in $@
do
	extension=${path##*.}
	pathWithoutExt=${path%.*}
	echo $pathWithoutExt
	if [ -f $path ]
	then
		if [ $extension = png -o $extension = jpg -o $extension = JPG -o $extension = bmp -o $extension = BMP ] 
		then
			convert $path ${pathWithoutExt}.eps
		else
			echo “拡張子が画像じゃないぞ”
		fi
	else
		echo “ファイルじゃないぞ”
	fi
done
