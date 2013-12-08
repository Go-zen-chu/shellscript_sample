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
		# helpコマンド
		echo "This script will make the command run in all child directory you specified"
    		echo "recursive_func.sh <any shellscript command> <directory's path>"
		echo "example: recursive_func.sh recursive_nkf.sh <directory path>"
	  	exit 0
    		;;
	# defaultに同じ
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

# 使い方： for_all_file_in_dir.sh <for_コマンド名> <再帰するディレクトリのパス>	
# コマンドが引数として取れるのは、再帰されたファイルの絶対パスのみ
function recursive_call {
    # リスト内包表記
    for file_name in `ls ${2}`
        do
			# local を付けた変数は スコープを括弧ないでしか持たなくなる
			local full_path=${2}/${file_name}
			if [ -f ${full_path} ] 
			then 
				${1} ${full_path} # 実行
			elif [ -d ${full_path} ] 
			then 
				recursive_call ${1} ${full_path} # 再帰呼び出し
			fi
		done
}

# 引数を二つ取って関数recursive_callに渡す
recursive_call ${1} ${2}


