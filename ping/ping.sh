#!/bin/bash
dir=`pwd`
ipfile=$dir/ip.txt
upfile=$dir/up.txt
downfile=$dir/down.txt
totalip=`awk 'END{print NR}' $ipfile`
   
if [ -f $upfile -o -f $downfile ]
then
    echo "准备工作: 历史统计文件存在，正在删除..."
    rm -rf $upfile $downfile
    echo "准备工作: 历史统计文件(up/down)已删除。"
else
    echo "准备工作: 历史统计文件(up/down)不存在，无需删除。"
fi


for ip in `cat $ipfile`
do
  {
  ping -c 1 $ip > /dev/null 2>&1 
  if [ $? -eq 0 ]; then    
      echo "$ip" >> $upfile
  else
      echo "$ip" >> $downfile
  fi
  }&
done
wait

if [ -f $upfile -a -f $downfile ]
then
    echo  "统计: 本次统计ip $totalip个 up个数为`awk 'END{print NR}' $upfile`, down个数为`awk 'END{print NR}' $downfile` 具体ip分别统计到$upfile 和$downfile文件中"
elif [ -f  $upfile ]
then
   echo  "统计: 本次统计ip $totalip个 up个数为`awk 'END{print NR}' $upfile`, down个数为 0个 具体ip分别统计到$upfile 和$downfile文件中"
elif [ -f $downfile ]
then   
   echo  "统计: 本次统计ip $totalip个 up个数为 0个, down个数为 `awk 'END{print NR}' $downfile`个 具体ip分别统计到$upfile 和$downfile文件中"
fi




