# 组件化形式1

FindAllDotHFile

1 .可递归查找根目录下的所有.h文件，且生成#import <.h> 

2 . 可生成framework所需要的，.moduleMap 文件



>生成framework，避免重复编译，加快编译链接速度，打包速度
可用于Release 形态打包，节省打包时间；


# 使用说明

```
0. 新建目标工程 framework， 设置语言为ObjC;

1.文件夹命名，项目名字命名对应 和 层级关系需要保持一致；

2.运行FindAllDotHFile程序，选择目标工程根目录即. xcodeproj 文件所在目录，正常会生成.h  与 moduleMap 文件；

3. 将FindAllDotHFile程序 生成的两个文件覆盖到 目标工程中；
 ps: 删除.h 文件中的 <目标工程主文件名/目标工程主文件.h>多余.h 代码行

4.配置Xcode 设置生成.framework 的支持的架构:
```


>使用说明参照[截图参考](https://github.com/nice2m/FindHeaderFile/tree/main/FindDotDemo/steps)




好处：
1. 减少编译链接时间
2. 适用于Release 形态 打包

坏处：
1. Debug 形态不方便调试，目前无法进入断点
2. 增加动态库load时间，启动app时间(极少)



# 下一步进阶

[相同类型项目,生成通用framework](https://github.com/gurhub/universal-framework)

[美团 iOS 工程 zsource 命令背后的那些事儿](https://tech.meituan.com/2019/08/08/the-things-behind-the-ios-project-zsource-command.html)






