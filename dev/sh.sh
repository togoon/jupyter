#! /bin/sh

# ESB=D:/summit
ESB=D:/interface/tibco
MktRate=${ESB}/MktRate
Zerocurvedir=${ESB}/ZeroCurve

# until [ ! -z ${DBPASS} ]
# do
	# echo
	# echo Enter ${SUMITDBNAME} Password
	# read -S DBPASS
#  done

# sqlplus -s ${SUMMITDBNAME})/${DBPASS}@${ORACLE_SID} << _CHECK_ 2>&1 | 
# select count(*) from dual;
# exit
# _CHECK_
	# grep ORA-
	# if [ $? -eq 0 ]
	# then
		# echo
		# echo $0: sqlplus error. Can not access server ${ORACLE_SID}.
		# echo
		# exit 1
	# fi

# echo
# asofHO=`${ORACLE_HOME}/BIN/sqlplus -s "${SUMMITDBNAME}/${DBPASS}@${ORACLE_SID}" <<EOF
# set SOLP ""
# set SOLN off;
# set echo off;
# set heading off;
# set feedback off;
# set echo off;
# set termout off;
# set show off;
# set ver off; 
# set time off;
# set autot off;
# select today from dmLOCATION where Audit_Current='y' and locationname='CDBHO';
# exit;
# EOF`

# asof=`echo ${asof} | cut -b 3-10`
# asofHO=${asofHO:1:8}
# asof=${asofHo}

# asofETZ=${asofEIZ:1:8}

${ORACLE_HOME}/BIN/sqlplus /nolog <<EOF
set SOLP ""
set SOLN off;
set echo off;
set heading off;
set feedback off;
set echo off;
set termout off;
set show off;
set ver off; 
set time off;
set autot off;

conn ${SUMMITDBNAME}/${DBPASS}@${ORACLE_SID};

delete from dmrefrate where ( ccy = 'USD' and dmindex = 'SOFR' and term like '%lD%' ) and asofdate >= ${startDate} and asofdate <= ${endDate} ;
insert into dmrefrate select source, ccy, 'SOFR', term, asofdate, rate from dmrefrate where ( ccy = 'USD' and dmindex = 'LIBBOR' and term like '%1D%' ) and asofdate >= $(startDate) and asofdate <= $(endDate) order by asofdate ;

Insert into dmrefrate (SOURCE,CCY,DMINDEX,TERM,ASOFDATE,RATE) value ('REUTERS','CHF','SARON','  1D','20051230',0.78);

commit;
EOF

asofHO=`gendate -LOC CDBHO | sed -n "3,3p" | awk '{print $2}'`
asof=${asofHO}
asofHK=`gendate -LOC CDB_HK | sed -n "3,3p" | awk '{print $2}'`
asofFTZ=`gendate -LOC SHFTZ | sed -n "3,3p" | awk '{print $2}'`

asofH0=20210517
asofHK=20210517
asofFTZ=20210517
echo -asof-${asof}--asofHO-${agfHO}--asofHK-${agofHK}--asofFTZ-${agofFTZ}------------

echo on
[ ! -d ${MktRate}/ ] && mkdir -p ${MktRate}
mktpub=${MktRate}/pub
[ ! -d ${mktpub}/ ] && mkdir -p ${mktpub}
mktpubdir=${MktRate}/output
[ ! -d ${mktpubdir}/ ] && mkdir -p ${mktpubdir}
mktsub=${MktRate}/sub
[ ! -d ${mktsub}/ ] && mkdir -p ${mktsub}
mktindir=${MktRate}/input
[ ! -d ${mktindir}/ ] && mkdir -p ${mktindir}

zerologfile=${zerologdir}/ZeroCurveExport_`date +'%Y%m'`.log

