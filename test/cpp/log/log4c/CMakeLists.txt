# CMake 最低版本号要求
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

# 项目名
PROJECT(LOG)

# 添加第三方的库
SET(INC_DIR "/usr/local/include/")
SET(LINK_DIR "/usr/local/lib")

INCLUDE_DIRECTORIES(${INC_DIR})    # 设置头文件搜索路径
LINK_DIRECTORIES(${LINK_DIR})    #指定要链接的库文件的路径，一般不需要
# 将第三方的库链接到可执行文件，静态链接
LINK_LIBRARIES(log4cplus)

# 指定源文件
SET(SRC_LIST "main.cpp")
MESSAGE(STATUS "SRC_LIST :" ${SRC_LIST})

# 指定生成目标
ADD_EXECUTABLE(${PROJECT_NAME} ${SRC_LIST})

# 将第三方的库链接到可执行文件，动态链接
#TARGET_LINK_LIBRARIES(${PROJECT_NAME} log4cplus)

# 安装目标文件
SET(PROJECT_INSTALL_PREFIX "/mnt/hgfs/VM_Shared/Teselog4cplus/build/dd")
INSTALL(TARGETS ${PROJECT_NAME}
        DESTINATION ${PROJECT_INSTALL_PREFIX}
         PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

# 安装配置文件
SET(CONFIG_INSTALL_PREFIX "/mnt/hgfs/VM_Shared/Teselog4cplus/build")        
INSTALL(FILES logconfig.property
        DESTINATION ${CONFIG_INSTALL_PREFIX})