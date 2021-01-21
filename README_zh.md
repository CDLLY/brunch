# Brunch 框架

## 简介

首先，先感谢Croissant、swtpm maintainer、Chromebrew framework这些项目的开发与维护，这些项目对Brunch框架的开发非常有作用。

Bruch是一个能让谷歌ChromeOS运行在第三方设备上的驱动框架,其实现原理大致是根据各种Chromebook的官方恢复映像来创建一个通用的x86_64架构的ChromeOS映像，以致于可以在各种硬件方案上运行ChromeOS。
所以啊，如果找不到与你使用的硬件方案相接近的ChromeBook的恢复映像，可能体验就不会太好，所造成的一切数据损失balabala的一系列负面后果，这个项目是不承担责任的。那有没有什么建议呢，有的，就是做好各种备份。⊙▽⊙

哎，其他的什么声明之类的就先不扯了，看[英文完整版](https://github.com/sebanc/brunch/blob/master/README.md)的机翻应该也差不多，直接到安装流程吧。

## 安装流程

首先，把整个ChromeOS安装到一个完整的物理硬盘上是最优解，主要是装得快。
如果你非要安装在物理硬盘的某一个分区上，也是可以的，而且这样的话是支持安装到ntfs之类的分区的

### 0.工具准备
推荐在linux平台进行，如果你电脑上没有安装linux发行版或容器内的linux，但却一定要装在某一个特定分区，则需要一个至少有16GB空间的U盘。（不方便清U盘，但手机有空间和root权限可以用这个[DriveDroid](https://play.google.com/store/apps/details?id=com.softwarebakery.drivedroid)）

对于初次接触linux者：
如果你实在没有使用linux的设备，请拿出手机，下载[Anlinux](https://play.google.com/store/apps/details?id=exa.lnx.a)和[Termux](https://play.google.com/store/apps/details?id=com.termux),按照anlinux的内置步骤安装ubuntu系统，通过这两个APP，即使你的手机没有root权限，你也可以搭建一个够用的linux环境。

在准备好linux环境之后，你需要安装这样几个工具包wget,unzip,tar,pv和cgpt
对于在Termux上使用ubuntu的用户，请键入以下命令：

     apt update

     apt install unzip tar pv cgpt -y

     mkdir ~/imgs

     cd ~/imgs

（电脑用户就加个sudo嘛...）
在镜像整合结束前，都请在当前窗口进行操作～

### 1.镜像下载
 Brunch镜像下载：
   打开该项目的[Releases页面](https://github.com/sebanc/brunch/releases)并复制其中的最新版本的下载链接，键入命令：
   
     wget 你复制的下载链接
  
 恢复镜像下载：  
   打开[镜像1](https://cros-updates-serving.appspot.com/)或者[镜像2](https://cros.tech/)找一个和你硬件类似（主要是CPU）的ChromeBook的官方恢复映像(推荐第一个页面，信息比较直观)，并复制其下载链接，键入命令：
   
     wget 你复制的下载链接
   
   等待下载完毕。
   
   如果你懒得查型号配置，这也有推荐的方案：
   英特尔酷睿四代及四代以后的CPU选"rammus"
   英特尔酷睿三代及三代以前的CPU选"samus"
   英特尔赛扬N系列推荐选"coral"
   AMD平台的推荐选grunt
   其他的奇奇怪怪的平台就自己老老实实翻各类Chromebook的配置去

### 2.解压下载内容
   命令大概是这样：
   
     tar zxvf *.tar.gz
   
     unzip *.zip 
   
### 3.整合brunch框架与恢复镜像以及安装到磁盘

##### 使用传统linux发行版进行操作的用户请直接跳转到[步骤 3.2](#32-从linux安装到磁盘)
  
  #### 3.05 使用Termux或其他容器技术的linux整合镜像（没错，你要是在windows10上装了linux子系统，也会很方便的）
   很显然，由于使用的容器技术，你并没有权限将其写入到容器之外的硬盘，所以你只能先制作一个chromeos镜像。
       执行命令：
       
     bash chromeos-install.sh -src *.bin -dst chromeos.img
         
   你得到了一个镜像。
   ###### Termux用户可在退出ubuntu后执行以下命令，将打包好的镜像移到sd卡根目录，再使用mtp传至windows即可。
   
     mv ~/ubuntu-fs/root/imgs/chromeos.img /sdcard （在此之前，记得要给Termux储存权限哦）
    
   待镜像写入完成后，可使用[Rufus](https://rufus.ie/)、[Etcher](https://www.balena.io/etcher/)之类的烧录工具将其刷写到U盘。
   
   ##### 3.1 从ChromeOS安装ChromeOS。
   插入烧录了ChromeOS的U盘到需要安装的设备，启动设备并引导进入系统，初次进入的话，你会看到Brunch的LOGO，并且在这个界面等待数分钟，具体时间视U盘读写速度而定。
   接着你会看到一个白底有Chrome LOGO的界面，接着就是激活流程了，千篇一律，如果你需要使用U盘作为口袋系统的话，请按步骤激活系统，需要科学上网，办法有很多，最容易得到的的莫过于一台安卓10以上可以通过USB网络共享同时分享安卓代理的手机了，其他的就不一一赘述了。
   
   如果你只是想安装到电脑，那么请在激活界面按下：Ctrl+Alt+F2。ps:有些本子可能还要加个Fn键才能按到F2功能键
   你会进入一个命令行，根据提示让你输入用户名以登录，默认即为：chronos 没有密码
   执行lsblk或sudo blkid命令查看磁盘信息,并确定安装位置
   接下来输入命令：
   ##### 3.1.1 全盘安装【注意：该命令将安装到整块硬盘而非分区】(x_x)
   
     sudo chromeos-install -dst 你的硬盘位置（例如/dev/sdx或/dev/mmcblkx,x为未知数）
             
              实例：sudo chromeos-install -dst /dev/sda  （请勿照搬）
             
   ###### 没错，你好了，请[跳转到最后的语句](#4结束语句)吧！◑﹏◐
  
   ##### 3.1.2 单一分区安装
   
     sudo mkdir /mnt/tmpch
        
     sudo mount /dev/sdxx /mnt/tmpch    (sdxx是你要安装的分区，例如sda4，可以是ext4也可以是其他的)
        
     sudo chromeos-install -dst /mnt/tmpch/chromeos.img -s 你要分配给ChromeOS的空间大小，单位GB。 （其中系统大概会占10GB。如果你要填满整个分区，就删去-s参数）

   等待镜像写入结束，屏幕上会出现引导该系统的grub参数，将其复制并保存到你乐意存的地方，填入你已安装的grub的配置文件，如果你未安装grub且不知道该如何引导系统，请继续执行命令：
   
     sudo mkdir /mnt/efi
        
     sudo mkdir /mnt/imgefi
        
     sudo mount 填写你efi分区的位置一般是/dev/sda1 /mnt/efi
        
     sudo mount -v -o offset=1235226624 -t vfat /mnt/tmpch/chromeos.img /mnt/imgefi
        
     sudo cp -r /mnt/imgefi/efi/boot ~/
        
     sudo mv ~/boot ~/ChromeOS
        
     sudo nano ~/ChromeOS/grub.cfg
        
        删掉里面的内容，把之前保存下来的配置粘贴进去
        Ctrl+X退出，y保存，回车确认，修改完毕
        
     sudo cp -r ~/ChromeOS /mnt/efi/efi
        
   因为ChromeOS并不带有修改UEFI启动项的工具包(反正我没找到)，所以你需要去windows或者其他系统添加引导项，windows的话推荐EasyUEFI,Bootice,以及最新版DiskGenius。
   
   ###### 没错，你终于好了，请[跳转到最后的语句](#4结束语句)吧！◑﹏◐
   
   #### 3.2 从linux安装到磁盘
   
  执行blkid或lsblk命令查看磁盘信息,并确定安装位置
  
  ##### 3.2.1 全盘安装【注意：该命令将安装到整块硬盘而非分区/安装到U盘】(x_x)
   执行命令：     
   
     sudo bash chromeos-install.sh -src *.bin -dst 你的硬盘位置（例如/dev/sdx或/dev/mmcblkx,x为未知数）
             
            实例：sudo bash chromeos-install.sh -src *.bin -dst /dev/sda  （请勿照搬）
        
   ###### 没错，你已经好了，请[跳转到最后的语句](#4结束语句)吧！◑﹏◐
   
  ##### 3.2.2 安装到单一分区
   执行命令：
   
     sudo mkdir /mnt/tmpch
        
     sudo mount /dev/sdxx /mnt/tmpch    (sdxx是你要安装的分区，例如sda4，可以是ext4也可以是其他的)
        
     sudo bash chromeos-install.sh -src *.bin -dst /mnt/tmpch/chromeos.img -s 你要分配给ChromeOS的空间大小，单位GB。 （其中系统大概会占10GB。如果你要填满整个分区，就删去-s参数）

   等待镜像写入结束，屏幕上会出现引导该系统的grub参数，将其复制并保存到你乐意存的地方，填入你已安装的grub的配置文件，如果你未安装grub且不知道该如何引导系统，请继续执行命令：
   
     sudo mkdir /mnt/efi
        
     sudo mkdir /mnt/imgefi
        
     sudo mount 填写你efi分区的位置一般是/dev/sda1 /mnt/efi
        
     sudo mount -v -o offset=1235226624 -t vfat /mnt/tmpch/chromeos.img /mnt/imgefi
        
     sudo cp -r /mnt/imgefi/efi/boot ~/
        
     sudo mv ~/boot ~/ChromeOS
        
     sudo nano ~/ChromeOS/grub.cfg
        
        删掉里面的内容，把之前保存下来的配置粘贴进去
        Ctrl+X退出，y保存，回车确认，修改完毕
        
     sudo cp -r ~/ChromeOS /mnt/efi/efi
        
     sudo efibootmgr -c -l '\efi\ChromeOS\grubx64.efi' -L ChromeOS （若efi引导分区不在/dev/sda，则需-d参数手动指定）
                        
   ###### 没错，你好了，请跳转到最后的语句吧，诶？好像不用跳了呢...⊙_⊙
   
### 4.结束语句   
   好的，很显然，你的安装已经结束了，重启选择新的条目，初次进入的话，你会看到Brunch的LOGO，并且在这个界面等待数分钟，即可进入激动人心的MIUI啦，不对，是扣人心弦，也不是，哦，对了，是清爽流畅的ChromeOS了
   如果你重启碰到了一个蓝底的菜单，那么请你进BIOS把secure BOOT给他关了。如果你就是不想关，也可以在这个蓝屏一样的菜单里安装一个类似证书？密钥之类的东西，大概要这么选："OK->Enroll key from disk->EFI-SYSTEM->brunch.der->Continue"，然后重启即可。
   
## 其他
   其他东西当然是以后再说啦...🕊️🕊️