impRateData(){
	date_time=`date +'%Y%m%d_%H%M%S'`
	echoLog "- Start impRateData static_import `date +'%Y%m%d %H:%M67:%S'` " ${mktlogfile}

	cpcur=0
	for file in `ls -A $1` ; do
		fixary=(${file//_/ })
		filetypeary=(${file//./ })
		filetype=${filetykpeary[${#filetkypeary[@]}-1]}
		filename=${filetypeary[0]}

		pathfile=$1/${file}

		if [ -s ${pathfile} ] ; then #COMMESET MKTDATA 
			if [ "${filetype,,}" = "xml" ] ; then

				if [ `grep -c "</ENTITYLIST>" ${pathfile} ` -eq 0 ] ; then
					echoErrlog "- End Error xml file incomplete Failed : `date +'%Y%m%d %H:%M:%S'` : ${file} " ${mktlogfile}	
					mv -f ${pathfile} ${mkterrdir}/${file}
					continue
				fi

				echoLog "--`date +'%Y%m%d %H:%M:%S'` --static_import -I ${pathfile} -XML -COMMIT -NEWACT IMLIVE -UKPDAT IMPEDT-- " ${mktlogfile}
				static_import -I ${pathfile} -XML -COMMIT -NEWACT IMLIVE -UKPDAT IMPEDT >>${mktlogfile} 2>&1
				ret=$?

				if [ "${fixary[0]}" = "INTRATE" -o "${fixary[0]}" = "ISDAFLBK" ] ; then
					let zeroHo=0
				fi

				if [ "${fixary[0]}" = "MKTDATA" -a "${ret}" = "0" ] ; then
					let zeroHo=1
					let cpcur=1
				fi				
			
			elif [ "${filetype,,}" = "txt" ] ; then
				echoLog "--`date +'%Y%m%d %H:%M:%S'` --# mktimp -I ${pathfile}-- " ${mktlogfile}

				if [ "${fixary[0]}" = "MKTDATA" -o "${fixary[0]}" = "COMMSET" ] ; then
					mktimp -I ${pathfile} -REPLACE >>${mktlogfile} 2>&1
					ret=$?
					echoLog "--`date +'%Y%m%d %H:%M:%S'` --# mktimp INDEX:`grep -ci INDEX ${pathfile}`" ${mktlogfile}
				fi

				if [ "${fixary[0]}" = "MKTDATA" -a "${ret}" = "0" ] ; then
					let cpcur=1
					if [[ `echo $1 | grep -i ho` != "" ]] ; then 
						let zeroHo=1 
					# elif [[ `echo $1 | grep -i ftus` != "" ]] ; then 
						# let zeroFtus=1 
					# elif [[ `echo $1 | grep -i hk` != "" ]] ; then 
						# let zeroHk=1 
					fi
				fi	
			fi

			backupfile=${file}

			for i in "ho" "hk" "ftus" ; do
				if [[ `echo $1 | grep -i $i` != "" ]] ; then
					backupfile=${filename}_$1.${filetype}
					if [ ${filetype} = xml ] && [ ${fixary[0]} = REFRATE -o ${fixary[0]} = INTRATE -o ${fixary[0]} = ISDAFLBK ] ; then
						backupfile=${fixary[0]}_${date_time}_$1.${filetype}
					elif [ ${filetype} = txt ] && [ ${fixary[0]} = LIBOR -o ${fixary[0]} = IR ] ; then
						backupfile=${fixary[0]}_${date_time}_$1.${filetype}
					fi
				fi
			done

			if [[ ${ret} -eq 0 ]] ; then
				echoLog "- End import Success : `date +'%Y%m%d %H:%M:%S'` with Return Code ${ret} : ${file}" ${mktlogfile}
				mv -f ${pathfile} ${mktbackupdir}/${backupfile}
			else
				echoErrLog "- End Error import Failed : `date +'%Y%m%d %H:%M:%S'` with Return Code ${ret} : ${file}" ${mktlogfile}
				mv -f ${pathfile} ${mkterrdir}/${backupfile}

			fi
		fi
	done

	if [[ ${cpcur} == 1 ]] ; then
		echoLog "--`date +'%Y%m%d %H:%M:%S'` -- cpcurves -TYPE MKT -X 0D -Y 0D ---SKIPI EONIA-- " ${mktlogfile}
		cpcurves -TYPE MKT -X 0D -Y 0D >>${mktlogfile} 2>&1 

		if [[ `echo $1 | grep -i ho` != "" ]] ; then

			echoLog "--`date +'%Y%m%d %H:%M:%S'` -- cpcurves -TYPE MKT -X 0D -Y 0D -CCY CNY -INDEX REPO -CVID RERHO -TOID RFRHK -- " ${mktlogfile}
			cpcurves -TYPE MKT -X 0D -Y 0D -CCY CNY -INDEX REPO -CVID RERHO -TOID RFRHK >>${mktlogfile} 2>&1 
		fi
	fi

}

ExportCurve (){
	echoLog "- Start ExportCurve `date +'%Y%m%d %H:%M:%S'` " ${zerologfile}
	if [[ ${zeroHo} == 1 ]] ; then
		asofHO=`gendate -LOC CDBHO I sed -n '3,3p' | awk '{print S2}'`
		asof=${asofHO}

		echolog "--`date +'%Y%m%d %H:%M:%S'` --ExportZeroCurve -d "${asofHo}" -o  "${zerooutdir}" -COM 'RERHO'-- " ${zerologfile} 
		ExportZeroCurve -d "${asofHo}" -o  "${zerooutdir}" -COM "RERHO" >>${zerologfile} 2>&1 
		ret=$?
		echolog "--`date +'%Y%m%d %H:%M:%S'`--ExportZeroCurve INDEX: `grep -ci INDEX ${zerooutdir}/RERHO.dat ` (MASTER: `grep -ci MASTER ${zerooutdir}/RERHO.dat` )"  ${zerologfile}

	elif [[ ${zeroFtus} == 1 ]] ; then
		asofFTZ=`gendate -LOC SHFTZ I sed -n '3,3p' | awk '{print S2}'`

		echolog "--`date +'%Y%m%d %H:%M:%S'` --ExportZeroCurve -d "${asofFTZ}" -o  "${zerooutdir}" -COM 'RERFTZ'-- " ${zerologfile} 
		ExportZeroCurve -d "${asofFTZ}" -o  "${zerooutdir}" -COM "RERFTZ" >>${zerologfile} 2>&1 
		ret=$?
		echolog "--`date +'%Y%m%d %H:%M:%S'`--ExportZeroCurve INDEX: `grep -ci INDEX ${zerooutdir}/RERFTZ.dat ` (MASTER: `grep -ci MASTER ${zerooutdir}/RERFTZ.dat` )"  ${zerologfile}

	elif [[ ${zeroHk} == 1 ]] ; then

		asofHK=`gendate -LOC CDB_HK I sed -n '3,3p' | awk '{print S2}'`

		echolog "--`date +'%Y%m%d %H:%M:%S'` --ExportZeroCurve -d "${asofHK}" -o  "${zerooutdir}" -COM 'RERHK'-- " ${zerologfile} 
		ExportZeroCurve -d "${asofHK}" -o  "${zerooutdir}" -COM "RERHK" >>${zerologfile} 2>&1 
		ret=$?
		echolog "--`date +'%Y%m%d %H:%M:%S'`--ExportZeroCurve INDEX: `grep -ci INDEX ${zerooutdir}/RERHK.dat ` (MASTER: `grep -ci MASTER ${zerooutdir}/RERHK.dat`, EODREVAL: `grep -ci EODREVAL ${zerooutdir}/RERHK.dat`, EODRISK: `grep -ci EODRISK ${zerooutdir}/RERHK.dat`  )"  ${zerologfile}

	fi

	date_time=`date +'%Y%m%d_%H%M%S'`

	if [[ ${ret} -eq 0 ]] ; then
		for file in `ls -A ${zerooutdir}` ; do
			pathfile=${zerooutdir}/${file}
			fixary=(${file//_/ })
			filetypeary=(${file//./ })
			filename=${filetypeary[0]}
			filetype=${filetypeary[${#filetypeary[@]}-1]}

			if [ "${filename}" = "RERHO" ] ; then
				cp -f ${pathfilel} ${zerohooutputdir}/${file}
				mv -f ${pathfile} ${zerobackupdir}/RFRHO_${date_time}.${filetype}
			elif [ "${filename}" = "RERHK" ] ; then
				cp -f ${pathfilel} ${zerohkoutputdir}/${file}
				mv -f ${pathfile} ${zerobackupdir}/RFRHK_${date_time}.${filetype}
			elif [ "${filename}" = "RERFTZ" ] ; then
				cp -f ${pathfilel} ${zeroftusoutputdir}/${file}
				mv -f ${pathfile} ${zerobackupdir}/RFRFTZ_${date_time}.${filetype}
			fi
		done
	else
		echoErrlog "- Error ExportZeroCurve Faild : `date +'%Y%m%d %H:%M:%S'` with Return Code ${ret} " ${zerologfile}
	fi

}

mktExpTXT(){
	asof=`gentoday -LOC CDBHO | sed -n '1,1p' | awk '(print $2)'`

	#20210517 05/17/2021
	xDate=${asof:4:2}/${asof:6:2}/${asof:0:4}
	yDate=${xDate}
	mktdataOutfile=MKTDATA_${asof}_`date +'%H%M%S'`.txt
	mktOutPathFile=${mktpubdir}/${mktdataOutfile}

	echolog "- Start -`date +'%Y%m%d %H:%M:%S'` -mktexp -X ${xDate} -Y ${yDate} -F  ${CLIENTPATH}/etc/mktexp.ini -O ${mktutPathfile}-- " ${mktlogfile}
	
	mktexp -X ${xDate} -Y ${yDate} -F  ${CLIENTPATH}/etc/mktexp.ini -O ${mktutPathfile} >>${mktlogfile} 2>&1
	# mktexp -X 05/17/2021 -Y 05/17/2021 -F ${CLIENTPATH}/etc/mktexp.ini -O ${mktutPathfile} >>${mktlogfile} 2>&1

	ret=$?
	if [ ${ret} -eq 0 ] ; then
		fileSize=`ls -l $(mktoutpathFile) | awk '(print $5)'`
		if [ -s ${mktOutPathFile} ] && (( ${filesize} > 200 )) ; then
			echolog "--`date +'%Y%m%d %H:%M:%S'`--mktexp INDEX: `grep -ci INDEX ${mktOutPathFile}` (RER: `grep -ci RER ${mktOutPathFile}`, MASTER: `grep -ci MASTER ${mktOutPathFile}` ) " $(mktlogfile)
			sed-i 's/RFR/RFRHO/g' ${mktOutPathFile}
			sed -i 's/MASTER/RFRHO/g' ${mktOutPathFile}
			mv -f ${mktOutPathFile} ${mktoutputdir}/${mktdataOutfile}
			echolog "- End mktexp KTDATA Success : `date +'%Y%m%d %H:%M:%S'` with Return Code ${ret} : ${mktdataOutfile}" ${mktlogfile}
		else
			if [ -f ${mktOutPathFile} ] ; then
				mv -f ${mktOutPathFile} ${mkterrdir}/${mktdataOutfile}
				echoLog "- End mktexp MKTDATA Empty : mktdataOutfile-filesize-${filesize}-"  ${mktlogfile}
			fi
		fi
	else
		echoErrlog "- End Error mktexp MKIDATA Failed : `date +'%Y%m%d %H:%M:%S'` with Return Code ${ret}"  ${mktlogfile}
	fi
}

echoLog(){
	echo $1 
	echo $1 >> $2
}

echoErrlog(){
	echo -e "\033[47;31m " $1 "\033[0m"
	echo $1 >>$2
}

run_command(){
	echoLog "- Start -`date +'%Y%m%d %H:%M:%S'` --$1--" $2
	$1 $3
	echoLog "- End - `date +'%Y%m%d %H:%M:%S'` --$l--" $2
}

run_cmd(){

	command=$*
	echo - Start -`date +'%Y%m%d %H:%M:%S'` >> ${mktlogfile}
	echo --- ${command} --- >> ${mktlogfile}
	echo >> ${mktlogfile}

	${command} >>${mktlogfile} 2>&1
	ret=$?

	if [ $? -eq 0 ] 
	then
		echo - End $1 Success : `date +'%Y%m%d %H:%M:%S'` with Return Code ${ret}>> ${mktlogfile}
	else
		echo - End $1 Failed : `date +'%Y%m%d %H:%M:%S'` with Return Code ${ret}>> ${mktlogfile}
	fi
}

echoLog "- Start -`date +'%Y%m%d %H:%M:%S'` --- ImportMktRateRFR ExportZeroCurve...${asof}... please wait-- " ${mktlogfile}

i=0
preHourl=0
preHour2=0
preHour3=0
preHour4=0
preHour5=0
preHour6=0
preminutel=0
preminute4=0
run5to6=1
zeroHo=0
zeroFtus=0
zeroHk=0
RicExtDone=0
preDate1=0	

while [ true ]
do
	datestr=`date +'%Y%m%d'`
	timestr=`date +'%H%M%S'`
	app_time=`date +'%H:%M:%S'`
	app_hour=`echo ${app_time} | cut -b 1-2`
	app_minute=`echo ${app_time} | cut -b 4-5`
	app_sec=`echo ${app_time} | cut -b 7-8`

	app_hourmin=${app_hour}${app_minute}
	app_hourmin=$(( 10#${app_hourmin} ))
	app_hour=$(( 10#${app_hour} ))
	app_minute=$(( 10#${app_minute} ))
	app_sec=$(( 10#${app_sec} ))

	app_date=`date +'%Y%m%d'`
	app_date=$(( 10#${app_date} ))
	
	if [ ${preDatel} -lt ${app_date} ]
	then
		let preDatel=${app_date}

		let i=0
		let preHourl=0
		let preHour2=0
		let preHour3=0
		let preHour4=0
		let preminutel=0
		let preminute4=0
		let RicExtDone=0
		let preDate1=0		
	fi

	# 8:35-8:39 , 19:10 Import ; 18:00 , 18:40 Trangfer ; Saveas (IRS->56 56->62)
	# if [ ${preHour2} -lt ${app_hour} -a ${app_hour} -eq 8 -a ${app_minute} -ge 40 ] || [ ${preour2} -lt ${app_hour} -a ${app_hour} -eq 18 -a ${app_minute} -ge 41 ] || [ ${preHour2} -lt ${app_hour} -a ${app_hour} -eq 19 -a ${app_minute} -ge 11 ]
	# then
		# preHour2 $(app hour)
		# run_command saveMktRates ${mktlogfile}
	# fi

	if [ "$(ls -A ${zeroinputdir} )" ] ; then
		sleep 5
		run_command impZeroCurveMd5 ${zerologfile}
	fi

	#import 10:00-17:00 (RMDS IRS ->56)
	# if [ ${preHour3} -lt ${app_hour} ] && [ ${app_hour} -ge 10 -a ${app_hour} -le 17 ]
	# then
		# preHour3=${app_hour}
		# run_command impRatedata ${mktlogfile}
	# fi

	#10:00~17:00 1h export Mkt (56->62)
	if [ ${prehourl} -lt ${app_hour} ] && [ ${app_hour} -ge 10 -a ${app_hour} -le 17 ] && [  ${app_minute} -ge l ] ; then
		preHourl=s(app hour}${app_hour}
		preminutel=${app_minute}
		# run_command expMktData ${mktlogfile}
		run_command mktExpTXT ${mktlogfile}
		run_command expCommset ${mktlogfile}
	fi

	#9:00~18:00 1h import Mkt impzeroCurve (62->56)
	# if [ ${preHour4} -lt ${app_hour} ] && [ ${app_hour} -ge 9 -a ${app_hour} -le 18 ] && (( ${app_minute} - ${preminutel} >= 2 )) ; then
		# preHour4=${app_hour}
		# preminute4=${app_minute}
		# run_command impZeroCurveMd5 ${zerologfile}
		# #impZeroCurve ${zeroinputdir}
	# fi

	#18:00 IRRicExportExt (56->IRS) IRRICEXT_20210517.csv (08:30 13:30 16:00 19:00 IRRICCODE_20180507.csv )
	if [ ${app_hour} -ge 18 -a ${app_minute} -ge 00 ] && (( ${RicExtDone} <= 5 )) ; then
		run_command expIRRicExt ${IRRiclogfile}
	elif [[ ${app_hour} -lt 18 ]] ; then
		let RicExtDone=0
	fi

	# if (( ${i} <= -2 )) ; then
		# echo m_ Start -~date +'gYemed 号H:M:S-test-expIRRicExt- m
		# run command imperoCurveMd5 run command expIRRicExt S(IRRicloqfilel
		# echo "_ End -~date +'gYemed H:M:S-test-expIRRicExt-- u
	# fi

	# if (( ${i} >= -200000 )) ; then break ; fi # test run once 86400 app_hourmin

	for indir in "mkthoindir" "mktftusindirn" "mkthkindir" ; do
		if [[ ${run5to6} == 0 ]] ;then
			let zeroHo=0
			let zeroFtus=0
			let zeroHk=0
		fi
	
		eval mkindir=$(echo '$'"$indir")
	
		if [ "$(ls -A ${mkindir} ) " ] ; then
			if [ "${indir}" = "mkthoindir" ] ; then
				let zeroHo=1
			elif [ "${indir}" = "mktftusindir" ] ; then
				let zeroFtus=1
			elif [ "${indir}" = "mkthkindir" ] ; then
				let zeroHk=1
			file
			run_command impRateData ${mktlogfile}  ${mkindir}
			let run5to6=1
			sleep 1
		fi
	done

	#/5s ExportCurve(62->56)
	if [[ ${run5to6} == 1 ]] ; then
		run_command ExportCurve $(zerologfile)
		let run5to6=0
	fi

	if [ ${app_hourmin} -ge 1920 ] ; then # 19:20 break/exit
		echo - Exit: ${datestr} ${app_time} >> ${mktlogfile}
		echo >> ${mktlogfile} 
		break
	fi
	let i+=1
	sleep 5
done
exit 0

#----常用命令--------------------------

系统信息显示命令
arch 显示机器的处理器架构(1) 
uname -m 显示机器的处理器架构(2) 
uname -r 显示正在使用的内核版本 
dmidecode -q 显示硬件系统部件 - (SMBIOS / DMI) 
hdparm -i /dev/hda 罗列一个磁盘的架构特性 
hdparm -tT /dev/sda 在磁盘上执行测试性读取操作 
cat /proc/cpuinfo 显示CPU info的信息 
cat /proc/interrupts 显示中断 
cat /proc/meminfo 校验内存使用 
cat /proc/swaps 显示哪些swap被使用 
cat /proc/version 显示内核的版本 
cat /proc/net/dev 显示网络适配器及统计 
cat /proc/mounts 显示已加载的文件系统 
lspci -tv 罗列 PCI 设备 
lsusb -tv 显示 USB 设备 
date 显示系统日期 
cal 2007 显示2007年的日历表 
date 041217002007.00 设置日期和时间 - 月日时分年.秒 
clock -w 将时间修改保存到 BIOS 

关机命令
(系统的关机, 重启以及登出 ) 
shutdown -h now 关闭系统(1) 
init 0 关闭系统(2) 
telinit 0 关闭系统(3) 
shutdown -h hours:minutes & 按预定时间关闭系统 
shutdown -c 取消按预定时间关闭系统 
shutdown -r now 重启(1) 
reboot 重启(2) 
logout 注销 

文件和目录命令 
cd /home 进入 '/ home' 目录
cd .. 返回上一级目录 
cd ../.. 返回上两级目录 
cd 进入个人的主目录 
cd ~user1 进入个人的主目录 
cd - 返回上次所在的目录 
pwd 显示工作路径 
ls 查看目录中的文件 
ls -F 查看目录中的文件 
ls -l 显示文件和目录的详细资料 
ls -a 显示隐藏文件 
ls *[0-9]* 显示包含数字的文件名和目录名 
tree 显示文件和目录由根目录开始的树形结构(1) 
lstree 显示文件和目录由根目录开始的树形结构(2) 
mkdir dir1 创建一个叫做 'dir1' 的目录
mkdir dir1 dir2 同时创建两个目录 
mkdir -p /tmp/dir1/dir2 创建一个目录树 
rm -f file1 删除一个叫做 'file1' 的文件 
rmdir dir1 删除一个叫做 'dir1' 的目录
rm -rf dir1 删除一个叫做 'dir1' 的目录并同时删除其内容 
rm -rf dir1 dir2 同时删除两个目录及它们的内容 
mv dir1 new_dir 重命名/移动 一个目录 
cp file1 file2 复制一个文件 
cp dir/* . 复制一个目录下的所有文件到当前工作目录 
cp -a /tmp/dir1 . 复制一个目录到当前工作目录 
cp -a dir1 dir2 复制一个目录 
ln -s file1 lnk1 创建一个指向文件或目录的软链接 
ln file1 lnk1 创建一个指向文件或目录的物理链接 
touch -t 0712250000 file1 修改一个文件或目录的时间戳 - (YYMMDDhhmm) 
file file1 outputs the mime type of the file as text 
iconv -l 列出已知的编码 
iconv -f fromEncoding -t toEncoding inputFile > outputFile creates a new from the given input file by assuming it is encoded in fromEncoding and converting it to toEncoding. 
find . -maxdepth 1 -name *.jpg -print -exec convert "{}" -resize 80x60 "thumbs/{}" \; batch resize files in the current directory and send them to a thumbnails directory (requires convert from Imagemagick) 

文件搜索命令
find / -name file1 从 '/' 开始进入根文件系统搜索文件和目录 
find / -user user1 搜索属于用户 'user1' 的文件和目录 
find /home/user1 -name \*.bin 在目录 '/ home/user1' 中搜索带有'.bin' 结尾的文件 
find /usr/bin -type f -atime +100 搜索在过去100天内未被使用过的执行文件 
find /usr/bin -type f -mtime -10 搜索在10天内被创建或者修改过的文件 
find / -name \*.rpm -exec chmod 755 '{}' \; 搜索以 '.rpm' 结尾的文件并定义其权限 
find / -xdev -name \*.rpm 搜索以 '.rpm' 结尾的文件, 忽略光驱, 捷盘等可移动设备 
locate \*.ps 寻找以 '.ps' 结尾的文件 - 先运行 'updatedb' 命令 
whereis halt 显示一个二进制文件, 源码或man的位置 
which halt 显示一个二进制文件或可执行文件的完整路径 

挂载一个文件系统命令
mount /dev/hda2 /mnt/hda2 挂载一个叫做hda2的盘 - 确定目录 '/ mnt/hda2' 已经存在 
umount /dev/hda2 卸载一个叫做hda2的盘 - 先从挂载点 '/ mnt/hda2' 退出 
fuser -km /mnt/hda2 当设备繁忙时强制卸载 
umount -n /mnt/hda2 运行卸载操作而不写入 /etc/mtab 文件- 当文件为只读或当磁盘写满时非常有用 
mount /dev/fd0 /mnt/floppy 挂载一个软盘 
mount /dev/cdrom /mnt/cdrom 挂载一个cdrom或dvdrom 
mount /dev/hdc /mnt/cdrecorder 挂载一个cdrw或dvdrom 
mount /dev/hdb /mnt/cdrecorder 挂载一个cdrw或dvdrom 
mount -o loop file.iso /mnt/cdrom 挂载一个文件或ISO镜像文件 
mount -t vfat /dev/hda5 /mnt/hda5 挂载一个Windows FAT32文件系统 
mount /dev/sda1 /mnt/usbdisk 挂载一个usb 捷盘或闪存设备 
mount -t smbfs -o username=user,password=pass //WinClient/share /mnt/share 挂载一个windows网络共享 

磁盘空间命令 
df -h 显示已经挂载的分区列表 
ls -lSr |more 以尺寸大小排列文件和目录 
du -sh dir1 估算目录 'dir1' 已经使用的磁盘空间
du -sk * | sort -rn 以容量大小为依据依次显示文件和目录的大小 
rpm -q -a --qf '%10{SIZE}t%{NAME}n' | sort -k1,1n 以大小为依据依次显示已安装的rpm包所使用的空间 (Fedora, RedHat类系统) 
dpkg-query -W -f='${Installed-Size;10}t${Package}n' | sort -k1,1n 以大小为依据显示已安装的deb包所使用的空间 (Ubuntu, debian类系统) 

用户和群组命令 
groupadd group_name 创建一个新用户组 
groupdel group_name 删除一个用户组 
groupmod -n new_group_name old_group_name 重命名一个用户组 
useradd -c "Name Surname " -g admin -d /home/user1 -s /bin/bash user1 创建一个属于 "admin" 用户组的用户 
useradd user1 创建一个新用户 
userdel -r user1 删除一个用户 ( '-r' 排除主目录) 
usermod -c "User FTP" -g system -d /ftp/user1 -s /bin/nologin user1 修改用户属性 
passwd 修改口令 
passwd user1 修改一个用户的口令 (只允许root执行) 
chage -E 2005-12-31 user1 设置用户口令的失效期限 
pwck 检查 '/etc/passwd' 的文件格式和语法修正以及存在的用户 
grpck 检查 '/etc/passwd' 的文件格式和语法修正以及存在的群组 
newgrp group_name 登陆进一个新的群组以改变新创建文件的预设群组 

文件的权限命令

使用 "+" 设置权限, 使用 "-" 用于取消 
ls -lh 显示权限 
ls /tmp | pr -T5 -W$COLUMNS 将终端划分成5栏显示 
chmod ugo+rwx directory1 设置目录的所有人(u), 群组(g)以及其他人(o)以读(r ), 写(w)和执行(x)的权限 
chmod go-rwx directory1 删除群组(g)与其他人(o)对目录的读写执行权限 
chown user1 file1 改变一个文件的所有人属性 
chown -R user1 directory1 改变一个目录的所有人属性并同时改变改目录下所有文件的属性 
chgrp group1 file1 改变文件的群组 
chown user1:group1 file1 改变一个文件的所有人和群组属性 
find / -perm -u+s 罗列一个系统中所有使用了SUID控制的文件 
chmod u+s /bin/file1 设置一个二进制文件的 SUID 位 - 运行该文件的用户也被赋予和所有者同样的权限 
chmod u-s /bin/file1 禁用一个二进制文件的 SUID位 
chmod g+s /home/public 设置一个目录的SGID 位 - 类似SUID , 不过这是针对目录的 
chmod g-s /home/public 禁用一个目录的 SGID 位 
chmod o+t /home/public 设置一个文件的 STIKY 位 - 只允许合法所有人删除文件 
chmod o-t /home/public 禁用一个目录的 STIKY 位 

文件的特殊属性命令
使用 "+" 设置权限, 使用 "-" 用于取消 
chattr +a file1 只允许以追加方式读写文件 
chattr +c file1 允许这个文件能被内核自动压缩/解压 
chattr +d file1 在进行文件系统备份时, dump程序将忽略这个文件 
chattr +i file1 设置成不可变的文件, 不能被删除, 修改, 重命名或者链接 
chattr +s file1 允许一个文件被安全地删除 
chattr +S file1 一旦应用程序对这个文件执行了写操作, 使系统立刻把修改的结果写到磁盘 
chattr +u file1 若文件被删除, 系统会允许你在以后恢复这个被删除的文件 
lsattr 显示特殊的属性 

打包和压缩文件命令 
bunzip2 file1.bz2 解压一个叫做 'file1.bz2'的文件 
bzip2 file1 压缩一个叫做 'file1' 的文件 
gunzip file1.gz 解压一个叫做 'file1.gz'的文件 
gzip file1 压缩一个叫做 'file1'的文件 
gzip -9 file1 最大程度压缩 
rar a file1.rar test_file 创建一个叫做 'file1.rar' 的包 
rar a file1.rar file1 file2 dir1 同时压缩 'file1', 'file2' 以及目录 'dir1' 
rar x file1.rar 解压rar包 
unrar x file1.rar 解压rar包 
tar -cvf archive.tar file1 创建一个非压缩的 tarball 
tar -cvf archive.tar file1 file2 dir1 创建一个包含了 'file1', 'file2' 以及 'dir1'的档案文件 
tar -tf archive.tar 显示一个包中的内容 
tar -xvf archive.tar 释放一个包 
tar -xvf archive.tar -C /tmp 将压缩包释放到 /tmp目录下 
tar -cvfj archive.tar.bz2 dir1 创建一个bzip2格式的压缩包 
tar -xvfj archive.tar.bz2 解压一个bzip2格式的压缩包 
tar -cvfz archive.tar.gz dir1 创建一个gzip格式的压缩包 
tar -xvfz archive.tar.gz 解压一个gzip格式的压缩包 
zip file1.zip file1 创建一个zip格式的压缩包 
zip -r file1.zip file1 file2 dir1 将几个文件和目录同时压缩成一个zip格式的压缩包 
unzip file1.zip 解压一个zip格式压缩包 

RPM 包
(Fedora, Redhat及类似系统) 
rpm -ivh package.rpm 安装一个rpm包 
rpm -ivh --nodeeps package.rpm 安装一个rpm包而忽略依赖关系警告 
rpm -U package.rpm 更新一个rpm包但不改变其配置文件 
rpm -F package.rpm 更新一个确定已经安装的rpm包 
rpm -e package_name.rpm 删除一个rpm包 
rpm -qa 显示系统中所有已经安装的rpm包 
rpm -qa | grep httpd 显示所有名称中包含 "httpd" 字样的rpm包 
rpm -qi package_name 获取一个已安装包的特殊信息 
rpm -qg "System Environment/Daemons" 显示一个组件的rpm包 
rpm -ql package_name 显示一个已经安装的rpm包提供的文件列表 
rpm -qc package_name 显示一个已经安装的rpm包提供的配置文件列表 
rpm -q package_name --whatrequires 显示与一个rpm包存在依赖关系的列表 
rpm -q package_name --whatprovides 显示一个rpm包所占的体积 
rpm -q package_name --scripts 显示在安装/删除期间所执行的脚本l 
rpm -q package_name --changelog 显示一个rpm包的修改历史 
rpm -qf /etc/httpd/conf/httpd.conf 确认所给的文件由哪个rpm包所提供 
rpm -qp package.rpm -l 显示由一个尚未安装的rpm包提供的文件列表 
rpm --import /media/cdrom/RPM-GPG-KEY 导入公钥数字证书 
rpm --checksig package.rpm 确认一个rpm包的完整性 
rpm -qa gpg-pubkey 确认已安装的所有rpm包的完整性 
rpm -V package_name 检查文件尺寸,  许可, 类型, 所有者, 群组, MD5检查以及最后修改时间 
rpm -Va 检查系统中所有已安装的rpm包- 小心使用 
rpm -Vp package.rpm 确认一个rpm包还未安装 
rpm2cpio package.rpm | cpio --extract --make-directories *bin* 从一个rpm包运行可执行文件 
rpm -ivh /usr/src/redhat/RPMS/`arch`/package.rpm 从一个rpm源码安装一个构建好的包 
rpmbuild --rebuild package_name.src.rpm 从一个rpm源码构建一个 rpm 包 

YUM 软件包升级器
(Fedora, RedHat及类似系统) 
yum install package_name 下载并安装一个rpm包 
yum localinstall package_name.rpm 将安装一个rpm包, 使用你自己的软件仓库为你解决所有依赖关系 
yum update package_name.rpm 更新当前系统中所有安装的rpm包 
yum update package_name 更新一个rpm包 
yum remove package_name 删除一个rpm包 
yum list 列出当前系统中安装的所有包 
yum search package_name 在rpm仓库中搜寻软件包 
yum clean packages 清理rpm缓存删除下载的包 
yum clean headers 删除所有头文件 
yum clean all 删除所有缓存的包和头文件 

DEB 包
(Debian, Ubuntu 以及类似系统) 
dpkg -i package.deb 安装/更新一个 deb 包 
dpkg -r package_name 从系统删除一个 deb 包 
dpkg -l 显示系统中所有已经安装的 deb 包 
dpkg -l | grep httpd 显示所有名称中包含 "httpd" 字样的deb包 
dpkg -s package_name 获得已经安装在系统中一个特殊包的信息 
dpkg -L package_name 显示系统中已经安装的一个deb包所提供的文件列表 
dpkg --contents package.deb 显示尚未安装的一个包所提供的文件列表 
dpkg -S /bin/ping 确认所给的文件由哪个deb包提供 

APT 软件工具
(Debian, Ubuntu 以及类似系统) 
apt-get install package_name 安装/更新一个 deb 包 
apt-cdrom install package_name 从光盘安装/更新一个 deb 包 
apt-get update 升级列表中的软件包 
apt-get upgrade 升级所有已安装的软件 
apt-get remove package_name 从系统删除一个deb包 
apt-get check 确认依赖的软件仓库正确 
apt-get clean 从下载的软件包中清理缓存 
apt-cache search searched-package 返回包含所要搜索字符串的软件包名称 

查看文件内容 
cat file1 从第一个字节开始正向查看文件的内容 
tac file1 从最后一行开始反向查看一个文件的内容 
more file1 查看一个长文件的内容 
less file1 类似于 'more' 命令, 但是它允许在文件中和正向操作一样的反向操作 
head -2 file1 查看一个文件的前两行 
tail -2 file1 查看一个文件的最后两行 
tail -f /var/log/messages 实时查看被添加到一个文件中的内容 

文本处理命令
cat file1 file2 ... | command <> file1_in.txt_or_file1_out.txt general syntax for text manipulation using PIPE, STDIN and STDOUT 
cat file1 | command( sed, grep, awk, grep, etc...) > result.txt 合并一个文件的详细说明文本, 并将简介写入一个新文件中 
cat file1 | command( sed, grep, awk, grep, etc...) >> result.txt 合并一个文件的详细说明文本, 并将简介写入一个已有的文件中 
grep Aug /var/log/messages 在文件 '/var/log/messages'中查找关键词"Aug" 
grep ^Aug /var/log/messages 在文件 '/var/log/messages'中查找以"Aug"开始的词汇 
grep [0-9] /var/log/messages 选择 '/var/log/messages' 文件中所有包含数字的行 
grep Aug -R /var/log/* 在目录 '/var/log' 及随后的目录中搜索字符串"Aug" 
sed 's/stringa1/stringa2/g' example.txt 将example.txt文件中的 "string1" 替换成 "string2" 
sed '/^$/d' example.txt 从example.txt文件中删除所有空白行 
sed '/ *#/d; /^$/d' example.txt 从example.txt文件中删除所有注释和空白行 
echo 'esempio' | tr '[:lower:]' '[:upper:]' 合并上下单元格内容 
sed -e '1d' result.txt 从文件example.txt 中排除第一行 
sed -n '/stringa1/p' 查看只包含词汇 "string1"的行 
sed -e 's/ *$//' example.txt 删除每一行最后的空白字符 
sed -e 's/stringa1//g' example.txt 从文档中只删除词汇 "string1" 并保留剩余全部 
sed -n '1,5p;5q' example.txt 查看从第一行到第5行内容 
sed -n '5p;5q' example.txt 查看第5行 
sed -e 's/00*/0/g' example.txt 用单个零替换多个零 
cat -n file1 标示文件的行数 
cat example.txt | awk 'NR%2==1' 删除example.txt文件中的所有偶数行 
echo a b c | awk '{print $1}' 查看一行第一栏 
echo a b c | awk '{print $1,$3}' 查看一行的第一和第三栏 
paste file1 file2 合并两个文件或两栏的内容 
paste -d '+' file1 file2 合并两个文件或两栏的内容, 中间用"+"区分 
sort file1 file2 排序两个文件的内容 
sort file1 file2 | uniq 取出两个文件的并集(重复的行只保留一份) 
sort file1 file2 | uniq -u 删除交集, 留下其他的行 
sort file1 file2 | uniq -d 取出两个文件的交集(只留下同时存在于两个文件中的文件) 
comm -1 file1 file2 比较两个文件的内容只删除 'file1' 所包含的内容 
comm -2 file1 file2 比较两个文件的内容只删除 'file2' 所包含的内容 
comm -3 file1 file2 比较两个文件的内容只删除两个文件共有的部分 

字符设置和文件格式转换 
dos2unix filedos.txt fileunix.txt 将一个文本文件的格式从MSDOS转换成UNIX 
unix2dos fileunix.txt filedos.txt 将一个文本文件的格式从UNIX转换成MSDOS 
recode ..HTML < page.txt > page.html 将一个文本文件转换成html 
recode -l | more 显示所有允许的转换格式 

文件系统分析 
badblocks -v /dev/hda1 检查磁盘hda1上的坏磁块 
fsck /dev/hda1 修复/检查hda1磁盘上linux文件系统的完整性 
fsck.ext2 /dev/hda1 修复/检查hda1磁盘上ext2文件系统的完整性 
e2fsck /dev/hda1 修复/检查hda1磁盘上ext2文件系统的完整性 
e2fsck -j /dev/hda1 修复/检查hda1磁盘上ext3文件系统的完整性 
fsck.ext3 /dev/hda1 修复/检查hda1磁盘上ext3文件系统的完整性 
fsck.vfat /dev/hda1 修复/检查hda1磁盘上fat文件系统的完整性 
fsck.msdos /dev/hda1 修复/检查hda1磁盘上dos文件系统的完整性 
dosfsck /dev/hda1 修复/检查hda1磁盘上dos文件系统的完整性 

初始化一个文件系统 
mkfs /dev/hda1 在hda1分区创建一个文件系统 
mke2fs /dev/hda1 在hda1分区创建一个linux ext2的文件系统 
mke2fs -j /dev/hda1 在hda1分区创建一个linux ext3(日志型)的文件系统 
mkfs -t vfat 32 -F /dev/hda1 创建一个 FAT32 文件系统 
fdformat -n /dev/fd0 格式化一个软盘 
mkswap /dev/hda3 创建一个swap文件系统 

SWAP文件系统 
mkswap /dev/hda3 创建一个swap文件系统 
swapon /dev/hda3 启用一个新的swap文件系统 
swapon /dev/hda2 /dev/hdb3 启用两个swap分区 

备份命令
dump -0aj -f /tmp/home0.bak /home 制作一个 '/home' 目录的完整备份 
dump -1aj -f /tmp/home0.bak /home 制作一个 '/home' 目录的交互式备份 
restore -if /tmp/home0.bak 还原一个交互式备份 
rsync -rogpav --delete /home /tmp 同步两边的目录 
rsync -rogpav -e ssh --delete /home ip_address:/tmp 通过SSH通道rsync 
rsync -az -e ssh --delete ip_addr:/home/public /home/local 通过ssh和压缩将一个远程目录同步到本地目录 
rsync -az -e ssh --delete /home/local ip_addr:/home/public 通过ssh和压缩将本地目录同步到远程目录 
dd bs=1M if=/dev/hda | gzip | ssh user@ip_addr 'dd of=hda.gz' 通过ssh在远程主机上执行一次备份本地磁盘的操作 
dd if=/dev/sda of=/tmp/file1 备份磁盘内容到一个文件 
tar -Puf backup.tar /home/user 执行一次对 '/home/user' 目录的交互式备份操作 
( cd /tmp/local/ && tar c . ) | ssh -C user@ip_addr 'cd /home/share/ && tar x -p' 通过ssh在远程目录中复制一个目录内容 
( tar c /home ) | ssh -C user@ip_addr 'cd /home/backup-home && tar x -p' 通过ssh在远程目录中复制一个本地目录 
tar cf - . | (cd /tmp/backup ; tar xf - ) 本地将一个目录复制到另一个地方, 保留原有权限及链接 
find /home/user1 -name '*.txt' | xargs cp -av --target-directory=/home/backup/ --parents 从一个目录查找并复制所有以 '.txt' 结尾的文件到另一个目录 
find /var/log -name '*.log' | tar cv --files-from=- | bzip2 > log.tar.bz2 查找所有以 '.log' 结尾的文件并做成一个bzip包 
dd if=/dev/hda of=/dev/fd0 bs=512 count=1 做一个将 MBR (Master Boot Record)内容复制到软盘的动作 
dd if=/dev/fd0 of=/dev/hda bs=512 count=1 从已经保存到软盘的备份中恢复MBR内容 

光盘命令
cdrecord -v gracetime=2 dev=/dev/cdrom -eject blank=fast -force 清空一个可复写的光盘内容 
mkisofs /dev/cdrom > cd.iso 在磁盘上创建一个光盘的iso镜像文件 
mkisofs /dev/cdrom | gzip > cd_iso.gz 在磁盘上创建一个压缩了的光盘iso镜像文件 
mkisofs -J -allow-leading-dots -R -V "Label CD" -iso-level 4 -o ./cd.iso data_cd 创建一个目录的iso镜像文件 
cdrecord -v dev=/dev/cdrom cd.iso 刻录一个ISO镜像文件 
gzip -dc cd_iso.gz | cdrecord dev=/dev/cdrom - 刻录一个压缩了的ISO镜像文件 
mount -o loop cd.iso /mnt/iso 挂载一个ISO镜像文件 
cd-paranoia -B 从一个CD光盘转录音轨到 wav 文件中 
cd-paranoia -- "-3" 从一个CD光盘转录音轨到 wav 文件中(参数-3) 
cdrecord --scanbus 扫描总线以识别scsi通道 
dd if=/dev/hdc | md5sum 校验一个设备的md5sum编码, 例如一张 CD 

网络命令
(以太网和WIFI无线) 
ifconfig eth0 显示一个以太网卡的配置 
ifup eth0 启用一个 'eth0' 网络设备 
ifdown eth0 禁用一个 'eth0' 网络设备 
ifconfig eth0 192.168.1.1 netmask 255.255.255.0 控制IP地址 
ifconfig eth0 promisc 设置 'eth0' 成混杂模式以嗅探数据包 (sniffing) 
dhclient eth0 以dhcp模式启用 'eth0' 
route -n show routing table 
route add -net 0/0 gw IP_Gateway configura default gateway 
route add -net 192.168.0.0 netmask 255.255.0.0 gw 192.168.1.1 configure static route to reach network '192.168.0.0/16' 
route del 0/0 gw IP_gateway remove static route 
echo "1" > /proc/sys/net/ipv4/ip_forward activate ip routing 
hostname show hostname of system 
host www.example.com lookup hostname to resolve name to ip address and viceversa(1) 
nslookup www.example.com lookup hostname to resolve name to ip address and viceversa(2) 
ip link show show link status of all interfaces 
mii-tool eth0 show link status of 'eth0' 
ethtool eth0 show statistics of network card 'eth0' 
netstat -tup show all active network connections and their PID 
netstat -tupl show all network services listening on the system and their PID 
tcpdump tcp port 80 show all HTTP traffic 
iwlist scan show wireless networks 
iwconfig eth1 show configuration of a wireless network card 
hostname show hostname 
host www.example.com lookup hostname to resolve name to ip address and viceversa 
nslookup www.example.com lookup hostname to resolve name to ip address and viceversa 
whois www.example.com lookup on Whois database 


#----命令全拼--------------------------

pwd: print work directory 打印当前目录 显示出当前工作目录的绝对路径
ps: process status(进程状态，类似于windows的任务管理器)
常用参数：－auxf
ps -auxf 显示进程状态
df: disk free 其功能是显示磁盘可用空间数目信息及空间结点信息。换句话说，就是报告在任何安装的设备或目录中，还剩多少自由的空间。
du: Disk usage
rpm：即RedHat Package Management，是RedHat的发明之一
rmdir：Remove Directory（删除目录）
rm：Remove（删除目录或文件）
cat: concatenate 连锁
cat file1file2>>file3 把文件1和文件2的内容联合起来放到file3中
insmod: install module,载入模块
ln -s : link -soft 创建一个软链接，相当于创建一个快捷方式
mkdir：Make Directory(创建目录)
touch: touch
man: Manual
su：Swith user(切换用户)
cd：Change directory
ls：List files
ps：Process Status
mkdir：Make directory
rmdir：Remove directory
mkfs: Make file system
fsck：File system check
uname: Unix name
lsmod: List modules
mv: Move file
rm: Remove file
cp: Copy file
ln: Link files
fg: Foreground
bg: Background
chown: Change owner
chgrp: Change group
chmod: Change mode
umount: Unmount
dd: 本来应根据其功能描述"Convert an copy"命名为"cc"，但"cc"已经被用以代表"CComplier"，所以命名为"dd"
tar：Tape archive （磁带档案）
ldd：List dynamic dependencies
insmod：Install module
rmmod：Remove module
lsmod：List module
文件结尾的"rc"（如.bashrc、.xinitrc等）：Resource configuration
Knnxxx /Snnxxx（位于rcx.d目录下）：K（Kill）；S(Service)；nn（执行顺序号）；xxx（服务标识）
.a（扩展名a）：Archive，static library
.so（扩展名so）：Shared object，dynamically linked library
.o（扩展名o）：Object file，complied result of C/C++ source file
RPM：Red hat package manager
dpkg：Debian package manager
apt：Advanced package tool（Debian或基于Debian的发行版中提供） 
其他 Linux 命令缩写
bin = Binaries (二进制文件)
/dev = Devices (设备)
/etc = Etcetera (等等)
/lib = LIBrary
/proc = Processes
/sbin = Superuser Binaries (超级用户的二进制文件)
/tmp = Temporary (临时)
/usr = Unix Shared Resources
/var = Variable (变量)
FIFO = First In, First Out
GRUB = GRand Unified Bootloader
IFS= Internal Field Seperators
LILO = LInux LOader
MySQL = My 是最初作者女儿的名字，
SQL = Structured QueryLanguage
PHP = Personal Home Page Tools = PHP HypertextPreprocessor
PS = Prompt String
Perl = “Pratical Extraction and Report Language”(实际的抽取和报告语言) =”Pathologically Eclectic Rubbish Lister”
Python 得名于电视剧Monty Python’s Flying Circus
Tcl = Tool Command Language
Tk = ToolKit
VT = Video Terminal
YaST = Yet Another Setup Tool
apache = “a patchy” server
apt = Advanced Packaging Tool
ar = archiver
as = assembler
awk = “Aho Weiberger and Kernighan”三个作者的姓的第一个字母
bash = Bourne Again SHell
bc = Basic (Better) Calculator
bg = BackGround
biff = 作者HeidiStettner在U.C.Berkely养的一条狗,喜欢对邮递员汪汪叫。
cal = Calendar (日历)
cat = Catenate (链接)
cd = Change Directory
chgrp = Change Group
chmod = Change Mode
chown = Change Owner
chsh = Change Shell
cmp = compare
cobra = Common Object Request BrokerArchitecture
comm = common
cp = Copy
cpio = CoPy In and Out
cpp = C Pre Processor
cron = Chronos 希腊文时间
cups = Common Unix Printing System
cvs = Current Version System
daemon = Disk And Execution MONitor
dc = Desk Calculator
dd = Disk Dump (磁盘转储)
df = Disk Free
diff = Difference
dmesg = diagnostic message
du = Disk Usage
ed = editor
egrep = Extended GREP
elf = Extensible Linking Format
elm = ELectronic Mail
emacs = Editor MACroS
eval = EVALuate
ex = EXtended
exec = EXECute (执行)
fd = file descriptors
fg = ForeGround
fgrep = Fixed GREP
fmt = format
fsck = File System ChecK
fstab = FileSystem TABle
fvwm = F*** Virtual Window Manager
gawk = GNU AWK
gpg = GNU Privacy Guard
groff = GNU troff
hal = Hardware Abstraction Layer
joe = Joe’s Own Editor
ksh = Korn SHell
lame = Lame Ain’t an MP3 Encoder
lex = LEXical analyser
lisp = LISt Processing = Lots of IrritatingSuperfluous Parentheses
ln = Link
lpr = Line PRint
ls = list
lsof = LiSt Open Files
m4 = Macro processor Version 4
man = MANual pages
mawk = Mike Brennan’s AWK
mc = Midnight Commander
mkfs = MaKe FileSystem
mknod = Make Node
motd = Message of The Day
mozilla = MOsaic GodZILLa
mtab = Mount TABle
mv = Move
nano = Nano’s ANOther editor
nawk = New AWK
nl = Number of Lines
nm = names
nohup = No HangUP
nroff = New ROFF
od = Octal Dump
passwd = Passwd
pg = pager
pico = PIne’s message COmposition editor
pine = “Program for Internet News &Email” = “Pine is not Elm”
ping = 拟声 又 = Packet Internet Grouper
pirntcap = PRINTer CAPability
popd = POP Directory
pr = pre
printf = Print Formatted
ps = Processes Status
pty = pseudo tty
pushd = PUSH Directory
pwd = Print Working Directory
rc = runcom = run command, rc还是plan9的shell
rev = REVerse
rm = ReMove
rn = Read News
roff = RunOFF
rpm = RPM Package Manager = RedHat PackageManager
rsh, rlogin, rvim中的
r = Remote
rxvt = ouR XVT
seamoneky = 我
sed = Stream Editor
seq = SEQuence
shar = Shell ARchive
slrn = S-Lang rn
ssh = Secure Shell
ssl = Secure Sockets Layer
stty = Set TTY
su = Substitute User
svn = SubVersion
tar = Tape ARchive
tcsh = TENEX C shell
tee = T (T形水管接口)
telnet = TEminaL over Network
termcap = terminal capability
terminfo = terminal information
tex = τέχνη的缩写，希腊文art
tr = traslate
troff = Typesetter new ROFF
tsort = Topological SORT
tty = TeleTypewriter
twm = Tom’s Window Manager
tz = TimeZone
udev = Userspace DEV
ulimit = User’s LIMIT
umask = User’s MASK
uniq = UNIQue
i = VIsual = Very Inconvenient
vim = Vi IMproved
wall = write all
wc = Word Count
wine = WINE Is Not an Emulator
xargs = eXtended ARGuments
xdm = X Display Manager
xlfd = X Logical Font Description
xmms = X Multimedia System
xrdb = X Resources DataBase
xwd = X Window Dump
yacc = yet another compiler compiler
Fish = the Friendly Interactive SHell
su = Switch User
MIME = Multipurpose Internet Mail Extensions
ECMA = European Computer ManufacturersAssociation


#----JPS工具--------------------------


jps(Java Virtual Machine Process Status Tool)是JDK 1.5提供的一个显示当前所有java进程pid的命令, 简单实用, 非常适合在linux/unix平台上简单察看当前java进程的一些简单情况. 

   我想很多人都是用过unix系统里的ps命令, 这个命令主要是用来显示当前系统的进程情况, 有哪些进程, 及其 id.  jps 也是一样, 它的作用是显示当前系统的java进程情况, 及其id号. 我们可以通过它来查看我们到底启动了几个java进程(因为每一个java程序都会独占一个java虚拟机实例), 和他们的进程号(为下面几个程序做准备), 并可通过opt来查看这些进程的详细启动参数. 

   使用方法:在当前命令行下打 jps(需要JAVA_HOME, 没有的话, 到改程序的目录下打) . 

jps存放在JAVA_HOME/bin/jps, 使用时为了方便请将JAVA_HOME/bin/加入到Path.

$> jps
23991 Jps
23789 BossMain
23651 Resin

比较常用的参数:

-q 只显示pid, 不显示class名称,jar文件名和传递给main 方法的参数
$>  jps -q
28680
23789
23651

-m 输出传递给main 方法的参数, 在嵌入式jvm上可能是null

$> jps -m
28715 Jps -m
23789 BossMain
23651 Resin -socketwait 32768 -stdout /data/aoxj/resin/log/stdout.log -stderr /data/aoxj/resin/log/stderr.log

-l 输出应用程序main class的完整package名 或者 应用程序的jar文件完整路径名

$> jps -l
28729 sun.tools.jps.Jps
23789 com.asiainfo.aimc.bossbi.BossMain
23651 com.caucho.server.resin.Resin

-v 输出传递给JVM的参数

$> jps -v
23789 BossMain
28802 Jps -Denv.class.path=/data/aoxj/bossbi/twsecurity/java/trustwork140.jar:/data/aoxj/bossbi/twsecurity/java/:/data/aoxj/bossbi/twsecurity/java/twcmcc.jar:/data/aoxj/jdk15/lib/rt.jar:/data/aoxj/jd

k15/lib/tools.jar -Dapplication.home=/data/aoxj/jdk15 -Xms8m
23651 Resin -Xss1m -Dresin.home=/data/aoxj/resin -Dserver.root=/data/aoxj/resin -Djava.util.logging.manager=com.caucho.log.LogManagerImpl -

Djavax.management.builder.initial=com.caucho.jmx.MBeanServerBuilderImpl

sudo jps看到的进程数量最全

jps 192.168.0.77

列出远程服务器192.168.0.77机器所有的jvm实例, 采用rmi协议, 默认连接端口为1099

(前提是远程服务器提供jstatd服务)

注:jps命令有个地方很不好, 似乎只能显示当前用户的java进程, 要显示其他用户的还是只能用Unix/Linux的ps命令. 

#----查看硬件信息--lscpu------------------------

查看硬件信息#
Linux里面提供了一系列命令用来查看系统硬件信息, 如lscpu, lsblk, lshw等, 如下:

查看cpu信息#
lscpu命令可以查看cpu信息, 如下:

$ lscpu
Architecture:                    x86_64                                        #指令集架构, pc一般是x86_64, 手机一般是arm64
CPU op-mode(s):                  32-bit, 64-bit                                #支持32位, 64位运行模式
Byte Order:                      Little Endian                                 #小端字节序
Address sizes:                   39 bits physical, 48 bits virtual             # 39位物理地址, 48位虚拟地址
CPU(s):                          8                                             # 8个逻辑核
On-line CPU(s) list:             0-7                                           # 8核都在线
Thread(s) per core:              2                                             # 每个核两个硬件线程(Intel超线程技术)
Core(s) per socket:              4                                             # 每个cpu有4个核
Socket(s):                       1                                             # 1个cpu
Vendor ID:                       GenuineIntel                                  # intel的cpu
CPU family:                      6                                             # cpu产品系列
Model:                           142                                           # cpu产品型号
Model name:                      Intel(R) Core(TM) i7-8550U CPU @ 1.80GHz      # cpu产品型号
Stepping:                        10                                            # 此型号的每10代
CPU MHz:                         1991.998                                      # cpu主频
BogoMIPS:                        3983.99
Hypervisor vendor:               Microsoft                                     # 虚拟化厂商Microsoft, 因为我是在WSL中执行的lscpu
Virtualization type:             full                                          # 虚拟化类型, full表示全虚拟化
L1d cache:                       128 KiB                                       # 一级数据缓存大小
L1i cache:                       128 KiB                                       # 一级指令缓存大小
L2 cache:                        1 MiB                                         # 二级缓存大小
L3 cache:                        8 MiB                                         # 三级缓存大小
可以看到, lscpu能查看cpu的各种详细信息, 这里面需要重点理解的是逻辑核与物理核的概念, 如果一个机器上有2个4核8线程的CPU, 那么它的逻辑核数是16, 物理核数是8, 而从操作系统的视角来看, 它会认为当前机器有16个CPU. 

另外, 如果lscpu不可用, 也可以使用/proc/cpuinfo查看, 如下:

$ cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 142
model name      : Intel(R) Core(TM) i7-8550U CPU @ 1.80GHz
stepping        : 10
microcode       : 0xffffffff
cpu MHz         : 1991.998
cache size      : 8192 KB
physical id     : 0
siblings        : 8
core id         : 0
cpu cores       : 4
...
查看磁盘信息#
使用lsblk可以很容易的看到机器上的磁盘与分区情况, 如下:

$ lsblk -p 
/dev/sda      8:0    0   280G  0 disk
└─/dev/sda1   8:1    0   280G  0 part /
可以看到当前机器只有一个磁盘, 大小是280G, 它被虚拟成了/dev/sda文件, 而磁盘/dev/sda只有1个分区, 它被虚拟成了/dev/sda1文件, 这里又印证了Unix"一切皆文件"的设计哲学, 硬盘与分区都被虚拟成了文件!

相信你也发现了一些Linux磁盘命名的规律, 如果有3个磁盘, 命名就是sda, sdb, sdc, 如果sda有3个分区, 分区名就是sda1, sda2, sda3, 以此类推. 

fdisk也可以用来查看磁盘信息, 如下:

$ sudo fdisk -l 
Disk /dev/sda: 280 GiB, 300647710720 bytes, 587202560 sectors
Disk model: VMware Virtual S
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xd36fd4dd

Device     Boot Start       End   Sectors  Size Id Type
/dev/sda1  *     2048 587202559 587200512  280G 83 Linux

Disk /dev/sda1: 279.102 GiB, 300646662144 bytes, 587200512 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
还有一个常见场景是查看硬盘类型, 比如:

当前磁盘是机械硬盘还是SSD?
如果是SSD的话, 它是SATA SSD还是PCIe SSD?
对于这3种不同类型的磁盘, 它们之间的性能差异巨大, 区分方法如下:

$ lsblk -o name,size,type,rota /dev/sda
NAME    SIZE TYPE ROTA
sda     280G disk    1  # ROTA代表是否旋转磁盘, 所以1代表机械硬盘, 0代表固态硬盘
└─sda1  280G part    1

# 执行下面两条命令, 就可以区分是SATA SSD还是PCIe SSD了, 一般来说, PCIe SSD性能较好
$ lspci -vmm|grep -iE 'SATA|AHCI'
$ lspci -vmm|grep -iE 'PCIe|NVMe'
另外, 下面这些命令也可以查看磁盘相关信息, 一般需要自行安装, 如下:

# 查看scsi磁盘设备
$ lsscsi
# 查看磁盘详细信息
$ sudo smartctl --info /dev/sda
$ sudo hdparm -I /dev/sda
查看网卡信息#
使用ethtool可以查看网卡的一些硬件参数, 如下:

# 查看网卡参数, 会输出好多看不懂的内容, 应用层开发一般关注speed/duplex/link就可以了
$ sudo ethtool eth0
Settings for eth0:
   Supported ports: [ TP ]
   Supported pause frame use: No
   Supports auto-negotiation: Yes
   Advertised pause frame use: No
   Advertised auto-negotiation: Yes
   Advertised FEC modes: Not reported
   Speed: 1000Mb/s                        # 网卡速率
   Duplex: Full                           # 全双工网卡
   Port: Twisted Pair
   PHYAD: 0
   Transceiver: internal
   Auto-negotiation: on
   MDI-X: off (auto)
   Supports Wake-on: d
   Wake-on: d
   Link detected: yes                     # 网卡连了网线

# 查看网卡数据包统计信息, 关注drop/error之类的指标, 这代表网卡层是否有丢包或错误产生
$ sudo ethtool -S eth0

# 查看网卡RingBuffer大小
$ sudo ethtool -g eth0 
# 设置网卡RingBuffer大小
$ sudo ethtool -G eth0 rx 2048

# 使eth0网卡灯闪烁, 网络运维可能会经常使用这个, 因为机房网线错综复杂很难分清谁是谁的
$ sudo ethtool -p eth0

# 查看网卡驱动
$ sudo ethtool -i eth0
# 查看网卡支持的特性
$ sudo ethtool -k eth0
# 查看与调整网卡队列数Combined
$ sudo ethtool -l eth0
$ sudo ethtool -L eth0 combined 8
查看其它硬件信息#
除了cpu, 内存, 磁盘, 网卡外, 机器上还有一些其它硬件, 如总线, 主板, usb等, 开发人员一般关注较少, 这里只简单介绍一下, 混个眼熟即可. 

# 查看usb设备
$ lsusb

# 查看pci设备, 一般外围设备都是通过pci总线连接进来的, 所以这个命令一般可以看到很多设备, 包括磁盘与网卡等
# 输出中Kernel driver in use表示设备驱动, Kernel modules表示内核模块
$ lspci -v

# 通过这个命令, 机器中所有的硬件信息, 都能查看到
$ lshw
查看系统信息#
做为后端开发, 一般我们比较关注的系统信息有内核版本, 发行版, 底层c库版本等等, 这些在Linux下也非常容易查看, 如下:

查看内核版本#
$ uname -r
5.4.0-74-generic

# 通过/proc/version也能看到内核版本
$ cat /proc/version
Linux version 5.4.0-74-generic (buildd@lgw01-amd64-038) (gcc version 9.3.0 (Ubuntu 9.3.0-17ubuntu1~20.04)) 83-Ubuntu SMP Sat May 8 02:35:39 UTC 2021
可以看到, 当前系统Linux内核版本是5.4.0-74-generic. 

另外, 内核从源码编译时可以配置一些选项, 内核启动时也可以配置一些选项, 如要检查这些选项, 可如下查看:

# /boot/config-*文件保存了内核的编译配置
# 如下查看内核编译时是否开启了KPROBES(内核追踪)功能
$ cat /boot/config-`uname -r` | grep -i KPROBES
CONFIG_KPROBES=y

# 查看内核启动参数
$ cat /proc/cmdline
BOOT_IMAGE=/boot/vmlinuz-5.4.0-74-generic root=UUID=fce5376b-dcc2-4550-a72a-e7cf0f5354a4 ro find_preseed=/preseed.cfg auto noprompt priority=critical locale=en_US text nomodeset vga=792
查看发行版#
Linux和Windows不一样, Linux本身只是一个操作系统内核, 它提供基础的进程调度, 内存管理等功能, 而我们使用的Linux, 如Ubuntu, Centos, 这些是Linux发行版, 它们将Linux下常用的软件以及内核打包在一起, 然后发行出来给大家使用, 降低了Linux使用的难度. 

如下, 查看当前系统是哪个发行版:

# /etc目录下有各种*-release文件, 这些文件里面记录着发行版的信息
$ ls /etc/*-release
/etc/centos-release  /etc/os-release  /etc/redhat-release  /etc/system-release

# 一般通过/etc/os-release就可以了, 如下显示发行版是CentOS 7
$ cat /etc/os-release
NAME="CentOS Linux"
VERSION="7 (Core)"
ID="centos"
ID_LIKE="rhel fedora"
VERSION_ID="7"
PRETTY_NAME="CentOS Linux 7 (Core)"
ANSI_COLOR="0;31"
查看系统启动时间#
# 查看系统启动至今的秒数
$ cat /proc/uptime|cut -d. -f1
3810068

# 通过date命令转化为启动时间点, 如下:
$ date -d "`cat /proc/uptime|cut -d. -f1` seconds ago" +'%F %T'
2021-11-04 12:51:50
查看libc版本#
像Linux上的glibc, Windows上的msvc, 它们都是底层c库, 目前几乎是所有应用层软件的基石. 

然而某些场景下, 两个不同版本的c库, 性能差别会非常大, 因此常规性检查一下它们的版本也是非常有必要的, 如下:

# ldd可直接查看glibc版本, 如下显示glibc版本是2.31
$ ldd --version
ldd (Ubuntu GLIBC 2.31-0ubuntu9) 2.31

# ldd可以查看某个程序的所有动态链接库
# 因此可以通过如下方法检查java程序使用的各种底层库版本
$ ldd `which java`
       linux-vdso.so.1 (0x00007ffeb11f1000)
       /usr/local/lib/libjemalloc.so (0x00007fdcdd8fe000)                           
       libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007fdcdd8cb000)
       libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007fdcdd8a8000) # 线程库
       libjli.so => /opt/jdk-11.0.12+7/bin/../lib/jli/libjli.so (0x00007fdcdd697000)
       libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007fdcdd691000)
       libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fdcdd49f000)            # 基础c库
       libstdc++.so.6 => /lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007fdcdd2bb000)  # 基础c++库
       libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007fdcdd2a0000)
       /lib64/ld-linux-x86-64.so.2 (0x00007fdcdddc1000)
       libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007fdcdd151000)
# c库版本是2.31
$ ls -l /lib/x86_64-linux-gnu/libc.so.6
lrwxrwxrwx 1 root root 12 2020-04-15 03:26:04 /lib/x86_64-linux-gnu/libc.so.6 -> libc-2.31.so
# c++库版本是6.0.28
$ ls -l /lib/x86_64-linux-gnu/libstdc++.so.6
lrwxrwxrwx 1 root root 19 2021-05-29 15:49:27 /lib/x86_64-linux-gnu/libstdc++.so.6 -> libstdc++.so.6.0.28
# pthread线程库版本是2.31
$ ls -l /lib/x86_64-linux-gnu/libpthread.so.0
lrwxrwxrwx 1 root root 18 2020-04-15 03:26:04 /lib/x86_64-linux-gnu/libpthread.so.0 -> libpthread-2.31.so
neofetch#
可以看到, 上面那些命令查看系统信息还是比较零碎的, 所以出现了一些命令, 将上面的常见场景做了一些聚合, 使得能快速直观的看到系统的主要信息, 如neofetch命令:

$ neofetch
neofetch

如上所示, neofetch会显示发行版的一个炫酷图标, 上面那个像写轮眼的图标就是Ubuntu的logo. 
然后会显示一些系统关键信息, 如内核版本, 启动时间, Shell版本, CPU/GPU/Memory等. 

#----curl--------------------------

curl http://127.0.0.1:5000/worth
curl http://localhost:5000/worthpt
curl -v -X GET "https://httpbin.org/get" -H "accept: application/json"
curl -v -X POST "https://httpbin.org/post" -H "accept: application/json"
curl -X PATCH "http://httpbin.org/patch" -H "accept: application/json"
curl -X DELETE "http://httpbin.org/delete" -H "accept: application/json"
curl -X PUT "http://httpbin.org/put" -H "accept: application/json"
curl ifconfig.me # 查询IP
wget -qO- https://bin.equinox.io/amd64.tgz | tar zxvf -  

命令:curl
在Linux中curl是一个利用URL规则在命令行下工作的文件传输工具, 可以说是一款很强大的http命令行工具. 它支持文件的上传和下载, 是综合传输工具, 但按传统, 习惯称url为下载工具. 

语法:# curl [option] [url]

常见参数:
-A/--user-agent <string>              设置用户代理发送给服务器
-b/--cookie <name=string/file>    cookie字符串或文件读取位置
-c/--cookie-jar <file>                    操作结束后把cookie写入到这个文件中
-C/--continue-at <offset>            断点续转
-D/--dump-header <file>              把header信息写入到该文件中
-e/--referer                                  来源网址
-f/--fail                                          连接失败时不显示http错误
-o/--output                                  把输出写到该文件中
-O/--remote-name                      把输出写到该文件中, 保留远程文件的文件名
-r/--range <range>                      检索来自HTTP/1.1或FTP服务器字节范围
-s/--silent                                    静音模式. 不输出任何东西
-T/--upload-file <file>                  上传文件
-u/--user <user[:password]>      设置服务器的用户和密码
-w/--write-out [format]                什么输出完成后
-x/--proxy <host[:port]>              在给定的端口上使用HTTP代理
-#/--progress-bar                        进度条显示当前的传送状态

例子:
1, 基本用法
# curl http://www.linux.com
执行后, www.linux.com 的html就会显示在屏幕上了
Ps:由于安装linux的时候很多时候是没有安装桌面的, 也意味着没有浏览器, 因此这个方法也经常用于测试一台服务器是否可以到达一个网站

2, 保存访问的网页
2.1:使用linux的重定向功能保存
# curl http://www.linux.com >> linux.html

2.2:可以使用curl的内置option:-o(小写)保存网页
$ curl -o linux.html http://www.linux.com
执行完成后会显示如下界面, 显示100%则表示保存成功
% Total    % Received % Xferd  Average Speed  Time    Time    Time  Current
                               Dload  Upload  Total  Spent    Left  Speed
100 79684    0 79684    0    0  3437k      0 --:--:-- --:--:-- --:--:-- 7781k

2.3:可以使用curl的内置option:-O(大写)保存网页中的文件
要注意这里后面的url要具体到某个文件, 不然抓不下来
# curl -O http://www.linux.com/hello.sh

3, 测试网页返回值
# curl -o /dev/null -s -w %{http_code} www.linux.com
Ps:在脚本中, 这是很常见的测试网站是否正常的用法

4, 指定proxy服务器以及其端口
很多时候上网需要用到代理服务器(比如是使用代理服务器上网或者因为使用curl别人网站而被别人屏蔽IP地址的时候), 幸运的是curl通过使用内置option:-x来支持设置代理
# curl -x 192.168.100.100:1080 http://www.linux.com

5, cookie
有些网站是使用cookie来记录session信息. 对于chrome这样的浏览器, 可以轻易处理cookie信息, 但在curl中只要增加相关参数也是可以很容易的处理cookie
5.1:保存http的response里面的cookie信息. 内置option:-c(小写)
# curl -c cookiec.txt  http://www.linux.com
执行后cookie信息就被存到了cookiec.txt里面了

5.2:保存http的response里面的header信息. 内置option: -D
# curl -D cookied.txt http://www.linux.com
执行后cookie信息就被存到了cookied.txt里面了

注意:-c(小写)产生的cookie和-D里面的cookie是不一样的. 

5.3:使用cookie
很多网站都是通过监视你的cookie信息来判断你是否按规矩访问他们的网站的, 因此我们需要使用保存的cookie信息. 内置option: -b
# curl -b cookiec.txt http://www.linux.com

6, 模仿浏览器
有些网站需要使用特定的浏览器去访问他们, 有些还需要使用某些特定的版本. curl内置option:-A可以让我们指定浏览器去访问网站
# curl -A "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.0)" http://www.linux.com
这样服务器端就会认为是使用IE8.0去访问的

7, 伪造referer(盗链)
很多服务器会检查http访问的referer从而来控制访问. 比如:你是先访问首页, 然后再访问首页中的邮箱页面, 这里访问邮箱的referer地址就是访问首页成功后的页面地址, 如果服务器发现对邮箱页面访问的referer地址不是首页的地址, 就断定那是个盗连了
curl中内置option:-e可以让我们设定referer
# curl -e "www.linux.com" http://mail.linux.com
这样就会让服务器其以为你是从www.linux.com点击某个链接过来的

8, 下载文件
8.1:利用curl下载文件. 
#使用内置option:-o(小写)
# curl -o dodo1.jpg http:www.linux.com/dodo1.JPG

#使用内置option:-O(大写)
# curl -O http://www.linux.com/dodo1.JPG
这样就会以服务器上的名称保存文件到本地

8.2:循环下载
有时候下载图片可以能是前面的部分名称是一样的, 就最后的尾椎名不一样
# curl -O http://www.linux.com/dodo[1-5].JPG
这样就会把dodo1, dodo2, dodo3, dodo4, dodo5全部保存下来

8.3:下载重命名
# curl -O http://www.linux.com/{hello,bb}/dodo[1-5].JPG
由于下载的hello与bb中的文件名都是dodo1, dodo2, dodo3, dodo4, dodo5. 因此第二次下载的会把第一次下载的覆盖, 这样就需要对文件进行重命名. 
# curl -o #1_#2.JPG http://www.linux.com/{hello,bb}/dodo[1-5].JPG
这样在hello/dodo1.JPG的文件下载下来就会变成hello_dodo1.JPG,其他文件依此类推, 从而有效的避免了文件被覆盖

8.4:分块下载
有时候下载的东西会比较大, 这个时候我们可以分段下载. 使用内置option:-r
# curl -r 0-100 -o dodo1_part1.JPG http://www.linux.com/dodo1.JPG
# curl -r 100-200 -o dodo1_part2.JPG http://www.linux.com/dodo1.JPG
# curl -r 200- -o dodo1_part3.JPG http://www.linux.com/dodo1.JPG
# cat dodo1_part* > dodo1.JPG
这样就可以查看dodo1.JPG的内容了

8.5:通过ftp下载文件
curl可以通过ftp下载文件, curl提供两种从ftp中下载的语法
# curl -O -u 用户名:密码 ftp://www.linux.com/dodo1.JPG
# curl -O ftp://用户名:密码@www.linux.com/dodo1.JPG

8.6:显示下载进度条
# curl -# -O http://www.linux.com/dodo1.JPG

8.7:不会显示下载进度信息
# curl -s -O http://www.linux.com/dodo1.JPG

9, 断点续传
在windows中, 我们可以使用迅雷这样的软件进行断点续传. curl可以通过内置option:-C同样可以达到相同的效果
如果在下载dodo1.JPG的过程中突然掉线了, 可以使用以下的方式续传
# curl -C -O http://www.linux.com/dodo1.JPG

10, 上传文件
curl不仅仅可以下载文件, 还可以上传文件. 通过内置option:-T来实现
# curl -T dodo1.JPG -u 用户名:密码 ftp://www.linux.com/img/
这样就向ftp服务器上传了文件dodo1.JPG

11, 显示抓取错误
# curl -f http://www.linux.com/error

其他参数(此处翻译为转载):
-a/--append                        上传文件时, 附加到目标文件
--anyauth                            可以使用'任何'身份验证方法
--basic                                使用HTTP基本验证
-B/--use-ascii                      使用ASCII文本传输
-d/--data <data>                  HTTP POST方式传送数据
--data-ascii <data>            以ascii的方式post数据
--data-binary <data>          以二进制的方式post数据
--negotiate                          使用HTTP身份验证
--digest                        使用数字身份验证
--disable-eprt                  禁止使用EPRT或LPRT
--disable-epsv                  禁止使用EPSV
--egd-file <file>              为随机数据(SSL)设置EGD socket路径
--tcp-nodelay                  使用TCP_NODELAY选项
-E/--cert <cert[:passwd]>      客户端证书文件和密码 (SSL)
--cert-type <type>              证书文件类型 (DER/PEM/ENG) (SSL)
--key <key>                    私钥文件名 (SSL)
--key-type <type>              私钥文件类型 (DER/PEM/ENG) (SSL)
--pass  <pass>                  私钥密码 (SSL)
--engine <eng>                  加密引擎使用 (SSL). "--engine list" for list
--cacert <file>                CA证书 (SSL)
--capath <directory>            CA目   (made using c_rehash) to verify peer against (SSL)
--ciphers <list>                SSL密码
--compressed                    要求返回是压缩的形势 (using deflate or gzip)
--connect-timeout <seconds>    设置最大请求时间
--create-dirs                  建立本地目录的目录层次结构
--crlf                          上传是把LF转变成CRLF
--ftp-create-dirs              如果远程目录不存在, 创建远程目录
--ftp-method [multicwd/nocwd/singlecwd]    控制CWD的使用
--ftp-pasv                      使用 PASV/EPSV 代替端口
--ftp-skip-pasv-ip              使用PASV的时候,忽略该IP地址
--ftp-ssl                      尝试用 SSL/TLS 来进行ftp数据传输
--ftp-ssl-reqd                  要求用 SSL/TLS 来进行ftp数据传输
-F/--form <name=content>        模拟http表单提交数据
-form-string <name=string>      模拟http表单提交数据
-g/--globoff                    禁用网址序列和范围使用{}和[]
-G/--get                        以get的方式来发送数据
-h/--help                      帮助
-H/--header <line>              自定义头信息传递给服务器
--ignore-content-length        忽略的HTTP头信息的长度
-i/--include                    输出时包括protocol头信息
-I/--head                      只显示文档信息
-j/--junk-session-cookies      读取文件时忽略session cookie
--interface <interface>        使用指定网络接口/地址
--krb4 <level>                  使用指定安全级别的krb4
-k/--insecure                  允许不使用证书到SSL站点
-K/--config                    指定的配置文件读取
-l/--list-only                  列出ftp目录下的文件名称
--limit-rate <rate>            设置传输速度
--local-port<NUM>              强制使用本地端口号
-m/--max-time <seconds>        设置最大传输时间
--max-redirs <num>              设置最大读取的目录数
--max-filesize <bytes>          设置最大下载的文件总量
-M/--manual                    显示全手动
-n/--netrc                      从netrc文件中读取用户名和密码
--netrc-optional                使用 .netrc 或者 URL来覆盖-n
--ntlm                          使用 HTTP NTLM 身份验证
-N/--no-buffer                  禁用缓冲输出
-p/--proxytunnel                使用HTTP代理
--proxy-anyauth                选择任一代理身份验证方法
--proxy-basic                  在代理上使用基本身份验证
--proxy-digest                  在代理上使用数字身份验证
--proxy-ntlm                    在代理上使用ntlm身份验证
-P/--ftp-port <address>        使用端口地址, 而不是使用PASV
-Q/--quote <cmd>                文件传输前, 发送命令到服务器
--range-file                    读取(SSL)的随机文件
-R/--remote-time                在本地生成文件时, 保留远程文件时间
--retry <num>                  传输出现问题时, 重试的次数
--retry-delay <seconds>        传输出现问题时, 设置重试间隔时间
--retry-max-time <seconds>      传输出现问题时, 设置最大重试时间
-S/--show-error                显示错误
--socks4 <host[:port]>          用socks4代理给定主机和端口
--socks5 <host[:port]>          用socks5代理给定主机和端口
-t/--telnet-option <OPT=val>    Telnet选项设置
--trace <file>                  对指定文件进行debug
--trace-ascii <file>            Like --跟踪但没有hex输出
--trace-time                    跟踪/详细输出时, 添加时间戳
--url <URL>                    Spet URL to work with
-U/--proxy-user <user[:password]>  设置代理用户名和密码
-V/--version                    显示版本信息
-X/--request <command>          指定什么命令
-y/--speed-time                放弃限速所要的时间. 默认为30
-Y/--speed-limit                停止传输速度的限制, 速度时间 秒
-z/--time-cond                  传送时间设置
-0/--http1.0                    使用HTTP 1.0
-1/--tlsv1                      使用TLSv1(SSL)
-2/--sslv2                      使用SSLv2的(SSL)
-3/--sslv3                      使用的SSLv3(SSL)
--3p-quote                      like -Q for the source URL for 3rd party transfer
--3p-url                        使用url, 进行第三方传送
--3p-user                      使用用户名和密码, 进行第三方传送
-4/--ipv4                      使用IP4
-6/--ipv6                      使用IP6

#----find--------------------------

find——较复杂的方式查找文件

find命令的完整语法格式:
find [path] [options] [tests] [actions]

命令各部分详解:
path即查找的路径, 可以使用绝对路径, 也可以使用相对路径. 

options:选项参数
选项	含义
-depth	在查看目录本身之前先搜索目录的内容(始终为true)
-follow	跟随符号链接
-maxdepth N	最多搜索N层目录
-mount(或-xdev)	不搜索其他文件系统中的目录
tests: 测试选项

test参数	描述
-cmin n	匹配n分钟前改变状态(内容或属性)的文件或目录. 如果不到n分钟, 就用-n, 如果超过n分钟, 就用+n
-mmin n	匹配n分钟前改变内容的文件或目录
-mtime n	匹配n天前改变内容的文件或目录
-empty	匹配空文件及空目录
-name pattern	匹配有特定通配符模式的文件或目录, pattern必须用引号扩起, 确保传递给find命令而不是由shell处理
-iname pattern	与-name相似, 只是不区分大小写
-newer file	匹配内容的修改时间比file文件更近的文件或目录
-size n	匹配n大小的文件
-type c	匹配c类型的文件
-user name	匹配属于name用户的文件和目录. name可以描述为用户名也可以描述为该组的ID号
-perm mode	寻找访问权限与既定模式匹配的文件或目录. 既定模式可以以八进制或符号的形式表示
-inum n	匹配索引节点是n的文件
-group name	匹配属于name组的文件或目录. name可以描述为组名, 也可以描述为该组的ID号
下面着重讨论 -size n 和 -type c

-size n
其支持的计量单位如下表所示:
字母	单位
b	512字节的块(block)
c	字节(char)
w	两个字节的字(word)
k	KB(每单位包含1024字节)
M	MB(每单位包含1,048,577字节)
G	GB(每单位包含1,073,741,824字节)
注意:'+'和'-'的用法适用于所有用到数值参数的情况. '+'代表超过, '-'代表未超过. 
比如:-size +1M, 代表查找的文件大小比给定的数值1M大

-type c
其支持的文件类型如下表所示:
文件类型	描述
b	block, 块设备文件
c	char, 字符设备文件
d	directory, 目录
f	file, 普通文件
l	link, 符号链接
test参数之间的逻辑关系如下表所示:

操作符	功能描述
-and(与操作)	and是默认的逻辑关系, 两个测试均为真. 有时缩写为-a
-or(或操作)	两个测试一个为真. 有时缩写为-o
-not(非操作)	测试取反. 有时缩写为!
( )(括号操作)	提高可读性, 以组成更长的表达式. 通常用反斜杠 \"来避免特殊含义

actions:动作选项
动作	功能描述
-delete	删除匹配文件
-ls	对匹配文件执行ls操作
-print	将匹配的文件的全路径以标准形式输出. 未指定操作时是默认操作
-quit	一旦匹配成功便退出
-exec command	执行一条命令, 该命令可以是用户想要执行的操作命令
-ok command	与-exec类似, 但是执行命令之前会针对每个要处理的文件, 提示用户确认
下面着重讨论 -exec command

-exec command {} ;
其中command表示要执行的命令, 魔术字符串{}花括号是一个特殊类型参数, 表示当前文件的完整路径. 分号;代表分隔符, 是必须的, 表示命令结束. 
通常将{}和;用反斜杠\或者引号’ '进行转义', 因此, 上述命令也变成-exec command \{\} \;

find -iname "*.log" | wc -l # log文件的数量 # ll |grep "^-" |wc -l  
find . -type f -iname "*.txt" | xargs grep -inr "clearance" | grep -v grep 
# 使用()将运算式分隔, exp1 -and exp2 -a与; -not|!非 expr ; exp1 -or exp2 -o或; exp1, exp2 ; 
# -mount,-xdev 同一个文件系统 ; -ipath p,-path p 路径p ; -name name, -iname name文件名称   
# -newer abc !def 更新时间比abc新比def旧 ; -anewer abc 访问时间比abc新 ; cnewer file
# -type d目录 c字型 b区块 p具名贮列Fifo f一般 l符号连接 s套接字socket -pid n # 
# -size -n|n|+n  # -n内/小于 +n外/超过 n:本身 ; c字节/w字2字节/b块512字节/k千/M兆/G吉 
# -ctime -n|n|+n 创建天 -mtime修改天 -amin 读取分钟 ; -ok操提示 ; 
# -mindepth n 从第n级目录开始搜索; -maxdepth n 表示至多搜索到第n-1级子目录; -print 打印输出为预设 expression;  
find . -path ./test -prune -o -path ./opt -prune -o -type f # 查找当前目录下所有普通文件, 排除test/opt目录 ; -prune 仅当前目录(不包含子目录)
find /home/tyrone -iname "*.txt" -exec grep -l "hello world" {} \; | xargs grep -i "mailx"
# find . > tmpfile | wc -l tmpfile # 文件数量太多
find ./ -empty -type f -print -delete  # 查找空文件并删除 ; 
find ./ -perm 664 # 查找权限为644的文件或目录 # /u+w,g+w  /u=w,g=w  -u=r ; -user lzj 所有者为lzj ; -group gname 组名为gname ; -nouser 用户ID不存在; -nogroup 组ID不存在 ; -executable \! -readable  查找有执行没可读权限 
find . -ctime +1  -exec mv {} old/ ;  # -exec rm -fv {} \; # | xargs rm -rf
find . -maxdepth 1 -mtime +1  -iname "*.log"| xargs -I '{}' mv {} old/ # 移动当前目录下1日前log文件至old/下 # ! -name "." -type d -prune  # 仅当前目录(不包含子目录)
find . -type f -size +1M  -print0 | xargs -0 du -h | sod -10  # 查看1m文件 
find /workspaces/jupyter/prod/ -type f -size +1M  -print0 | xargs  -0  rm  # 删除超过 1m 文件
find /workspaces/jupyter/prod/ . -iname *log* | xargs rm -rf # 删除log文件/目录 csv jpg
find /workspaces/jupyter/prod/ -path /workspaces/jupyter/prod/47.241.99.13/strategy/logic -prune -o -regex '.*\.log\|.*\.csv\|.*\.jpg\|.*log.*\.txt' -print | xargs rm -rf # 删除prod下 log文件/目录 csv jpg

#----regex--------------------------

.任意字符
^行首匹配
$行尾匹配
^$表示空行,不含字符的行
^ $匹配只有单个空格的行
[0-9]
[a-zA-Z]
^[A-Z]搜索以大写字母开头的行
[^A-Z]匹配大写字母意外的任意字符
*表示匹配0个或若干个字符, 如:a*,表示匹配0个或若干个a; aa*表示匹配至少1个a
.*来表示0或若干个任意字符
e.e*表示匹配第一个e和最后一个e之间的任意字符
[-0-9]匹配一个连字符或数字
[]a-z]匹配一个]或者字母
\{min,max\}匹配任意数目的字符串
[a-z]\{10\}只匹配10个a-z字符的字符串
s/.\{5\}$// 删除每行的最后5个字符
\(...\),n是1到9的数字,表示存储用的寄存器,用\n来引用存在寄存器中的内容
^\(.\)\1匹配行首的第一个字符,并将该字符存到1号寄存器中,然后匹配1号寄存器中的内容,这由\1的描述. 该正则表达式的最终效果是,如果一行的头两个字符相同,就匹配他们. 
^\(.\).*\1$匹配一行中的头一个字符(^.)跟最后一个字符(\1$)相同的行. .*匹配中间的所有内容
^\(...\)\(...\)行中头三个字符存在1号寄存器,接着的三个字符存在2号寄存器.
s/\(.*\) \(.*\)/\2 \1/g 交换两个字段

.任何字符
^行首
$行尾
*前导的正则表达式重复0或若干次
[字符表]字符中的任一字符
a..表示a后的2个字符
^wood表示行首的wood
x$表示行为的x
^INSERT$只包含字符串INSERT的行
^$不包含任何字符的行
x*表示0或若干个连续的x
xx*表示1或多个连续的x
.*表示0活若干个字符
w.*s表示以w开始,s结尾的任何字符串
[tT]小写或大写的t

[^字符表]表示任一不在字符表中的字符[^0-9] [^a-zA-Z]
\{min,max\}表示前导的正则表达式重复只烧min次,至多max次[0-9]\{3,9\}表示3到9个数字
\(...\)表示将小括号中匹配的字符串存储到下一个寄存器中(1-9),
^\(.\)表示行中第1个字符存到1号寄存器
^\(.\)\1表示行首恋歌字符,且他们相同

cut -c5 file把file文件中没行的第5个字符析取出来;
用逗号分割的数值列表,如-c1,13,50把第1,13,50个字符析取出来
cut -c20-50把第20到50之间的字符析取出来
如
who | cut -c1-8
who | cut -c1-8,18- 析取行中的第1到8个字符(用户名)和第18到行尾的字符(登录时间)

cut -ddchar -ffields file其中,dchar是数据中分割各字段的分割符,fields表示要从文件file中析取出来的字段.
字段编号从1开始,而且格式跟以前将的用来指定字符位置的数字一样(如-f1, 2, 8, -f1-3, -f4-). 
cut -d: -f1 /etc/passwd
如果已知字段之间使用制表符分隔的,就可以给cut命令用-f选项而不用-c选项,好多了!还记得吧,这里用不着用-d选项来指定分割符,因为
cut把制表符默认为分割符. 

paste和cut正好相反,它不是把行分离开,而是把多行合并在一起. 

paste names numbrs文件names中的每一行都和numbers中的对应行显示在一起,中间用制表符分割. 
如果不想用制表符作默认分割,可以使用-dchars指定分割符
paste -d'+' names addresses numbers
-s选项告诉paste把同一文件中的行粘贴在一起,而不是从其他文件. 如果只指定一个文件名,其效果是把文件中的所有行合并成一行,原来隔行之间用制表符或者有-d选项指定的分割符分割. 

sed是用来编辑数据的程序,意指流编辑器(stream editor). 与ed不同,sed不能用于交互,
-n选项,然后使用p命令显式指定
sed -n '1,2p' file只显示前2行
sed -n '/Unix/p' file只打印包含Unix的行
删除行
d删除整行文件
sed '1,2d' file删除1和2行
记住sed默认把输入的所有行写入标准输出,所以生于行的文字,也就是从第3行到结尾,都被写入标准输出. 
sed '5d'删除第5行
sed '/[Tt]est/d'删除包含test或Test的行
sed -n '20,25p' test只显示文件test的第20行到第25行
sed '1,10s/unix/UNIX/g' intro报intro前10行中的unix改为UNIX
sed '/jan/s/-1/-5/'将所有包含jan的行中第1个-1改为-5
sed 's/...//' data删除data文件每一行的前3个字符
sed 's/...$//' data删除data文件每一行的最后3个字符
sed -n 'I' text显示文件text的所有行,把所有不可打印字符显示为\nn,制表符显示为\t

过滤器tr用来转换来自标准输入的字符,tr命令的一般格式为
tr from-chars to-chars

tr e x < intro把所有字母e转换成x
tr命令的输入必须重定向到文件intro,因为tr总是从标准输入获得输入;转换的结果写入标准输出,而原始文件保持不变. 
cut -d: -f1,6 /etc/passwd | tr : '  ' 通过在管道线的最后加上适当的tr命令,就可以把冒号转换成制表符,这样产生的输出更容易看
单引号中括的是制表符(尽管你看不到). 必须将它括在引号中,以便穿过shell,使tr有机会看到它. 
使用\nnn来给tr提供8进制表示的字符
一些ascii字符的八进制值
响铃    7
退格    10
制表符  11
新行    12
换行    12
换页    14
回车    15
转义    33

date | tr ' ' '\12'此例中,tr接受date命令的输出,并把所有的空格转换成换行
tr '[a-z]' '[A-Z]' -s选项,tr命令中的-s选项用来压缩to-chars中重复的字符,换句话说,如果转换完成后,有to-chars中的某个字符连续出现多次,则这些连续相同的字符被替换为一个字符. 
如下面的命令将冒号转换为制表符,并将多个连续制表符替换为单个制表符:
tr -s ':' '\11\'
tr -s ' ' ' ' -d选项用来删除掉输入流中的字符,其一般格式为
tr -d from-chars任何列在from-chars中的字符都会被从标准输入中删除. 下例用tr来删除文件intro中的所有空格:
tr -d ' ' 当然sed 's/ //g' intro也可以得到同样的效果

tr 'X' 'x'     把大X专成小x
tr '()' '{}'   把所有左小括号转换成左大括号,右小括号专成右大括号
tr '[a-z]' '[A-Z]' 把小写转大写
tr '[A-Z]' '[N-ZA-M]' 把A-M字母分别专成N-Z把N-Z转成A-M
tr '    ' ''把所有制表符转换成空格
tr -s ' ' ''把多个空格转换成单个空格
tr -d '\14' 删除所有换页字符(八进制14)
tr -d '[0-9]'删除所有数字

grep '[A-Z]' list list中包含一个大写字母的行
grep '[0-9]' data中包含数字的行
grep '[A-Z]...[0-9]' list list中包含以大写字母开始, 数字结尾的5个字符组合的行
grep '\.pic$' filelist filelist中以.pic结尾的行

uniq in_file out_file该格式中,uniq把in_file复制到out_file,处理过程中,去掉其中的重复行. 如果不指定第2个参数out_file,结果就写入标准输出; 如果in_file没有指定,那么uniq就成了一个过滤器,从标准输入读取输入. 

>或<    重定向,覆盖原有的内容
# >>或<<  重定向, 想文件末尾追加内容

tee  显示在终端上的内容存储到文件 ls | tee >glx

-d  目录
-e  存在
-f  普通文件
-r  进程可读文件
-s  长度不为0
-w  进程可写文件
-x  可执行
-L  链接文件

$#  传给程序的参数个数,或者执行set命令设置的参数个数
$*  对位置参数等的集中引用
$@  跟$*相似,区别在于当加入双引号后("$@"),集中引用位置参数"$1","$2"...等
$0  正执行的程序名
$$  正执行程序的进程id
$!  最后一个发生后台运行的程序的进程id
$?  最后一个在前台执行的程序的退出状态
$-  当前有效选项标志

`command`符号之间的内容为需要执行的命令
make -C /lib/modules/`uname -r`/build M=`pwd`

使用echo可以显示字符串,但是不能格式化字符串,可以使用printf实现
printf "format" arg1 arg2 ...

ln -s from to 把from链接到to上,所以to是from的符号链接

tree -d只显示目录
tree -L 2显示2级目录

字符串比较
s1  = s2    s1等于s2
s1 != s2    s1不等于s2
s1          s1不为空
-n s1       s1不为空
-z s1       s1为空
整数比较操作
-eq 等于
-ge 大于或等于
-gt 大于
-le 小于或等于
-lt 小于
-ne 不等于

[ "$x1" = 5 ]字符串比较
[ "$x1" -eq 5 ]整数比较

-a  逻辑与操作
-o  逻辑或操作

command1 && command2
则先执行command1,如果返回的退出状态为0,则执行command2;如果command1返回的退出状态非0,则跳过command2

command1 || command2
和上边的&&差不多,只是,仅仅当command1返回非0时,才执行command2

#!/bin/sh
append2=0
include_lib=1

if [ -f cscope_i ];then
   rm cscope_i
fi

for cscope_file in $*; do
if [ -f "$cscope_file" ] || [ -d "$cscope_file" ];then
#   if [ $cscope_file = '-a' ];then
#    append2=1
#    continue
#   fi
#
#   if [ $cscope_file = '-n' ];then
#    include_lib=0
#    continue
#   fi
  if [ "$append2" = "1" ];then
   find $cscope_file -maxdepth 1 -name '*.[cChH]' -o -name '*.[cC][pP][pP]'>>cscope_i
  else
   find $cscope_file  -name '*.[cChH]' -o -name '*.[cC][pP][pP]'>>cscope_i
  fi
else
  if [ $cscope_file = '-a' ];then
   append2=1
  elif [ $cscope_file = '-n' ];then
   include_lib=0
  else
   echo "Error: cannot read file $cscope_file"
  fi
fi
done

if [ -f cscope_i ];then
   if [ "$include_lib" = "1" ];then
       cscope -bi cscope_i
   else
       cscope -bki cscope_i
   fi
   rm cscope_i
fi

#----top--------------------------

top -c -d 30  -n 2 -b 

01:06:48    当前时间
up 1:22    系统运行时间, 格式为时:分
1 user    当前登录用户数
load average: 0.06, 0.60, 0.48    系统负载, 即任务队列的平均长度. 三个数值分别为 1分钟, 5分钟, 15分钟前到现在的平均值. 

total 进程总数
running 正在运行的进程数
sleeping 睡眠的进程数
stopped 停止的进程数
zombie 僵尸进程数
Cpu(s): 
0.3% us 用户空间占用CPU百分比
1.0% sy 内核空间占用CPU百分比
0.0% ni 用户进程空间内改变过优先级的进程占用CPU百分比
98.7% id 空闲CPU百分比
0.0% wa 等待输入输出的CPU时间百分比
0.0%hi: 硬件CPU中断占用百分比
0.0%si: 软中断占用百分比
0.0%st: 虚拟机占用百分比

Mem:
191272k total    物理内存总量
173656k used    使用的物理内存总量
17616k free    空闲内存总量
22052k buffers    用作内核缓存的内存量
Swap: 
192772k total    交换区总量
0k used    使用的交换区总量
192772k free    空闲交换区总量
123988k cached    缓冲的交换区总量,内存中的内容被换出到交换区, 而后又被换入到内存, 但使用过的交换区尚未被覆盖, 该数值即为这些内容已存在于内存中的交换区的大小,相应的内存再次被换出时可不必再对交换区写入. 

列名    含义
PID     进程id
PPID    父进程id
RUSER   Real user name
UID     进程所有者的用户id
USER    进程所有者的用户名
GROUP   进程所有者的组名
TTY     启动进程的终端名. 不是从终端启动的进程则显示为 ?
PR      优先级
NI      nice值. 负值表示高优先级, 正值表示低优先级
P       最后使用的CPU, 仅在多CPU环境下有意义
%CPU    上次更新到现在的CPU时间占用百分比
TIME    进程使用的CPU时间总计, 单位秒
TIME+   进程使用的CPU时间总计, 单位1/100秒
%MEM    进程使用的物理内存百分比
VIRT    进程使用的虚拟内存总量, 单位kb. VIRT=SWAP+RES
SWAP    进程使用的虚拟内存中, 被换出的大小, 单位kb. 
RES     进程使用的, 未被换出的物理内存大小, 单位kb. RES=CODE+DATA
CODE    可执行代码占用的物理内存大小, 单位kb
DATA    可执行代码以外的部分(数据段+栈)占用的物理内存大小, 单位kb
SHR     共享内存大小, 单位kb
nFLT    页面错误次数
nDRT    最后一次写入到现在, 被修改过的页面数. 
S       进程状态(D=不可中断的睡眠状态,I-空闲,R=运行,S=睡眠,T=跟踪/停止,Z-退出=僵尸进程,X-退出=即将销毁)
COMMAND 命令名/命令行
WCHAN   若该进程在睡眠, 则显示睡眠中的系统函数名
Flags   任务标志, 参考 sched.h

#----ps--------------------------

ps aux 
ps -elf

USER          进程所有者的用户名
PID           进程号
START         进程激活时间
%CPU          进程自最近一次刷新以来所占用的CPU时间和总时间的百分比
%MEM          进程使用内存的百分比
VSZ           进程使用的虚拟内存大小, 以K为单位
RSS           驻留空间的大小. 显示当前常驻内存的程序的K字节数. 
TTY           进程相关的终端
STAT          进程状态, 包括下面的状态: 
   D    不可中断     Uninterruptible sleep (usually IO)
   R    正在运行, 或在队列中的进程
   S    处于休眠状态
   T    停止或被追踪
   Z    僵尸进程
   W    进入内存交换(从内核2.6开始无效)
   X    死掉的进程
   <    高优先级
   N    低优先级
   L    有些页被锁进内存
   s    包含子进程
   \+   位于后台的进程组;
   l    多线程, 克隆线程

TIME          进程使用的总CPU时间
COMMAND       被执行的命令行
NI            进程的优先级值, 较小的数字意味着占用较少的CPU时间
PRI           进程优先级. 
PPID          父进程ID
WCHAN         进程等待的内核事件名

#----grep--------------------------

grep与正则表达式有关, 用来搜索文本文件中与指定正则表达式匹配的行, 并将结果送至标准输出. 

grep -inr XXX
grep -v grep 

grep [-abcEFGhHilLnqrsvVwxy][-A<显示列数>][-B<显示列数>][-C<显示列数>][-d<进行动作>][-e<范本样式>][-f<范本文件>][--help][范本样式][文件或目录...]

# 文本过滤工具,用于查找文件里符合条件的字符串

grep -i "hello world" -rl /home/tyrone | xargs grep -i "mailx"

grep -E "hello world|mailx" -r /home/tyrone

find /home/tyrone -name "*.txt" -exec grep -l "hello world" {} \; | xargs grep -i "mailx"

-a 或 --text : 不要忽略二进制的数据. 
-A<显示行数> 或 --after-context=<显示行数> : 除了显示符合范本样式的那一列之外, 并显示该行之后的内容. 
-b 或 --byte-offset : 在显示符合样式的那一行之前, 标示出该行第一个字符的编号. 
-B<显示行数> 或 --before-context=<显示行数> : 除了显示符合样式的那一行之外, 并显示该行之前的内容. 
-c 或 --count : 计算符合样式的列数. 
-C<显示行数> 或 --context=<显示行数>或-<显示行数> : 除了显示符合样式的那一行之外, 并显示该行之前后的内容. 
-d <动作> 或 --directories=<动作> : 当指定要查找的是目录而非文件时, 必须使用这项参数, 否则grep指令将回报信息并停止动作. 
-e<范本样式> 或 --regexp=<范本样式> : 指定字符串做为查找文件内容的样式. 
-E 或 --extended-regexp : 将样式为延伸的正则表达式来使用. 
-f<规则文件> 或 --file=<规则文件> : 指定规则文件, 其内容含有一个或多个规则样式, 让grep查找符合规则条件的文件内容, 格式为每行一个规则样式. 
-F 或 --fixed-regexp : 将样式视为固定字符串的列表. 
-G 或 --basic-regexp : 将样式视为普通的表示法来使用. 
-h 或 --no-filename : 在显示符合样式的那一行之前, 不标示该行所属的文件名称. 
-H 或 --with-filename : 在显示符合样式的那一行之前, 表示该行所属的文件名称. 
-i 或 --ignore-case : 忽略字符大小写的差别. 
-l 或 --file-with-matches : 列出文件内容符合指定的样式的文件名称. 
-L 或 --files-without-match : 列出文件内容不符合指定的样式的文件名称. 
-n 或 --line-number : 在显示符合样式的那一行之前, 标示出该行的列数编号. 
-o 或 --only-matching : 只显示匹配PATTERN 部分. 
-q 或 --quiet或--silent : 不显示任何信息. 
-r 或 --recursive : 此参数的效果和指定"-d recurse"参数相同. 
-s 或 --no-messages : 不显示错误信息. 
-v 或 --invert-match : 显示不包含匹配文本的所有行. 
-V 或 --version : 显示版本信息. 
-w 或 --word-regexp : 只显示全字符合的列. 
-x --line-regexp : 只显示全列符合的列. 
-y : 此参数的效果和指定"-i"参数相同. 

grep [options] PATTERN [files]  如果没有提供文件名, grep将搜索标准输入. 

options:选项参数
选项	功能描述
-c	输出匹配行的数目, 而不是输出匹配的行, 也可以用–count指定. 
-E	启用扩展正则表达式(Extend Regular Expression). 
-h	进行多文件搜索时, 抑制文件名输出. 也可以用–no-filename指定. 
-i	忽略大小写, 不区分大写和小写字符, 也可以用–ignore-case指定. 
-l	输出匹配项文件名而不是直接输出匹配行自身, 也可以用–files-with-matches指定. 
-v	对匹配模式取反, 即搜索不匹配行而不是匹配行, 也可以用–invert-match指定. 
-n	在每个匹配行面前加上改行在文件内的行号, 也可以用–line-number指定. 
PATTERN:正则表达式

常用特殊字符:
字符	含义
^	指向一行的开头
$	指向一行的结尾
.	任意单个字符
[ ]	方括号内包含一个字符范围, 其中任何一个字符都可以被匹配. 在方括号内加入 ^, 构成 [^ ab] 表示反向字符范围, 即不匹配指定范围内的字符;在方括号内加入连字符 -, 构成 [ a-z], 表示字符范围. 
特殊匹配模式:

匹配模式	含义
[:alnum:]	字母与数字字符
[:alpha:]	字母
[:ascii:]	ASCII字符
[:blank:]	空格或制表符
[:cntrl:]	ASCII控制字符
[:digit:]	数字
[:graph:]	非控制, 非空格字符
[:lower:]	小写字母
[:print:]	可打印字符
[:punct:]	标点符号字符
[:space:]	空白字符, 包括垂直制表符
[:upper:]	大写字母
[:xdigit:]	十六进制数字
扩展正则表达式字符:

字符	含义
?	匹配是可选的, 但最多一次. 即匹配某元素0次或一次. 
*	匹配某元素0次或多次
+	匹配某元素1次或多次
{n}	前面的元素恰好出现n次匹配
{n,m}	前面的元素出现的次数在n~m次之间则匹配,包括n和m
{n,}	前面的元素出现次数超过n次(包括n次)则匹配
{,m}	前面的元素出现次数不超过m次则匹配

注意区分通配符和正则表达式. 
因为find有-name pattern, 其中pattern是通配符模式
而grep [options] PATTERN, 其中PATTREN是正则表达式

正则表达式和通配符有本质区别:
正则表达式用来找:[文件]内容, 文本, 字符串. 一般三剑客grep(egrep), sed, awk支持
通配符用来找:文件名. 普通命令都支持
如何区分正则表达式和通配符:
不需要思考的判断方法:在grep(egrep), sed, awk中的都是正则表达式, 其他都是通配符

在[[ string=~ regex ]]中是正则表达式
文件目录名 ====> 通配符
文件内容(字符串, 文本, [文件]内容)====> 正则表达式

#----awk--------------------------

awk [选项参数] 'script' var=value file(s) 或 awk [选项参数] -f scriptfile var=value file(s)
# 文本分析工具

-F fs or --field-separator fs  #  指定输入文件折分隔符, fs是一个字符串或者是一个正则表达式, 如-F:. 
-v var=value or --asign var=value  #  赋值一个用户定义变量. 
-f scripfile or --file scriptfile  # 从脚本文件中读取awk命令. 
-mf nnn and -mr nnn  #  对nnn值设置内在限制, -mf选项限制分配给nnn的最大块数目 ;-mr选项限制记录的最大数目. 这两个功能是Bell实验室版awk的扩展功能, 在标准awk中不适用. 
-W compact or --compat, -W traditional or --traditional  # 在兼容模式下运行awk.  所以gawk的行为和标准的awk完全一样, 所有的awk扩展都被忽略. 
-W copyleft or --copyleft, -W copyright or --copyright  #  打印简短的版权信息. 
-W help or --help, -W usage or --usage  # 打印全部awk选项和每个选项的简短说明. 
-W lint or --lint # 打印不能向传统unix平台移植的结构的警告. 
-W lint-old or --lint-old  # 打印关于不能向传统unix平台移植的结构的警告. 
-W posix  #  打开兼容模式. 但有以下限制, 不识别:/x, 函数关键字, func, 换码序列以及当fs是一个空格时,  将新行作为一个域分隔符;操作符**和**=不能代替^和^=;fflush无效. 
-W re-interval or --re-inerval  # 允许间隔正则表达式的使用, 参考(grep中的Posix字符类), 如括号表达式[[:alpha:]]. 
-W source program-text or --source program-text # 使用program-text作为源代码, 可与-f命令混用. 
-W version or --version # 打印bug报告信息的版本. 

#----sed--------------------------

sed [-hnV][-e<script>][-f<script文件>][文本文件]
# 利用脚本来处理文本文件

-e<script>或--expression=<script> #  以选项中指定的script来处理输入的文本文件. 
-f<script文件>或--file=<script文件> # 以选项中指定的script文件来处理输入的文本文件. 
-i # 直接修改文件内容(危险操作)
-h或--help # 显示帮助. 
-n或--quiet或--silent # 仅显示script处理后的结果. 
-V或--version # 显示版本信息. 

a # 新增,  a 的后面可以接字串, 而这些字串会在新的一行出现(目前的下一行)～
c # 取代,  c 的后面可以接字串, 这些字串可以取代 n1,n2 之间的行!
d # 删除, 因为是删除啊, 所以 d 后面通常不接任何咚咚;
i # 插入,  i 的后面可以接字串, 而这些字串会在新的一行出现(目前的上一行);
p # 打印, 亦即将某个选择的数据印出. 通常 p 会与参数 sed -n 一起运行～
s # 取代, 可以直接进行取代的工作哩!通常这个 s 的动作可以搭配正规表示法!例如 1,20s/old/new/g 就是啦!

sed -in  's/青/蜀/g' text.txt  

#!/bin/bash

# echo $1

# 全角转半角 双字节字符转单字节 full2half
sed -i 's/:/:/g' $1
sed -i 's/;/;/g' $1
sed -i 's/!/!/g' $1
sed -i 's/. /. /g' $1
sed -i 's/, /, /g' $1
sed -i 's/?/?/g' $1
sed -i 's/%/%/g' $1
sed -i 's/(/(/g' $1
sed -i 's/)/)/g' $1
sed -i 's/</</g' $1
sed -i 's/>/>/g' $1
sed -i 's/[/[/g' $1
sed -i 's/]/]/g' $1
sed -i 's/ / /g' $1
sed -i "s/'/'/g" $1

# 删除 行尾空格 制表符
sed -i 's/[ \t]*$//g'

# 删除 行首空格?sed -i 's/^[ \t]*//g'

# 多个空行合并单个空行
sed -rni 'h;n;:a;H;n;$!ba;g;s/(\n){2,}/\n\n/g;p' input

sed -i '$a sudo service cron start' /home/codespace/.bashrc # 每次启动终端时, 启动cron
sed -i '$a export ALIYUNPAN_CONFIG_DIR=/workspaces/jupyter/settings/aliyunpan/config' /home/codespace/.bashrc # 

#*/5 * * * * COLUMNS=9999 /usr/bin/top -c -d 30  -n 2 -b  | sed 's/  *$//' >> /root/FIL/strategy/multiple/top.log

sudo sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list  # 官方源换阿里云源

#----date--------------------

# 在Linux环境中, 不管是编程还是其他维护, 时间是必不可少的, 也经常会用到时间的运算, 熟练运用date命令来表示自己想要表示的时间, 肯定可以给自己的工作带来诸多的方便. 
# 1. 命令格式:
date [参数] [+格式]
# 2. 命令功能:
# date 可以用来显示或设定系统的日期与时间. 

# 备注:在脚本中需要用``把内容封装起来, 在shell命令行下可以直接输出

date --h # 查看使用方式
date [选项]... [+格式]
date [-u|--utc|--universal] [MMDDhhmm[[CC]YY][.ss]]
# 以给定的格式显示当前时间, 或是设置系统日期. 

-d,--date=字符串  显示指定字符串所描述的时间, 而非当前时间
-d<字符串> 显示字符串所指的日期与时间. 字符串前后必须加上双引号. 
-f,--file=日期文件        类似--date, 从日期文件中按行读入时间描述
-r, --reference=文件        显示文件指定文件的最后修改时间
-R, --rfc-2822        以RFC 2822格式输出日期和时间
			例如:2006年8月7日, 星期一 12:34:56 -0600
	--rfc-3339=TIMESPEC    以RFC 3339 格式输出日期和时间. 
			TIMESPEC='date', 'seconds', 或 'ns' 
			表示日期和时间的显示精度. 
			日期和时间单元由单个的空格分开:
			2006-08-07 12:34:56-06:00
-s, --set=字符串  设置指定字符串来分开时间
-s<字符串> 根据字符串来设置日期与时间. 字符串前后必须加上双引号. 
-u, --utc, --universal    输出或者设置协调的通用时间
--help        显示此帮助信息并退出
--version        显示版本信息并退出
-u 显示GMT(Greenwich Mean Time, 格林威治时间). 

# 3.命令参数:
# 必要参数:
%%    一个文字的 %
%H 小时(以00-23来表示). 
%I 小时(以00-12来表示). 
%K 小时(以0-23来表示). 
%l 小时(以0-12来表示). 
%M 分钟(以00-59来表示).   minute=$(((10 + 10#$minute)%10))
%P am或pm. 
%s 总秒数(起算时间为1970-01-01 00:00:00 UTC). UTC(coordinated Universal Time协调时间, 又称世界统一时间),自UTC 时间 1970-01-01 00:00:00 以来所经过的秒数  
%S 秒(以本地惯用法来表示),秒(00-60)  
%T 时间(含时分秒, 小时以24小时制来表示). 时间, 等于%H:%M:%S 
%X 时间(以本地的惯用法来表示)
%Z 市区(CST China Standard Time, 中国标准时间) , 按字母表排序的时区缩写 (例如, EDT)
%a  当前locale 的星期名缩写(例如: 日, 代表星期日)  
%A  当前locale 的星期名全称 (如:星期日)  
%b  当前locale 的月名缩写 (如:一, 代表一月)  
%B  当前locale 的月名全称 (如:一月)  
%c  当前locale 的日期和时间 (如:2005年3月3日 星期四 23:05:25) 日期与时间. 只输入date指令显示同样结果. 
%C  世纪;比如 
%d 日期(以0-31来表示). 
%D 日期(含年月日).  等于%m/%d/%y
%e  按月计的日期, 添加空格, 等于%_d  
%F  完整日期格式, 等价于 %Y-%m-%d  
%g  ISO-8601 格式年份的最后两位 (参见%G)  
%G  ISO-8601 格式年份 (参见%V), 一般只和 %V 结合使用  
%h  等于%b  
%j 该年中的第几天. 按年计的日期(001-366) 
%m 月份(以0-12来表示). 
%n 在显示时, 插入新的一行. 换行 
%N 纳秒(000000000-999999999)
%P 与%p 类似, 但是输出小写字母  
%q 季度 curr_quarter=$((`date +%_m`/3+1)) 
%r 时间(含时分秒, 小时以12小时AM/PM来表示). 当前locale 下的 12 小时时钟时间 (如:11:11:04 下午)
%R  24 小时时间的时和分, 等价于 %H:%M  
%u  星期, 1 代表星期一  
%U  该年中的周数. 一年中的第几周, 以周日为每星期第一天(00-53)  
%V  ISO-8601 格式规范下的一年中第几周, 以周一为每星期第一天(01-53)  
%w  该周的天数, 0代表周日, 1代表周一, 依次类推. 一星期中的第几日(0-6), 0 代表周一  
%W  一年中的第几周, 以周一为每星期第一天(00-53)  
%x  当前locale 下的日期描述 (如:12/31/99) ,日期(以本地的惯用法来表示) 
%X  当前locale 下的时间描述 (如:23:13:48)  
%y 年份(以00-99来表示). 年份最后两位数位 (00-99)
%Y 年份(以四位数来表示). 

%t 在显示时, 插入tab.  输出制表符 Tab  
MM 月份(必要)
DD 日期(必要)
hh 小时(必要)
mm 分钟(必要)
ss 秒(选择性)
%z +hhmm        数字时区(例如, -0400)  
%:z +hh:mm      数字时区(例如, -04:00)  
%::z +hh:mm:ss  数字时区(例如, -04:00:00)  
%:::z           数字时区带有必要的精度 (例如, -04, +05:30)   

# 4. 使用说明:
# 1. 在显示方面, 自己去实验, 看结果吧. 
# 2. 在设定时间方面:
date -s # 设置当前时间, 只有root权限才能设置, 其他只能查看. 
date -s 20111213 # 设置成20111213, 这样会把具体时间设置成空00:00:00. 
date -s 01:01:01 # 设置具体时间, 不会对日期做更改. 
date -s '01:01:01 2011-12-13' # 这样可以设置全部时间. 
date -s '2011-12-13 01:01:01' # 这样可以设置全部时间. 
date -s '20111213 01:01:01' # 这样可以设置全部时间
date -s '01:01:01 20111213' # 这样可以设置全部时间
# 3. 加减
date +%Y%m%d # 显示前天年月日
date +%Y%m%d --date="-1 day" # 显示前一天的日期
date +%Y%m%d --date="+1 day" # 显示后一天的日期
date +%Y%m%d --date="+/-1 month" # 显示下/上一个月的日期
date +%Y%m%d --date="+/-1 year" # 显示下/上一年的日期

date -d 'now'    #显示当前时间
# Fri Feb  2 09:29:28 CST 2018
date -d '2 days ago'    #显示2天前的时间
# Wed Jan 31 09:29:40 CST 2018
date -d '3 month 1 day'    #显示3月零1天以后的时间 
# Thu May  3 09:30:16 CST 2018
date -d '25 Dec' +%j    #显示12月25日在当年的哪一天
# 359
date -d '30 second ago'    #显示30秒前的时间
# Fri Feb  2 09:41:03 CST 2018

##在当前时间的基础上往前或往后推
date -d "+3 day"
# Mon Feb  5 09:45:52 CST 2018
date -d "-3 day" 
# Tue Jan 30 09:46:04 CST 2018
date -d "-3 month"
# Thu Nov  2 09:46:16 CST 2017
date -d "+3 month" 
# Wed May  2 09:46:24 CST 2018
date -d "+3 year" 
# Tue Feb  2 09:46:35 CST 2021
date -d "-3 year" 
# Mon Feb  2 09:46:40 CST 2015
date -d "-3 hour" 
# Fri Feb  2 06:46:59 CST 2018
date -d "+3 hour" 
# Fri Feb  2 12:47:02 CST 2018
date -d "+3 minute"
# Fri Feb  2 09:50:09 CST 2018
date -d "-3 minute" 
# Fri Feb  2 09:44:12 CST 2018
date -d "-3 second"
# Fri Feb  2 09:47:21 CST 2018
date -d "+3 second" 
# Fri Feb  2 09:47:31 CST 2018

#显示本月的第一天
date -d `date +%y%m01`
Thu Feb  1 00:00:00 CST 2018
date +%y%m01
180201
date +%Y%m01
20180201

#上个月最后一天
date -d `date +%y%m01`"-1 day"
Wed Jan 31 00:00:00 CST 2018
#4个月前的最后一天
date -d `date -d "-3 month" +%y%m01`"-1 day"
Tue Oct 31 00:00:00 CST 2017
#11个月后的第一天
date -d `date -d "+12 month" +%y%m01`"-1 day"
Thu Jan 31 00:00:00 CST 2019
#11个月后的最后一天
date -d `date -d "+12 month" +%y%m01`"-1 day" +%Y%m%d
20190131

#显示当前的日期和时间
date +%Y%m%d
20180202
date +%Y%m%d%H%M%S
20180202101334
#设置日期和时间(date后面的数字代表月日时分年, 还可以加秒, 需要后面跟英文状态下的句号字符".")

date +%m%d%H%M%y
0202102418
date 0202102418
date: cannot set date: Operation not permitted
Fri Feb  2 10:24:00 CST 2018
date +%m%d%H%M%y.%S
0202102518.11
date 0202102518.11
date: cannot set date: Operation not permitted
Fri Feb  2 10:25:11 CST 2018

date `date -d "3 days ago" +%m%d%H%M%Y.%S`
date: cannot set date: Operation not permitted
Tue Jan 30 10:26:27 CST 2018
date `date -d "$((3600*24)) seconds ago" +%m%d%H%M%Y.%S`
date: cannot set date: Operation not permitted
Thu Feb  1 10:27:10 CST 2018

#----test--------------------

test命令用于检查一个条件是否成立, 它可以进行数值, 字符, 文件三个方面的测验;

1, 数值测试:

等号左侧与等号右侧相比:

参数	说明
-eq	等于则为真
-ne	不等于则为真
-gt	大于则为真
-ge	大于等于则为真
-lt	小于则为真
-le	小于等于则为真

例子:

num1=10
num2=10
if test $num1 = $num2
then
	echo "两个数相等"
else
	echo "两个数不相等"
fi

输出:
两个数相等
使用变量时可以加[], 可以加{}, 也可以什么都不加;

当要进行数值运算时, 要加[]

result=$[num1+num2]

echo $result

输出:

20
2, 字符测试:

参数	说明
=	等于则为真
!=	不相等则为真
-z 字符串	字符串的长度为零则为真
-n 字符串	字符串的长度不为零则为真
例子:

num1=abc
num2=abc
if test ${num1} = ${num2}
then
	echo "两个字符串相同"
else
	echo "两个字符串不相同"
fi

输出:

两个字符串相同
不使用test命令:

num1=abc
num2=abc

#[ $num1 == $num2 ] 中括号与变量之间要加空格
if [ $num1 == $num2 ]
then
	echo "两个字符串相同"
else
	echo "两个字符串不相同"
fi

输出:

两个字符串相同
3, 文件测试:

参数	说明
-e 文件名	如果文件存在则为真
-r 文件名	如果文件存在且可读则为真
-w 文件名	如果文件存在且可写则为真
-x 文件名	如果文件存在且可执行则为真
-s 文件名	如果文件存在且至少有一个字符则为真
-d 文件名	如果文件存在且为目录则为真
-f 文件名	如果文件存在且为普通文件则为真
-c 文件名	如果文件存在且为字符型特殊文件则为真
-b 文件名	如果文件存在且为块特殊文件则为真
例子:

cd /bin
if test -e ./bash
then
   echo '文件已存在!'
else
   echo '文件不存在!'
fi

输出:
文件已存在!

另外, Shell 还提供了与( -a ), 或( -o ), 非( ! )三个逻辑操作符用于将测试条件连接起来, 其优先级为: ! 最高,  -a 次之,  -o 最低. 例如:

cd /bin
if test -e ./nullFile -o -e ./bash
then
   echo '至少有一个文件存在!'
else
   echo '两个文件都不存在'
fi
输出结果:
至少有一个文件存在!

1.对文件类型的检测
-e:判断文件/目录是否存在, 存在为0(真), 否则为非0(假)
简单演示, 如果一个文件(目录)存在, 返回0

[root@blog ~]# test -e /tmp/
[root@blog ~]# echo $?
0
如果一个文件(目录)不存在, 返回非0, 比如我这里返回为1, 说明该文件(目录)不存在. 

[root@blog ~]# test -e /aabbcc1232432432
[root@blog ~]# echo $?
1
补充前两个参数, 可以更具体的判断文件或文件夹是否存在

-f:判断该[文件名]是否为文件
-d:判断该[文件名]是否为目录
-b:判断该[文件名]是否为block device
-c:判断该[文件名]是否为character device
-S:判断该[文件名]是否为socket device
-P:判断该[文件名]是否为FIFO(pipe)文件
-L:判断该[文件名]是否为连结档
2.对文件权限的侦测
如:test -r file1
比如判断一个文件是否具有可读, 可写之类的检测方法:

-r:判断该[文件名]是否具有可读属性
-w:判断该[文件名]是否具有可写属性
-x:判断该[文件名]是否具有可执行属性
-u:判断该[文件名]是否具有suid属性
-g:判断该[文件名]是否具有sgid属性
-k:判断该[文件名]是否具有Sticky bit属性
-s:判断该[文件名]是否为非空白文件
3.两个文件之前的比较
如:test file1 -nt file2
比如判断两个文件之间的新旧关系, 也可以使用test命令来实现. 

-nt:(newer than)判断file1 是否比 file2 新
-ot:(older than)判断file1 是否比 file2 旧
-ef:判断file1和file2是否为同一文件, 主要用于判断文件是否指向同一个inode
4.两个整数之间的判断
test n1 -eq n2
test还可用于两个整数之间的判断. 

-eq:判断两数值相等(equal)
-ne:判断两数值不相等(noe equal)
-gt:n1 大于 n2(greater than)
-lt:n1 小于 n2(less than)
-ge:n1 大于等于 n2(greater than or equal)
-le:n1 小于等于 n2(less than or equal)
5.判断字符串的数据
test -z string 判定字符串是否为0?若为空字符串, 则为true
test -n string 判定字符串是否为非0?若为空字符串, 则为false
test str1 = str2 判定字符串 str1 是否等于 str2,若相等, 则回传true
test str1 != str2 判定字符串 str1 是否不等于 str2,若相等, 则回传false
6.多重条件判断
-a (and) 两种条件同时成立!
# file同时具有r和x的权限, 才回传true
test -r file -a -x file
-o (or) 两状况任何一个成立!
# file具有r或x权限时, 才回传true
test -r file -o -x file
! 反相状态
# 当file不具有x时, 回传true
test ! -x file

[] 可以执行基本的算数运算
#!/bin/bash
# filename: demo.sh
# author:简单编程
# url:www.twle.cn

a=7
b=17

result=$[a+b] # 注意等号两边不能有空格
echo "result 为: $result"
结果为:
result 为: 24

#----流程控制循环--------------------

if condition; then
   # 符合 condition 的执行语句
fi

if condition_1
then
   # 符合 condition_1 的执行语句
elif condition_2
then
   # 符合 condition_2 的执行语句
else 
   # 不符合 condition_1 和 condition_2 的执行语句
fi

# if的基本语法
# 1.if与[之间要有空格
# 2.[]与判断条件之间也必须有空格
# 3.]与;之间不能有空格

# 逻辑判断
if [ ! 表达式 ] # 逻辑非 !                   条件表达式的相反
if [ ! -d $num ] # 如果不存在目录$num
if [ exp1 –a exp2 ]  # 逻辑与 –a 条件表达式的并列
if [ exp1 –o exp2 ] # 逻辑或 -o  条件表达式的或

# 文件表达式
if [ -f file ] # file 如果文件存在 为真
if [ -d … ] # directory如果目录存在
if [ -s file ] # size 如果文件存在且非空 文件大小为非0为真

-r file # read 用户可读为真
-w file # write 用户可写为真
-x file # exec 用户可执行为真
-c file #文件存在且为字符设备文件
-b file #文件存在且为块设备文件
-e file #exist 如果文件存在为真
-L filename # link 判断文件是否问链接文件
-h filename # hard link 判断文件是否为硬链接文件
filename1 -nt filename2 # newer than 判断文件1是否比文件2新
filename1 -ot filename2 # older than 判断文件1是否比文件2旧 

# 整数变量表达式
if [ int1 -eq int2 ] # -eq 等于 如果int1等于int2
if [ int1 -ne int2 ] # -ne 不等于 如果不等于
if [ int1 -ge int2 ] # -ge 大于等于 如果>=
if [ int1 -gt int2 ] # -gt 大于 如果>
if [ int1 -le int2 ] # -le 小于等于 如果<=
if [ int1 -lt int2 ] # -lt 小于 如果<

# 字符串变量表达式
If [ $a = $b ] #  如果string1等于string2 
# 字符串允许使用赋值号做等号
if [ $string1 != $string2 ] #  如果string1不等于string2
if [ -n $string ] #  如果string 非空(非0), 返回0(true)
if [ -z $string ]  # 如果string 为空
if [ $sting ]  # 如果string 非空, 返回0 (和-n类似)

# shell中条件判断if中的-z到-d的意思
[ -a FILE ]  # 如果 FILE 存在则为真. 
[ -b FILE ]  # 如果 FILE 存在且是一个块特殊文件则为真. 
[ -c FILE ]  # 如果 FILE 存在且是一个字特殊文件则为真. 
[ -d FILE ]  # 如果 FILE 存在且是一个目录则为真. 
[ -e FILE ]  # 如果 FILE 存在则为真. 
[ -f FILE ]  # 如果 FILE 存在且是一个普通文件则为真. 
[ -g FILE ]  # 如果 FILE 存在且已经设置了SGID则为真. 
[ -h FILE ]  # 如果 FILE 存在且是一个符号连接则为真. 
[ -k FILE ]  # 如果 FILE 存在且已经设置了粘制位则为真.  
[ -p FILE ]  # 如果 FILE 存在且是一个名字管道(F如果O)则为真. 
[ -r FILE ]  # 如果 FILE 存在且是可读的则为真. 
[ -s FILE ]  # 如果 FILE 存在且大小不为0则为真. 
[ -t FD ]  # 如果文件描述符 FD 开且指向一个终端则为真. 
[ -u FILE ] #  如果 FILE 存在且设置了SUID (set user ID)则为真. 
[ -w FILE ]  # 如果 FILE 如果 FILE存在且是可写的则为真. 
[ -x FILE ]  # 如果 FILE 存在且是可执行的则为真. 
[ -O FILE ]  # 如果 FILE 存在且属有效用户ID则为真. 
[ -G FILE ]  # 如果 FILE 存在且属有效用户组则为真.  
[ -L FILE ]  # 如果 FILE 存在且是一个符号连接则为真. 
[ -N FILE ]  # 如果 FILE 存在 and has been mod如果ied since it was last read则为真. 
[ -S FILE ]  # 如果 FILE 存在且是一个套接字则为真. 
[ FILE1 -nt FILE2 ] #  如果 FILE1 has been changed more recently than FILE2,or 如果 FILE1 exists and FILE2 does not则为真. 
[ FILE1 -ot FILE2 ]  # 如果 FILE1 比 FILE2 要老, 或者 FILE2 存在且 FILE1 不存在则为真. 
[ FILE1 -ef FILE2 ]  # 如果 FILE1 和 FILE2 指向相同的设备和节点号则为真. 
[ -o OPTIONNAME ]  # 如果 shell选项 'OPTIONNAME' 开启则为真. 
[ -z STRING ]  # 'STRING' 的长度为零则为真. 

1 单分支if判断
# 表达式两端必须有空格
# 格式1
if第一种书写方式
	if [ 表达式 ];then
		执行的命令
	fi

# 格式2
if第一种书写方式
	if [ 表达式 ]
	then
		执行的命令
	fi
[root@shell /server/scripts]# cat test_if.sh
#!/bin/bash
if [ -f /etc/passwd ];then
   echo "密码文件存在!"
fi

if [ -d /etc ]
then
   echo "etc目录存在!"
fi
2 双分支if判断
# 格式
if [ 表达式 ];then
   执行的命令
else
	执行的命令
fi
if [ -f /etc/hosts ];then
	echo "文件存在!"
	else
	  echo "文件不存在!"
	fi
3 多分支if判断
if [ 如果你有钱 ];then
	    我就嫁给你
elif [ 如果你有房子 ];then
	    我就嫁给你
elif [ 你有车 ];then
	    先谈朋友
elif [ 如果你月入五万 ];then
	    我们先谈朋友
else	# 以上都不成立
	   拜拜了
fi
# 判断两个数的大小
[root@shell /server/scripts]# cat if.sh 
#!/bin/bash
if [ $# -ne 2 ];then
	echo "请输入2个整数!"
	exit 4
else
	if [[ "$1" =~ ^[0-9]+$ && "$2" =~ ^[0-9]+$ ]];then
		if [ $1 -eq $2 ];then
			echo "$1 = $2"
		elif [ $1 -lt $2 ];then
			echo "$1 < $2"
		else
			echo "$1 > $2"
		fi
	else
		echo "请输入2个整数啊, 沙雕!"
		exit 8
	fi
fi
4 while循环
# 格式
while true
do
   执行的命令
done
# 随机数大小判断
[root@shell /server/scripts]# cat ran.sh 
#!/bin/sh
ran=`echo $((RANDOM%100+1))`
while true
do
let i++
read -p "请输入你要猜的数字[1-100]: " num
if [ $num -gt $ran ];then
	 echo "你输入的数字 $num 大了"
elif [ $num -lt $ran ];then
	 echo "你输入的数字 $num 小了"
else
	 echo "恭喜你答对了随机数为$ran"
	 echo "总共猜了$i 次"
	 exit
fi
done
5 for循环
# 格式
for i in `seq 10` #数字|字符串|`命令`
do
   执行命令
done
# 批量创建用户名
[root@shell /server/scripts]# cat add_user.sh 
#!/bin/sh
read -p "请输入用户的前缀名称: " prefix
read -p "请输入要创建多少个:"   num
for i in `seq $num`
do
	 echo ${prefix}_${i}
done
6 case判断
# 格式
case 变量 可以是直接传参 赋值 read读入
case 变量  in
		   模式1)
			    命令序列
				;;
			模式2)
			    命令序列
				;;
			模式3)
			    命令序列
				;;
			 *)
			    无匹配后命令序列
   esac
# 根据屏幕输出安装对应软件
[root@shell /server/scripts]# cat case.sh 
#!/bin/sh
cat<<EOF
				1.NFS
				2.MySQL
				3.Redis
				4.DOCKER
				5.KVM
				6.退出脚本
EOF
while true
do
read -p "请输入你想要安装的服务编号或者服务名称: " num
case $num in
		1)
			echo "yum -y instll NFS........"
			;;
		2)
			echo "yum -y install MySQL......"
			;;
		3)
			echo "yum -y install Redis......."
			;;
		6)
			exit
			;;
		   *)
			echo "USAGE: $0 read -p [NFS|MySQL|Redis|DOCKER|KVM]"
esac
done
# 自定义nginx启动脚本
[root@shell /server/scripts]# cat nginx.sh 
#!/bin/bash
[ -f /etc/init.d/functions ] && . /etc/init.d/functions

ACTION=$1
NG_STATE=$(netstat -lntup|grep nginx|wc -l)
LISTEN_PORT=$(netstat -lntup|grep nginx|awk '{print $4}'|awk -F: '{print $2}'|xargs)

#TEST STATUS
TEST(){
	if [ $? -eq 0 ];then
		action "${ACTION} nginx" /bin/true
	else
		action "${ACTION} nginx" /bin/false
	fi
}

#START NGINX
START(){
	if [ ${NG_STATE} -ne 0 ];then
		echo "Nginx is Running,You need to do nothing."
		exit
	else
		/usr/sbin/nginx -t &>/dev/null
		if [ $? -eq 0 ];then
			/usr/sbin/nginx
			[ $? -eq 0 ] && TEST
		else
			/usr/sbin/nginx -t
		fi
	fi
}

STOP(){
	/usr/sbin/nginx -s stop
	[ $? -eq 0 ] && TEST
}

RELOAD(){
	if [ ${NG_STATE} -ne 0 ];then
		/usr/sbin/nginx -s reload
		[ $? -eq 0 ] && TEST
	else
		echo "No Process is running."
	fi
}

RESTART(){
	if [ ${NG_STATE} -ne 0 ];then
		/usr/sbin/nginx -s stop
		[ $? -eq 0 ] && sleep 1
		/usr/sbin/nginx
		[ $? -eq 0 ] && TEST
	else
		echo "No Process is running."
	fi
}

STATUS(){
	if [ ${NG_STATE} -ne 0 ];then
		echo "Nginx is Running and Listening Port are ${LISTEN_PORT}."	
	else
		echo "Nginx is dead."
	fi
}

case ${ACTION} in 
	start)
		START
		;;
	restart)
		RESTART
		;;
	reload)
		RELOAD
		;;
	stop)
		STOP
		;;
	status)
		STATUS
		;;
	*)
		echo "Usage $0 {start|stop|restart|reload|status}"
esac

循环
循环是当循环控制条件为真时, 一系列命令迭代执行的代码块

for 循环
for arg in [list]
这是 shell 中最基本的循环结构, 它与C语言形式的循环有着明显的不同

for arg in [list]
do
 command(s)...
done
在循环的过程中, arg 会从 list 中连续获得每一个变量的值

for arg in "$var1" "$var2" "$var3" ... "$varN"
# 第一次循环中, arg = $var1
# 第二次循环中, arg = $var2
# 第三次循环中, arg = $var3
# ...
# 第 N 次循环中, arg = $varN

# 为了防止可能的字符分割问题, [list] 中的参数都需要被引用. 
参数 list 中允许含有通配符

如果 do 和 for 写在同一行时, 需要在 list 之后加上一个分号

for arg in [list] ; do

样例-1. 简单的 for 循环

#!/bin/bash
# 列出太阳系的所有行星. 

for planet in Mercury Venus Earth Mars Jupiter Saturn Uranus Neptune Pluto
do
 echo $planet  # 每一行输出一个行星. 
done

echo; echo

for planet in "Mercury Venus Earth Mars Jupiter Saturn Uranus Neptune Pluto"
   # 所有的行星都输出在一行上. 
   # 整个 'list' 被包裹在引号中时是作为一个单一的变量. 
   # 为什么?因为空格也是变量的一部分. 
do
 echo $planet
done

echo; echo "Whoops! Pluto is no longer a planet!"

exit 0
list中的每一个元素中都可能含有多个参数. 这在处理参数组中非常有用. 在这种情况下, 使用set命令强制解析 list 中的每一个元素, 并将元素的每一个部分分配给位置参数

样例-2. for 循环 [list] 中的每一个变量有两个参数的情况

#!/bin/bash
# 让行星再躺次枪. 

# 将每个行星与其到太阳的距离放在一起. 

for planet in "Mercury 36" "Venus 67" "Earth 93" "Mars 142" "Jupiter 483"
do
 set -- $planet  #  解析变量 "planet"
                 #+ 并将其每个部分赋值给位置参数. 
 # "--" 防止一些极端情况, 比如 $planet 为空或者以破折号开头. 

 # 因为位置参数会被覆盖掉, 因此需要先保存原先的位置参数. 
 # 你可以使用数组来保存
 #         original_params=("$@")

 echo "$1        $2,000,000 miles from the sum"
 #-------两个制表符---将后面的一系列 0 连到参数 $2 上. 
done

exit 0
一个单一变量也可以成为 for 循环中的 list
样例-3. 文件信息:查看一个单一变量中含有的文件列表的文件信息

#!/bin/bash
# fileinfo.sh

FILES="/usr/sbin/accept
/usr/sbin/pwck
/usr/sbin/chroot
/usr/bin/fakefile
/sbin/badblocks
/sbin/ypbind"     # 你可能会感兴趣的一系列文件. 
                 # 包含一个不存在的文件, /usr/bin/fakefile. 

echo

for file in $FILES
do

 if [ ! -e "$file" ]       # 检查文件是否存在. 
 then
   echo "$file does not exist."; echo
   continue                # 继续判断下一个文件. 
 fi

 ls -l $file | awk '{ print $8 "         file size: " $5 }'  # 输出其中的两个域. 
 whatis `basename $file`   # 文件信息. 
 # 脚本正常运行需要注意提前设置好 whatis 的数据. 
 # 使用 root 权限运行 /usr/bin/makewhatis 可以完成. 
 echo
done

exit 0
for 循环中的 list 可以是一个参数

样例-4. 操作含有一系列文件的参数

#!/bin/bash

filename="*txt"

for file in $filename
do
echo "Contents of $file"
echo "---"
cat "$file"
echo
done
如果在匹配文件扩展名的 for 循环中的 [list] 含有通配符(* 和 ?), 那么将会进行文件名扩展

样例-5. 在 for 循环中操作文件

#!/bin/bash
# list-glob.sh: 通过文件名扩展在 for 循环中产生 [list]. 
# 通配 = 文件名扩展. 

echo

for file in *
#           ^  Bash 在检测到通配表达式时, 
#+             会进行文件名扩展. 
do
 ls -l "$file"  # 列出 $PWD(当前工作目录)下的所有文件. 
 #  回忆一下, 通配符 "*" 会匹配所有的文件名, 
 #+ 但是, 在文件名扩展中, 他将不会匹配以点开头的文件. 

 #  如果没有匹配到文件, 那么它将会扩展为它自身. 
 #  为了防止出现这种情况, 需要设置 nullglob 选项. 
 #+    (shopt -s nullglob)
done

echo; echo

for file in [jx]*
do
 rm -f $file    # 删除当前目录下所有以 "j" 或 "x" 开头的文件. 
 echo "Removed file \"$file\"".
done

echo

exit 0
如果在 for 循环中省略 in [list] 部分, 那么循环将会遍历位置参数($@

样例-6. 缺少 in [list] 的 for 循环

#!/bin/bash

# 尝试在带参数和不带参数两种情况下调用这个脚本, 观察发生了什么. 

for a
do
echo -n "$a "
done

#  缺失 'in list' 的情况下, 循环会遍历 '$@'
#+(命令行参数列表, 包括空格). 

echo

exit 0
可以在 for 循环中使用 命令代换 生成 list

样例-7. 在 for 循环中使用命令代换生成 list

#!/bin/bash
# for-loopcmd.sh: 带命令代换所生成 [list] 的 for 循环

NUMBERS="9 7 3 8 37.53"

for number in `echo $NUMBERS`  # for number in 9 7 3 8 37.53
do
 echo -n "$number "
done

echo
exit 0
下面是使用命令代换生成 list 的更加复杂的例子

样例-8. 一种替代 grep 搜索二进制文件的方法

#!/bin/bash
# bin-grep.sh: 在二进制文件中定位匹配的字符串. 

# 一种替代 `grep` 搜索二进制文件的方法
# 与 "grep -a" 的效果类似

E_BADARGS=65
E_NOFILE=66

if [ $# -ne 2 ]
then
 echo "Usage: `basename $0` search_string filename"
 exit $E_BADARGS
fi

if [ ! -f "$2" ]
then
 echo "File \"$2\" does not exist."
 exit $E_NOFILE
fi

IFS=$'\012'       # 按照 Anton Filippov 的意见应该是
                 # IFS="\n"
for word in $( strings "$2" | grep "$1" )
# "strings" 命令列出二进制文件中的所有字符串. 
# 将结果通过管道输出到 "grep" 中, 检查是不是匹配的字符串. 
do
 echo $word
done

#    可以换成下面的形式:
#    strings "$2" | grep "$1" | tr -s "$IFS" '[\n*]'

# 尝试运行脚本 "./bin-grep.sh mem /bin/ls"

exit 0
下面的例子同样展示了如何使用命令代换生成 list

样例-9. 列出系统中的所有用户

#!/bin/bash
# userlist.sh

PASSWORD_FILE=/etc/passwd
n=1           # 用户数量

for name in $(awk 'BEGIN{fs=":"}{print $1}' < "$PASSWORD_FILE" )
# 分隔符 = :              ^^^^^^
# 输出第一个域                    ^^^^^^^^
# 读取密码文件 /etc/passwd                    ^^^^^^^^^^^^^^^^^
do
 echo "USER #$n = $name"
 let "n += 1"
done

# USER #1 = root
# USER #2 = bin
# USER #3 = daemon
# ...
# USER #33 = bozo

exit $?

# 讨论:
# -----
# 一个普通用户是如何读取 /etc/passwd 文件的?
# 提示:检查 /etc/passwd 的文件权限. 
# 这算不算是一个安全漏洞?为什么?
另外一个关于 [list] 的例子也来自于命令代换

样例-10. 检查目录中所有二进制文件

#!/bin/bash
# findstring.sh
# 在指定目录的二进制文件中寻找指定的字符串. 

directory=/usr/bin
fstring="Free Software Foundation"  # 查看哪些文件来自于 FSF. 

for file in $( find $directory -type f -name '*' | sort )
do
 strings -f $file | grep "$fstring" | sed -e "s%$driectory%%"
 #  在 "sed" 表达式中, 你需要替换掉 "/" 分隔符, 
 #+ 因为 "/" 是一个会被过滤的字符. 
 #  如果不做替换, 将会产生一个错误. (你可以尝试一下. )
done

exit $?

# 简单的练习:
# ----------
# 修改脚本, 使其可以从命令行参数中获取 $directory 和 $fstring. 
最后一个关于 list 和命令代换的例子, 但这个例子中的命令是一个函数

generate_list ()
{
 echo "one two three"
}

for word in $(generate_list)  # "word" 获得函数执行的结果. 
do
 echo "$word"
done

# one
# two
# three
for 循环的结果可以通过管道导向至一个或多个命令中

样例-11. 列出目录中的所有符号链接

#!/bin/bash
# symlinks.sh: 列出目录中的所有符号链接. 

directory=${1-`pwd`}
# 如果没有特别指定, 缺省目录为当前工作目录. 
# 等价于下面的代码块. 
# ---------------------------------------------------
# ARGS=1                 # 只有一个命令行参数. 
#
# if [ $# -ne "$ARGS" ]  # 如果不是只有一个参数的情况下
# then
#   directory=`pwd`      # 设为当前工作目录. 
# else
#   directory=$1
# fi
# ---------------------------------------------------

echo "symbolic links in directory \"$directory\""

for file in "$( find $directory -type 1 )"   # -type 1 = 符号链接
do
 echo "$file"
done | sort                                  # 否则文件顺序会是乱序. 
#  严格的来说这里并不需要使用循环, 
#+ 因为 "find" 命令的输出结果已经被扩展成一个单一字符串了. 
#  然而, 为了方便大家理解, 我们使用了循环的方式. 

#  Dominik 'Aeneas' Schnitzer 指出, 
#+ 不引用 $( find $directory -type 1 ) 的话, 
#  脚本将在文件名包含空格时阻塞. 

exit 0

# --------------------------------------------------------
# Jean Helou 提供了另外一种方法:

echo "symbolic links in directory \"$directory\""
# 备份当前的内部字段分隔符. 谨慎永远没有坏处. 
OLDIFS=$IFS
IFS=:

for file in $(find $directory -type 1 -printf "%p$IFS")
do     #                              ^^^^^^^^^^^^^^^^
      echo "$file"
      done|sort

# James "Mike" Conley 建议将 Helou 的代码修改为:

OLDIFS=$IFS
IFS='' # 空的内部字段分隔符意味着将不会分隔任何字符串
for file in $( find $directory -type 1 )
do
 echo $file
 done | sort

#  上面的代码可以在目录名包含冒号(前一个允许包含空格)
#+ 的情况下仍旧正常工作
只需要对上一个样例做一些小小的改动, 就可以把在标准输出 stdout 中的循环 重定向到文件中

样例-12. 将目录中的所有符号链接保存到文件中

#!/bin/bash
# symlinks.sh: 列出目录中的所有符号链接. 

OUTFILE=symlinks.list

directory=${1-`pwd`}
# 如果没有特别指定, 缺省目录为当前工作目录. 

echo "symbolic links in directory \"$directory\"" > "$OUTFILE"
echo "---------------------------" >> "$OUTFILE"

for file in "$( find $directory -type 1 )"    # -type 1 = 符号链接
do
 echo "$file"
done | sort >> "$OUTFILE"                     # 将 stdout 的循环结果
#           ^^^^^^^^^^^^^                       重定向到文件. 

# echo "Output file = $OUTFILE"

exit $?
还有另外一种看起来非常像C语言中循环那样的语法, 你需要使用到 双圆括号语法

样例-13. C语言风格的循环

#!/bin/bash
# 用多种方式数到10. 

echo

# 基础版
for a in 1 2 3 4 5 6 7 8 9 10
do
 echo -n "$a "
done

echo; echo

# +==========================================+

# 使用 "seq"
for a in `seq 10`
do
 echo -n "$a "
done

echo; echo

# +==========================================+

# 使用大括号扩展语法
# Bash 3+ 版本有效. 
for a in {1..10}
do
 echo -n "$a "
done

echo; echo

# +==========================================+

# 现在用类似C语言的语法再实现一次. 

LIMIT=10

for ((a=1; a <= LIMIT ; a++))  # 双圆括号语法, 不带 $ 的 LIMIT
do
 echo -n "$a "
done                           

echo; echo

# +==========================================+

# 我们现在使用C语言中的逗号运算符来使得两个变量同时增加. 

for ((a=1, b=1; a <= LIMIT ; a++, b++))
do  # 逗号连接操作. 
 echo -n "$a-$b "
done

echo; echo

exit 0
接下来, 我们将展示在真实环境中应用的循环

样例-14. 在批处理模式下使用 efax

#!/bin/bash
# 传真(必须提前安装了 'efax' 模块). 

EXPECTED_ARGS=2
E_BADARGS=85
MODEM_PORT="/dev/ttyS2"   # 你的电脑可能会不一样. 
#                ^^^^^       PCMCIA 调制解调卡缺省端口. 

if [ $# -ne $EXPECTED_ARGS ]
# 检查是不是传入了适当数量的命令行参数. 
then
  echo "Usage: `basename $0` phone# text-file"
  exit $E_BADARGS
fi

if [ ! -f "$2" ]
then
 echo "File $2 is not a text file."
 #     File 不是一个正常文件或者文件不存在. 
 exit $E_BADARGS
fi

fax make $2              # 根据文本文件创建传真格式文件. 

for file in $(ls $2.0*)  # 连接转换后的文件. 
                        # 在参数列表中使用通配符(文件名通配). 
do
 fil="$fil $file"
done

efax -d "$MODEM_PORT"  -t "T$1" $fil   # 最后使用 efax. 
# 如果上面一行执行失败, 尝试添加 -o1. 

#  上面只能指出 for 循环可以被压缩为
#     efax -d /dev/ttyS2 -o1 -t "T$1" $2.0*
#+ 但是这并不是一个好主意. 

exit $?   # efax 同时也会将诊断信息传递给标准输出. 
关键字do 和 done 圈定了 for 循环代码块的范围, 但是在一些特殊的情况下, 也可以被大括号取代

for((n=1; n<=10; n++))
# 没有 do!
{
 echo -n "* $n *"
}
# 没有 done!

# 输出:
# * 1 ** 2 ** 3 ** 4 ** 5 ** 6 ** 7 ** 8 ** 9 ** 10 *
# 并且 echo $? 返回 0, 因此 Bash 并不认为这是一个错误. 

echo

#  但是注意在典型的 for 循环 for n in [list] ... 中, 
#+ 需要在结尾加一个分号. 

for n in 1 2 3
{  echo -n "$n "; }
#               ^
while 循环
while 循环结构会在循环顶部检测循环条件, 若循环条件为真 退出状态 为0, 则循环持续进行. 与 for 不同的是, while 循环是在不知道循环次数的情况下使用的

while [ condition ]
do
 command(s)...
done
在 while 循环结构中, 你不仅可以使用像 if/test 中那样的 括号结构, 也可以使用用途更广泛的 双括号结构while [[ condition ]]
就像在 for 循环中那样, 将 do 和循环条件放在同一行时需要加一个分号. 

while [ condition ] ; do
在 while 循环中, 括号结构并不是必须存在的, 比如说 getopts 结构

样例-15. 简单的 while 循环

#!/bin/bash

var0=0
LIMIT=10

while [ "$var0" -lt "$LIMIT" ]
#      ^                    ^
# 必须有空格, 因为这是测试结构
do
 echo -n "$var0 "        # -n 不会另起一行
 #             ^           空格用来分开输出的数字. 

 var0=`expr $var0 + 1`   # var0=$(($var0+1))  效果相同. 
                         # var0=$((var0 + 1)) 效果相同. 
                         # let "var0 += 1"    效果相同. 
done                      # 还有许多其他的方法也可以达到相同的效果. 

echo

exit 0
样例-16. 另一个例子

#!/bin/bash

echo
                              # 等价于:
while [ "$var1" != "end" ]     # while test "$var1" != "end"
do
 echo "Input variable #1 (end to exit) "
 read var1                    # 不是 'read $var1' (为什么?). 
 echo "variable #1 = $var1"   # 因为存在 "#", 所以需要使用引号. 
 # 如果输入的是 "end", 也将会在这里输出. 
 # 在结束本轮循环之前都不会再测试循环条件了. 
 echo
done

exit 0
一个 while 循环可以有多个测试条件, 但只有最后的那一个条件决定了循环是否终止. 这是一种你需要注意到的不同于其他循环的语法. 

样例-17. 多条件 while 循环

#!/bin/bash

var1=unset
previous=$var1

while echo "previous-variable = $previous"
     echo
     previous=$var1
     [ "$var1" != end ] # 记录下 $var1 之前的值. 
     # 在 while 循环中有4个条件, 但只有最后的那个控制循环. 
     # 最后一个条件的退出状态才会被记录. 
do
echo "Input variable #1 (end to exit) "
 read var1
 echo "variable #1 = $var1"
done

# 猜猜这是怎样实现的. 
# 这是一个很小的技巧. 

exit 0
就像 for 循环一样,  while 循环也可以使用双圆括号结构写得像�C语言那样

样例-18. C语言风格的 while 循环

#!/bin/bash
# wh-loopc.sh: 在 "while" 循环中计数到10. 

LIMIT=10                 # 循环10次. 
a=1

while [ "$a" -le $LIMIT ]
do
 echo -n "$a "
 let "a+=1"
done                     

echo; echo

# +==============================================+

# 现在我们用C语言风格再写一次. 

((a = 1))      # a=1
# 双圆括号结构允许像C语言一样在赋值语句中使用空格. 

while (( a <= LIMIT ))   #  双圆括号结构, 
do                       #+ 并且没有使用 "$". 
 echo -n "$a "
 ((a += 1))             # let "a+=1"
 # 是的, 就是这样. 
 # 双圆括号结构允许像C语言一样自增一个变量. 
done

echo

exit 0
在测试部分, while 循环可以调用 函数

t=0

condition ()
{
 ((t++))

 if [ $t -lt 5 ]
 then
   return 0  # true 真
 else
   return 1  # false 假
 fi
}

while condition
#     ^^^^^^^^^
#     调用函数循环四次. 
do
 echo "Still going: t = $t"
done

# Still going: t = 1
# Still going: t = 2
# Still going: t = 3
# Still going: t = 4
和 if 测试结构一样, while 循环也可以省略括号

while condition
do
 command(s) ...
done
在 while 循环中结合 read 命令, 我们就得到了一个非常易于使用的 while read结构, 它可以用来读取和解析文件

cat $filename |    # 从文件获得输入. 
while read line    # 只要还有可以读入的行, 循环就继续. 
do
 ...
done

# ==================== 摘自样例脚本 "sd.sh" =================== #

 while read value   # 一次读入一个数据. 
 do
   rt=$(echo "scale=$SC; $rt + $value" | bc)
   (( ct++ ))
 done

 am=$(echo "scale=$SC; $rt / $ct" | bc)

 echo $am; return $ct   # 这个功能'返回'了2个值. 
 # 注意:这个技巧在 $ct > 255 的情况下会失效. 
 # 如果要操作更大的数字, 注释掉上面的 "return $ct" 就可以了. 
} <"$datafile"   # 传入数据文件. 
在 while 循环后面可以通过 < 将标准输入 重定位到文件 中, while 循环同样可以 通过管道传入标准输入中

until
与 while 循环相反, until 循环测试其顶部的循环条件, 直到其中的条件为真时停止

until [ condition-is-true ]
do
 commands(s)...
done
注意到, 跟其他的一些编程语言不同, until 循环的测试条件在循环顶部
就像在 for 循环中那样, 将 do 和循环条件放在同一行时需要加一个分号

until[ condition-is-true ] ; do
样例-19. until 循环

#!/bin/bash

END_CONDITION=end

until [ "$var1" = "$END_CONDITION" ]
# 在循环顶部测试条件. 
do
 echo "Input variable #1 "
 echo "($END_CONDITION to exit)"
 read var1
 echo "variable #1 = $var1"
 echo
done

#                ---                   #

#  就像 "for" 和 "while" 循环一样, 
#+ "until" 循环也可以写的像C语言一样. 

LIMIT=10
var=0

until (( var > LIMIT ))
do  # ^^ ^     ^     ^^   没有方括号, 没有 $ 前缀. 
 echo -n "$var "
 (( var++ ))
done    # 0 1 2 3 4 5 6 7 8 9 10

exit 0
如何在 for, while 和 until 之间做出选择?我们知道在C语言中, 在已知循环次数的情况下更加倾向于使用 for 循环. 但是在Bash中情况可能更加复杂一些. Bash中的 for 循环相比起其他语言来说, 结构更加松散, 使用更加灵活. 因此使用你认为最简单的就好. 

嵌套循环
嵌套循环, 顾名思义就是在循环里面还有循环. 外层循环会不断的触发内层循环直到外层循环结束. 当然, 你仍然可以使用 break 可以终止外层或内层的循环. 

样例-20. 嵌套循环

#!/bin/bash
# nested-loop.sh: 嵌套 "for" 循环. 

outer=1             # 设置外层循环计数器. 

# 外层循环. 
for a in 1 2 3 4 5 
do
 echo "Pass $outer in outer loop."
 echo "---------------------"
 inner=1           # 重设内层循环计数器. 

 # =====================================
 # 内层循环. 
 for b in 1 2 3 4 5
 do
   echo "Pass $inner in inner loop."
   let "inner+=1"  # 增加内层循环计数器. 
 done
 # 内层循环结束. 
 # =====================================

 let "outer+=1"    # 增加外层循环计数器. 
 echo              # 在每次外层循环输出中加入空行. 
done
# 外层循环结束. 

exit 0
循环控制
break, continue
break 和 continue 命令的作用和在其他编程语言中的作用一样. break 用来中止(跳出)循环, 而 continue 则是略过未执行的循环部分, 直接进行下一次循环. 

样例-21. 循环中 break 与 continue 的作用

#!/bin/bash

LIMIT=19  # 循环上界

echo
echo "Printing Numbers 1 through 20 (but not 3 and 11)."

a=0

while [ $a -le "$LIMIT" ]
do
a=$(($a+1))

if [ "$a" -eq 3 ] || [ "$a" -eq 11 ]  # 除了 3 和 11. 
then
  continue      # 略过本次循环的剩余部分. 
fi

echo -n "$a "   # 当 a 等于 3 和 11 时, 将不会执行这条语句. 
done

# 思考:
# 为什么循环不会输出到20?

echo; echo

echo Printing Numbers 1 through 20, but something happens after 2.

##################################################################

# 用 'break' 代替了 'continue'. 

a=0

while [ "$a" -le "$LIMIT" ]
do
a=$(($a+1))

if [ "$a" -gt 2 ]
then
  break  # 中止循环. 
fi

echo -n "$a"
done

echo; echo; echo

exit 0
break 命令接受一个参数, 普通的 break 命令仅仅跳出其所在的那层循环, 而 break N 命令则可以跳出其上 N 层的循环

样例-22. 跳出多层循环

#!/bin/bash
# break-levels.sh: 跳出循环.

# "break N" 跳出 N 层循环. 

for outerloop in 1 2 3 4 5
do
 echo -n "Group $outerloop:   "

 # ------------------------------------------
 for innerloop in 1 2 3 4 5
 do
   echo -n "$innerloop "

   if [ "$innerloop" -eq 3 ]
   then
     break  # 尝试一下 break 2 看看会发生什么. 
            # (它同时中止了内层和外层循环. )
   fi
 done
 # ------------------------------------------

 echo
done

echo

exit 0
与 break 类似, continue 也接受一个参数. 普通的 continue 命令仅仅影响其所在的那层循环, 而 continue N 命令则可以影响其上 N 层的循环

样例-23. continue 影响外层循环

#!/bin/bash
# "continue N" 命令可以影响其上 N 层循环. 

for outer in I II III IV V           # 外层循环
do
 echo; echo -n "Group $outer: "

 # --------------------------------------------------------------------
 for inner in 1 2 3 4 5 6 7 8 9 10  # 内层循环
 do

   if [[ "$inner" -eq 7 && "$outer" = "III" ]]
   then
     continue 2  # 影响两层循环, 包括'外层循环'. 
                 # 将其替换为普通的 "continue", 那么只会影响内层循环. 
   fi

   echo -n "$inner "  # 7 8 9 10 将不会出现在 "Group III."中. 
 done
 # --------------------------------------------------------------------

done

echo; echo

# 思考:
# 想一个 "continue N" 在脚本中的实际应用情况. 

exit 0
样例-24. 真实环境中的 continue N

# Albert Reiner 举出了一个如何使用 "continue N" 的例子:
# ---------------------------------------------------

#  如果我有许多任务需要运行, 并且运行所需要的数据都以文件的形
#+ 式存在文件夹中. 现在有多台设备可以访问这个文件夹, 我想将任
#+ 务分配给这些不同的设备来完成. 
#  那么我通常会在每台设备上执行下面的代码:

while true:
do
 for n in .iso.*
 do
   [ "$n" = ".iso.opts" ] && continue
   beta=${n#.iso.}
   [ -r .Iso.$beta ] && continue
   [ -r .lock.$beta ] && sleep 10 && continue
   lockfile -r0 .lock.$beta || continue
   echo -n "$beta: " `date`
   run-isotherm $beta
   date
   ls -alF .Iso.$beta
   [ -r .Iso.$beta ] && rm -rf .lock.$beta
   continue 2
 done
 break
done

exit 0

# 这个脚本中出现的 sleep N 只针对这个脚本, 通常的形式是:

while true
do
 for job in {pattern}
 do
   {job already done or running} && continue
   {mark job as running, do job, mark job as done}
   continue 2
 done
 break        # 或者使用类似 `sleep 600` 这样的语句来防止脚本结束. 
done

#  这样做可以保证脚本只会在没有任务时(包括在运行过程中添加的任务)
#+ 才会停止. 合理使用文件锁保证多台设备可以无重复的并行执行任务(这
#+ 在我的设备上通常会消耗好几个小时, 所以我想避免重复计算). 并且, 
#+ 因为每次总是从头开始搜索文件, 因此可以通过文件名决定执行的先后
#+ 顺序. 当然, 你可以不使用 'continue 2' 来完成这些, 但是你必须
#+ 添加代码去检测某项任务是否完成(以此判断是否可以执行下一项任务或
#+ 终止, 休眠一段时间再执行下一项任务). 
continue N 结构不易理解并且可能在一些情况下有歧义, 因此不建议使用. 

测试与分支
case 和 select 结构并不属于循环结构, 因为它们并没有反复执行代码块. 但是和循环结构相似的是, 它们会根据代码块顶部或尾部的条件控制程序流. 

下面介绍两种在代码块中控制程序流的方法:

case (in) / esac
在 shell 脚本中, case 模拟了 C/C++ 语言中的 switch, 可以根据条件跳转到其中一个分支. 其相当于简写版的 if/then/else 语句. 很适合用来创建菜单选项哟!

case "$variable" in
 "$condition1" )
   command...
 ;;
 "$condition2" )
   command...
 ;;
esac

对变量进行引用不是必须的, 因为在这里不会进行字符分割
条件测试语句必须以右括号 ) 结束
每一段代码块都必须以双分号 ;; 结束
如果测试条件为真, 其对应的代码块将被执行, 而后整个 case 代码段结束执行. 

case 代码段必须以 esac 结束(倒着拼写case)

样例-25. 如何使用 case

#!/bin/bash
# 测试字符的种类. 

echo; echo "Hit a key, then hit return."
read Keypress

case "$Keypress" in
 [[:lower:]]   ) echo "Lowercase letter";;
 [[:upper:]]   ) echo "Uppercase letter";;
 [0-9]         ) echo "Digit";;
 *             ) echo "Punctuation, whitespace, or other";;
esac      #  字符范围可以用[方括号]表示, 也可以用 POSIX 形式的[[双方括号]]表示. 

# 在这个例子的第一个版本中, 用来测试是小写还是大写字符使用的是 [a-z] 和 [A-Z]. 
# 这在一些特定的语言环境和 Linux 发行版中不起效. 
# POSIX 形式具有更好的兼容性. 
# 感谢 Frank Wang 指出这一点. 

# 练习:
# -----
# 这个脚本接受一个单字符然后结束. 
# 修改脚本, 使得其可以循环接受输入, 并且检测键入的每一个字符, 直到键入 "X" 为止. 
# 提示:将所有东西包在 "while" 中. 

exit 0
样例-26. 使用 case 创建菜单

#!/bin/bash

# 简易的通讯录数据库

clear # 清屏. 

echo "          Contact List"
echo "          ------- ----"
echo "Choose one of the following persons:" 
echo
echo "[E]vans, Roland"
echo "[J]ones, Mildred"
echo "[S]mith, Julie"
echo "[Z]ane, Morris"
echo

read person

case "$person" in
# 注意变量是被引用的. 

 "E" | "e" )
 # 同时接受大小写的输入. 
 echo
 echo "Roland Evans"
 echo "4321 Flash Dr."
 echo "Hardscrabble, CO 80753"
 echo "(303) 734-9874"
 echo "(303) 734-9892 fax"
 echo "revans@zzy.net"
 echo "Business partner & old friend"
 ;;
 # 注意用双分号结束这一个选项. 

 "J" | "j" )
 echo
 echo "Mildred Jones"
 echo "249 E. 7th St., Apt. 19"
 echo "New York, NY 10009"
 echo "(212) 533-2814"
 echo "(212) 533-9972 fax"
 echo "milliej@loisaida.com"
 echo "Ex-girlfriend"
 echo "Birthday: Feb. 11"
 ;;

 # Smith 和 Zane 的信息稍后添加. 

 *         )
 # 缺省设置. 
 # 空输入(直接键入回车)也是执行这一部分. 
 echo
 echo "Not yet in database."
 ;;

esac

echo

# 练习:
# -----
# 修改脚本, 使得其可以循环接受多次输入而不是只显示一个地址后终止脚本. 

exit 0
你可以用 case 来检测命令行参数

#!/bin/bash

case "$1" in
 "") echo "Usage: ${0##*/} <filename>"; exit $E_PARAM;;
                     # 没有命令行参数, 或者第一个参数为空. 
                     # 注意 ${0##*/} 是参数替换 ${var##pattern} 的一种形式. 
                     # 最后的结果是 $0.

 -*) FILENAME=./$1;; #  如果传入的参数以短横线开头, 那么将其替换为 ./$1
                     #+ 以避免后续的命令将其解释为一个选项. 

 * ) FILENAME=$1;;   # 否则赋值为 $1. 
esac
下面是一个更加直观的处理命令行参数的例子:

#!/bin/bash

while [ $# -gt 0 ]; do    # 遍历完所有参数
 case "$1" in
   -d|--debug)
             # 检测是否是 "-d" 或者 "--debug". 
             DEBUG=1
             ;;
   -c|--conf)
             CONFFILE="$2"
             shift
             if [ ! -f $CONFFILE ]; then
               echo "Error: Supplied file doesn't exist!"
               exit $E_CONFFILE     # 找不到文件. 
             fi
             ;;
 esac
 shift       # 检测下一个参数
done
样例-27. 使用命令替换生成 case 变量

#!/bin/bash
# case-cmd.sh: 使用命令替换生成 "case" 变量. 

case $( arch ) in   # $( arch ) 返回设备架构. 
                   # 等价于 'uname -m". 
 i386 ) echo "80386-based machine";;
 i486 ) echo "80486-based machine";;
 i586 ) echo "Pentium-based machine";;
 i686 ) echo "Pentium2+-based machine";;
 *    ) echo "Other type of machine";;
