for /f "skip=1 delims=" %%k in ('certutil -hashfile "c:\notes\bat\RFRHO.txt"  MD5') do (
  echo %%k

)


