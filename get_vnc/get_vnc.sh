#!/bin/bash
#author: Qibintao

# 获取传递的 IP 参数
#ip=$1
#uuid=$2
#ssh Foton_cloud_server$ip ps -ef |grep $uuid | awk '{for(i=1;i<=NF;i++) if($i ~ /-vnc/) printf "%s %s\n", $i, $(i+1)}'


PWD=`pwd`

if [ -f "$PWD/vnc.txt" -o -f "$PWD/notfound.txt" ]; then
    echo "准备工作: 历史统计文件存在，正在删除..."
    rm -rf $PWD/vnc.txt $PWD/notfound.txt
    echo "准备工作: 历史统计文件(vnc.txt/notfound.txt)已删除。"
else
    echo "准备工作: 历史统计文件(up.txt/notfound.txt)不存在，无需删除。"
fi

for i in `cat $PWD/down.txt`
do
   grep "$i$" $PWD/info.txt > /dev/null 2>&1 
   if [ $? -eq 0 ]
   then
       oc=`grep "$i$" $PWD/info.txt | awk -F '[ ]+|oc' '{print $3}'`
       uuid=`grep "$i$" $PWD/info.txt | awk -F '[ ]+|oc' '{print $1}'`
       vnc=`ssh Foton_cloud_server$oc ps -ef |grep $uuid | awk '{for(i=1;i<=NF;i++) if($i ~ /-vnc/) printf "%s %s\n", $i, $(i+1)}'`
       echo "$i $vnc" >>$PWD/vnc.txt
       echo "$i vnc已获取"
   else
      echo "$i 未找到uuid,不存在ip保存在 "$PWD/notfound.txt" 文件中"
      echo "$i" >>$PWD/notfound.txt
   fi
done