esac

exit 0
case 还可以用来做字符串模式匹配

样例-28. 简单的字符串匹配

#!/bin/bash
# match-string.sh: 使用 'case' 结构进行简单的字符串匹配. 

match_string ()
{ # 字符串精确匹配. 
 MATCH=0
 E_NOMATCH=90
 PARAMS=2     # 需要2个参数. 
 E_BAD_PARAMS=91

 [ $# -eq $PARAMS ] || return $E_BAD_PARAMS

 case "$1" in
   "$2") return $MATCH;;
   *   ) return $E_NOMATCH;;
 esac

}

a=one
b=two
c=three
d=two

match_string $a     # 参数个数不够
echo $?             # 91

match_string $a $b  # 匹配不到
echo $?             # 90

match_string $a $d  # 匹配成功
echo $?             # 0

exit 0
样例-29. 检查输入

#!/bin/bash
# isaplpha.sh: 使用 "case" 结构检查输入. 

SUCCESS=0
FAILURE=1   #  以前是FAILURE=-1,
           #+ 但现在 Bash 不允许返回负值. 

isalpha ()  # 测试字符串的第一个字符是否是字母. 
{
if [ -z "$1" ]                # 检测是否传入参数. 
then
 return $FAILURE
fi

case "$1" in
 [a-zA-Z]*) return $SUCCESS;;  # 是否以字母形式开始?
 *        ) return $FAILURE;;
