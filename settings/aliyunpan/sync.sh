# 请更改成你自己的目录
cd /workspaces/jupyter/

chmod +x ./aliyunpan

# 指定refresh token用于登录
./aliyunpan login -RefreshToken=e91fe57e6b7446ad963ed98f9026b160

./aliyunpan token update -mode 2

# 上传下载链接类型：1-默认 2-阿里ECS环境
aliyunpan config set -transfer_url_type 1

# 指定配置参数并进行启动
# 支持的模式：upload(备份本地文件到云盘),download(备份云盘文件到本地),sync(双向同步备份)
aliyunpan sync start -dp 1 -up 5 -ldir "/workspaces/jupyter/" -pdir "/backup/jupyter" -mode "upload"