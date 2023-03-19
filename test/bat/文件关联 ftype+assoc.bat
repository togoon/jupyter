
::ASSOC是用来改扩展名与文件类型的关联的

assoc .log=aklpad
assoc .ini=aklpad
assoc .inf=aklpad
assoc .c=aklpad
assoc .cpp=aklpad
assoc .h=aklpad
assoc .hpp=aklpad
assoc .mak=aklpad
assoc .prj=aklpad
assoc .java=aklpad
assoc .js=aklpad
assoc .xml=aklpad
assoc .css=aklpad
assoc .rb=aklpad
assoc .php=aklpad
assoc .jsp=aklpad
assoc .sas=aklpad

assoc .caa=cajviewer
assoc .caj=cajviewer
assoc .teb=cajviewer
assoc .kdh=cajviewer
assoc  .nk=cajviewer

assoc  .pdf=foxitreader

assoc  .bmp=acdsee
assoc  .gif=acdsee
assoc  .tif=acdsee
assoc  .tiff=acdsee
assoc  .wmf=acdsee
assoc  .tga=acdsee
assoc  .sgi=acdsee
assoc   .bw=acdsee
assoc  .rgb=acdsee
assoc  .rgba=acdsee
assoc  .psd=acdsee
assoc  .png=acdsee
assoc  .pix=acdsee
assoc  .pic=acdsee
assoc  .pcx=acdsee
assoc  .dxc=acdsee
assoc  .pcd=acdsee
assoc  .dib=acdsee
assoc  .rle=acdsee
assoc  .iff=acdsee
assoc  .lbm=acdsee
assoc  .ilbm=acdsee
assoc  .jpg=acdsee
assoc  .jpeg=acdsee
assoc  .jpe=acdsee
assoc  .jif=acdsee
assoc  .jfif=acdsee
assoc  .bmp=acdsee


::FTYPE是改文件类型与应用程序的关联的

ftype aklpad="D:\GSoft\MySoft\AkelPad.exe" "%%1"
ftype cajviewer="D:\GSoft\MySoft\cajviewer.exe" "%%1"
ftype foxitreader="D:\GSoft\MySoft\FoxitReader.exe" "%%1"
ftype acdsee="D:\GSoft\MySoft\ACDSee.exe" "%%1"

::reg文件类型图标 

reg add HKEY_CLASSES_ROOT\aklpad\DefaultIcon /ve /d "D:\GSoft\MySoft\AkelPad.exe,0" /f