esac
}             # 可以与 C 语言中的函数 "isalpha ()" 作比较. 

isalpha2 ()   # 测试整个字符串是否都是字母. 
{
 [ $# -eq 1 ] || return $FAILURE

 case $1 in
 *[!a-zA-Z]*|"") return $FAILURE;;
              *) return $SUCCESS;;
 esac
}

isdigit ()    # 测试整个字符串是否都是数字. 
{             # 换句话说, 也就是测试是否是一个整型变量. 
 [ $# -eq 1 ] || return $FAILURE

 case $1 in
   *[!0-9]*|"") return $FAILURE;;
             *) return $SUCCESS;;
 esac
}

check_var ()  # 包装后的 isalpha (). 
{
if isalpha "$@"
then
 echo "\"$*\" begins with an alpha character."
 if isalpha2 "$@"
 then        # 其实没必要检查第一个字符是不是字母. 
   echo "\"$*\" contains only alpha characters."
 else
   echo "\"$*\" contains at least one non-alpha character."
 fi
else
 echo "\"$*\" begins with a non-alpha character."
             # 如果没有传入参数同样同样返回'存在非字母'. 
fi

echo

}

digit_check ()  # 包装后的 isdigit (). 
{
if isdigit "$@"
then
 echo "\"$*\" contains only digits [0 - 9]."
else
 echo "\"$*\" has at least one non-digit character."
fi

echo

}

