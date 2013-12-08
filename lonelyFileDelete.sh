#!/bin/sh

# 同名、違う拡張子のフォルダをそれぞれ1つ指定して、不必要なファイルを削除します

# $# は引数の数を数える
if [ $# -ne 1 -a $# -ne 2 -a $# -ne 5 ] ; then
	echo "指定された引数は$#個で、不適切です．-hでヘルプを見て下さい"
	exit 1
fi

if [ $# = 2 ] ; then 
	lonelyExt="ORF"
	neededExt="JPG"
fi


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
    		echo "使い方: lonelyFileDelete.sh <lonelyFileが存在するディレクトリ(ORFファイルなど)> <必要なファイルのみが存在するディレクトリ(JPGなど)> -e ORF JPG"
			echo "デフォルトでは <lonelyFileが存在するディレクトリ>の拡張子はORFで、<必要なファイルのみが存在するディレクトリ>の拡張子はJPGです"
	  		exit 0
    		;;
    	e)
			lonelyExt=${OPT[1]}
			neededExt=${OPT[2]}
    	  	echo "lonely extention::"${OPT[1]}"  needed extention::"${OPT[2]}
    		;;
    	\?)
    		#例外オプションの処理
			echo "invalid option"
    	  	exit 1
    		;;
    	esac
	# 複数引数に対応させるためのwhile
    	itr_i=`expr $itr_i + 1`
  	done
}

# 上記の関数の実行
getoptx $@

lonelyFileDir=$1
neededFileDir=$2

if [ ! -d ${lonelyFileDir} -o ! -d ${neededFileDir} ] ; then
	echo "ディレクトリではないか、ディレクトリが存在しません"
        exit 1
fi

lonelyFileDirList="${lonelyFileDir}/*"
for lonelyFilePath in ${lonelyFileDirList}
do
	echo $lonelyFilePath
	extension=${lonelyFilePath##*.}
	if [ ${extension} = ${lonelyExt} ] ; then
		#ファイル名の取得
		lonelyFileName=${lonelyFilePath##*/}
		#拡張子を消す
		lonelyFileNameWithoutExt="${lonelyFileName%.*}"
		#必要なファイルの絶対パス
		neededFilePath="${neededFileDir}/${lonelyFileNameWithoutExt}.${neededExt}"
		#必要なファイルが存在しなければ、それはlonely file なので削除
		if [ ! -e ${neededFilePath} ] ; then
			echo "${lonelyFileNameWithoutExt}.${lonelyExt} が削除されました"
			rm ${lonelyFilePath}
		fi
	else
		echo "${lonelyExt}ファイルじゃないぞ"
	fi
done

