##  ZAlgo Framework

static Library

[参考链接](https://www.iosdevlog.com/ios/2018/03/29/ios-universal-framework.html)

### 1. 创建Framework
* 新创建一个Project;
* 然后选择`iOS->Framrwork & Library->Cocoa Touch Framework`;
* 在`Target->Build Setting`中搜索`Mach-O type`, 设置为`Static Library`;
* 创建`.h`和`.m`文件，其中`.h`文件在`Build Phase`中需要放置到`Header`下面的`Public`里;
* 生成的`ZAlgo.h`中需要添加需要暴露出去的类;

ZAlgo.h的代码

```
#if __has_include(<ZAlgo/ZAlgo.h>)

#import <ZAlgo/ZAlgoTreeViewController.h>
#import <ZAlgo/ZAlgoSortViewController.h>
#import <ZAlgo/ZAlgoLinkedListViewController.h>
#import <ZAlgo/ZAlgoStringViewController.h>

#else

#improt "ZAlgoTreeViewController.h"
#import "ZAlgoSortViewController.h"
#import "ZAlgoLinkedListViewController.h"
#import "ZAlgoStringViewController.h"

#endif
```

### 2. 创建Aggregate
* 给ZAlgo新建一个Target，选择`cross-platform->ohter->aggregate`；
* 给新添加ZAlgoAggregate添加两个脚本

脚本如下

#### 2.1编译脚本

```
# Sets the target folders and the final framework product.
# 如果工程名称和Framework的Target名称不一样的话，要自定义FMKNAME
# 例如: FMK_NAME = "MyFramework"
FMK_NAME=${PROJECT_NAME}
# Install dir will be the final output to the framework.
# The following line create it in the root folder of the current project.
INSTALL_DIR=${SRCROOT}/Products/${FMK_NAME}.framework
# Working dir will be deleted after the framework creation.
WRK_DIR=build
DEVICE_DIR=${WRK_DIR}/Release-iphoneos/${FMK_NAME}.framework
SIMULATOR_DIR=${WRK_DIR}/Release-iphonesimulator/${FMK_NAME}.framework
# -configuration ${CONFIGURATION}
# Clean and Building both architectures.
xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphoneos build
xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphonesimulator build
# Cleaning the oldest.
if [ -d "${INSTALL_DIR}" ]
then
rm -rf "${INSTALL_DIR}"
fi
mkdir -p "${INSTALL_DIR}"
cp -R "${DEVICE_DIR}/" "${INSTALL_DIR}/"
# Uses the Lipo Tool to merge both binary files (i386 + armv6/armv7) into one Universal final product.
lipo -create "${DEVICE_DIR}/${FMK_NAME}" "${SIMULATOR_DIR}/${FMK_NAME}" -output "${INSTALL_DIR}/${FMK_NAME}"
rm -r "${WRK_DIR}"
#open "${INSTALL_DIR}"

```

### 2.2 复制脚本

```
# copy the framework to root product category
FMK_NAME=${PROJECT_NAME}
INSTALL_SOURCE_DIR=${SRCROOT}/Products/${FMK_NAME}.framework
INSTALL_TARGET_DIR=${SRCROOT}/../Products/${FMK_NAME}.framework
# Cleaning the oldest.
if [ -d "${INSTALL_TARGET_DIR}" ]
then
rm -rf "${INSTALL_TARGET_DIR}"
fi
mkdir -p "${INSTALL_TARGET_DIR}"
cp -R "${INSTALL_SOURCE_DIR}/" "${INSTALL_TARGET_DIR}/"
rm -rf "${INSTALL_TARGET_DIR}/_CodeSignature"
rm -rf "${INSTALL_TARGET_DIR}/Info.plist"
open "${INSTALL_TARGET_DIR}"

```

### 3. 添加Framework

在工程中添加`ZAlgo.framework`

需要注意的是，主工程的`Targets->ZAlgoDemo->Build Settings`中搜索`Other linker Flags` 需要添加参数，参数如下（选择性添加）:

* -ObjC
* -lz
* -all_load
* -force_load