a=23skidoo
b=H3llo
c=-What?
d=What?
e=$(echo $b)   # 命令替换. 
f=AbcDef
g=27234
h=27a34
i=27.34

check_var $a
check_var $b
check_var $c
check_var $d
check_var $e
check_var $f
check_var     # 如果不传入参数会发送什么?
#
digit_check $g
digit_check $h
digit_check $i

exit 0        

# 练习:
# -----
# 写一个函数 'isfloat ()' 来检测输入值是否是浮点数. 
# 提示:可以参考函数 'isdigit ()', 在其中加入检测合法的小数点即可. 
select
select 构建菜单

select variable [in list]
do
command...
break
done
而效果则是终端会提示用户输入列表中的一个选项. 注意, select 默认使用提示字串3(Prompt String 3, $PS3, 即#?), 但同样可以被修改

样例 11-30. 使用 select 创建菜单

#!/bin/bash

PS3='Choose your favorite vegetable: ' # 设置提示字串. 
                                      # 否则默认为 #?. 

echo

select vegetable in "beans" "carrots" "potatoes" "onions" "rutabagas"
do
 echo
 echo "Your favorite veggie is $vegetable."
 echo "Yuck!"
 echo
 break  # 如果没有 'break' 会发生什么?
done

exit

# 练习:
# -----
# 修改脚本, 使得其可以接受其他输入而不是 "select" 语句中所指定的. 
# 例如, 如果用户输入 "peas,", 那么脚本会通知用户 "Sorry. That is not on the menu."
如果 in list 被省略, 那么 select 将会使用传入脚本的命令行参数 $@ 或者传入函数的参数作为 list
可以与 for variable in list 中 in list 被省略的情况做比较

样例-31. 在函数中使用 select 创建菜单

#!/bin/bash

PS3='Choose your favorite vegetable: '

echo

choice_of()
{
select vegetable
# [in list] 被省略, 因此 'select' 将会使用传入函数的参数作为 list. 
do
 echo
 echo "Your favorite veggie is $vegetable."
 echo "Yuck!"
 echo
 break
done
}

choice_of beans rice carrorts radishes rutabaga spinach
#         $1    $2   $3      $4       $5       $6
#         传入了函数 choice_of()

exit 0

#----Shell--------------------

shell的语法不需要 ; 类似python

Windows上使用shell
1.下载Git:https://www.git-scm.com/download/win
2.在目标.sh文件夹中右键打开Git.bash
3.命令行输入 sh test.sh 123
特别提醒:一定要使用这种 a=10 而不是 a = 10 =两边不要留空格, 不要留空格

chmod u+x shell.sh        将shell权限变为可执行文件
#!/bin/bash		 标准的头部写法

变量使用
shell中变量定义必须赋予初值  a=10, 后续用a的时候使用 $a

读取外部参数
$#		传递给脚本的参数个数
$@		传递给脚本所有的参数
$0      当前脚本的名字
$1      传递给脚本的第一个参数(后面依次类推)
例:./test.sh COMP|head       此处读入的外界参数只有COMP, 管道后面的并不会被当作参数

if的4种模式

方式一
if(($# != 2)) 2>/dev/null	  (())类似于python中的判断格式
then				  2>/dev/null意为输出错误不再显示到屏幕上, 而是到null里
	echo "$#"
else				  else后不用加then
	echo "Hello"
fi

方式二						
elif [ $# -ne 2 ]		  [ ]功能等同于test, 使用-eq这些, 而不是==
then			          [ ]中每个字符之间都要有空格
	echo "$#"
fi

方式三
elif [[ $# < 5 && $# > 2 ]]       [[ ]]非常强大, 可以使用逻辑表达式, 也可以使用=~正则表达式
then
	echo "$#"
fi

方式四
elif test -e $file	          test测试后会返回一个值真或假, 可测试数字, 字符文件 
then	
	echo "Exist"              -e,-r为检测文件是否存在(注意此处的比较项要加-, 而perl中不用)
fi

= 与 !=          字符串匹配判断(perl里使用eq, 切记没有-)
-gt,-eq,-ne,-lt  数字大小判断(perl 里使用==与!=)
-e,-r			 判断文件存在, 判断文件存在且可读
-a			     and  例:if test $a -gt 10 -a -lt 15
-o               or

2种for循环
方式 一
for((i=1;i<=10;i++))	  注意此处是双括号
do
	echo "Hi"
done

方式 二
for i in $(seq 1 10)
do
	echo $i
done

依次读取目录下的文件
for file in *.jpg             读取当前目录下所有的.jpg文件
do
	png=$(echo "$file" | sed 's/jpg/png/g')					  
	#操作变量的时候要加$,类似Vue的语法
	#此处转换.jpg为.png, 注意此处的echo, 它有打开此文件的作用, 若无可能无法将值赋给变量png
done

for file in *		       读取当前目录所有文件

echo的用法
echo -n                            不换行输出
echo "hello world" >> a.txt	   追加至a.txt中
echo "hello world" > a.txt	   写入a.txt中

echo的一个作用是读取文件名(并不打开文件)并通过管道传递

赋值命令行结果给变量
test=$()
test=``	

加减运算
num=$(($1 + 1))    		       使用双括号进行运算赋值, $()这种无法进行计算会报错
num=$(expr $1 + 1)		       请注意, 每个字符之间一定要有空格, 一定要有空格

其余常用命令

name=`basename /tmp/test/file.txt`   			输出为file.txt
name1=`basename /tmp/test/file.txt .txt`		输出为file

diff file1 file2 >dev/null 2>&1		        比较结果不输出到屏幕

if  [ "$?" == "0" ];then			$?是对比结果返回值
   echo "the file or dir is same!"
else 
	echo "the file or dir is different!"
fi
exit

exit 0				           退出并返回0
exit 1                                     退出并返回1
convert

convert "a.jpg" "a.png"		           将jpg图片转换为png
read

read address 				    读取外界输入并将其值赋给address
echo $address
cp

cp file1 file2				     将file1复制成file2
cp -p					     保留源文件各种信息及属性
mv

mv aaa bbb				     将文件名aaa改为bbb
mv aaa info/			             将文件移动到info/文件夹
display

display shell.png			     打开一张图片

Regex
格式: egrep '匹配的内容' 目标文件 | 第二步操作
作用: 从目标文件中读取出包含匹配内容的 一整行, 而不是要匹配的字符串片段
说明: 匹配内容里不需要用转义符, 这与s///g不同
小技巧:使用特殊的标点符号作为匹配的标志可以提升效率

常用匹配规则

[aeiouAEIOU]			从中随机选择一个
[0-9]{4}		        从中选择4个
.*				匹配任意字符
\w				匹配单词
\d				匹配数字
^abc				以abc为开始
^(abc)				以abc为开头
[^abc]				不包含abc
abc$				以abc为结尾
'|'				匹配内容里|表示或者
+				至少匹配1个
?			        至少匹配0个
()				同传统意义上的括号
常用选择项

-v						不包括匹配出的结果
-i						忽略大小写, 在perl中为//i
cut

例子: abc,123, 456, afg  		   
cut -d',' -f2					  注意此处是f2,取出123
cut -d',' -f2,3					  取出123 456		
sort

sort用法(单独使用为按字母顺序排序)
-n或-nr				       按数字大小进行排序
-r				       反向排序
-u				       排序结果去掉重复项

与unqic一起使用
sort aim.txt | unqic -c | sort -n      unic去重, -c显示重复行数量

wc

wc <aim.txt
-l					              只显示行数
-w                                                    只显示字数

-----------
如果是用管道则为   | wc -l |                          不需要<符号
tail

tail -1                                               显示最后一行
tr

tr '0123456789' '<<<<<5>>>>'                          将0-9转换按规则为后面
sed

sed				            流编辑器
不必被sed复杂的概念所迷惑, sed就是用来 把一个字符串中的某部分更改为其他字符的一种工具

| sed s///g 		                    此为主要用法, s/1/2/g意为将所有匹配到的1换为2

例子(匹配里最好不要用+,可以用*)             输入123abc123

cat line.txt | sed 's/[0-9]*//g'           得到abc123
cat line.txt | sed 's/[a-z]//g'            得到123123
cat line.txt | sed 's/[0-9]*$//g'          得到123abc
cat line.txt | sed 's/[0-9]*[a-z]//g'      得到123(删123abc)
cat line.txt | sed 's/[a-z][0-9]*//g'      得到123(删abc123)

