##
git和github有什么关系吗？有人说这个是两码事，也有说是仓库

git是一个工具， github是一个网站 github.com ， 是一个和git兼容的代码管理仓库，在线的平台。




git add;get commit -m "";
git status ;git diff
git checkout -- xx
git reset HEAD 
git reset --hard cxxcxx

yum install -y epel-release 
yum install -y git



安装完成后，还需要最后一步设置
git config --global user.name "Your Name" //比如 abc
git config --global user.email "abc@linux.com" //写你的邮箱


创建版本仓库并推送文件{
mkdir /home/gitroot
cd /home/gitroot
git init
#初始化,让这个目录变成git可以管理的仓库 ls -a 可以看到多了一个.git文件夹
echo aaa >1.txt
git add 1.txt
#把1.txt添加到仓库中
git commit -m "add new file 1.txt" 
#add完了必须要commit才算真正把文件提交到仓库中
echo -e "adads\nadadad" >>1.txt
git  status
#查看当前仓库的状态,比如是否有改动的文件
git diff  1.txt
#相比较仓库里的1.txt,对比本次修改了什么内容,

}
版本变更{
git log
#查看所有提交git仓库的记录操作
git log --pretty=oneline
#同上,只是一行显示
通过git log可以查看过去提交的所有版本,根据它,可以指定回退某个版本
git reset  --hard ofadaf
#回退到ofadaf版本,版本号可以缩写
当回退到这个版本后,git log 则该版本后的版本不再显示了,
git reflog
#显示所有版本

###版本变更后无法push;先把想保留的文件复制到别的地方,在 git pull;再把文件mv回来,然后就可以git push了------------------------------------
这种“回退”就是在否认历史，如果有其他人也在用你的remote，你push以后将他置于何地呢？

所以，如果仅仅你自己在使用，那么强制push，命令是
git push -f 如果是与人合作，更漂亮的做法是revert，

git revert 撤销 某次操作，此次操作之前和之后的commit和history都会保留，并且把这次撤销
作为一次最新的提交
    * git revert HEAD                  撤销前一次 commit
    * git revert HEAD^               撤销前前一次 commit
    * git revert commit （比如：fa042ce57ebbe5bb9c8db709f719cec2c58ee7ff）撤销指定的版本，撤销也会作为一次提交进行保存。
git revert是提交一个新的版本，将需要revert的版本的内容再反向修改回去，
版本会递增，不影响之前提交的内容

}
文件恢复{
#发现文件不对,想恢复到上次提交的状态,可以
git checkout  --1.txt

#如果1.txt修改完了,保存后git add 1.txt了,但没有commit,想回退到上次提交的状态,可以:
git reset HEAD  1.txt
git checkout --1.txt
#然后在checkout
如果文件 add ,也commit了,可以用版本变更的方法

}
文件删除{
rm -f xx
#先删除
git rm xx
git commit -m "delete  xx"

}
创建一个远程仓库（github）{
首先到 https://github.com 注册一个账号，创建自己的git，点repositories 再点new
名字自定义，比如叫studygit  选择public  点 create repository
添加key：右上角点自己头像，选择settings，左侧选择SSH and GPG keys
左侧点New SSH key，把linux机器上的~/.ssh/id_rsa.pub内容粘贴到这里
把本地仓库推送到远程仓库
git remote add origin git@github.com:Guanjianwei/studygit.git
####这一步是在本地增加一个远程仓库studygit,名字尽量和本地的一致
git push -u origin master  //然后把本地的studygit仓库推送到远程的studygit
下一次再推送，就可以直接 git push 
git  pull
##同步远程仓库到本地
*****************

}
克隆一个远程仓库{
cd /home
git clone  git@github.com:aminglinux/lanmp.git
git clone git@github.com:guanjianwei/studygit.git
git init
它提示，会在当前目录下初始化一个仓库，并创建一个.git的目录，如下
Initialized empty Git repository in /home/lanmp/.git/
完成后，ls可以看到一个lanmp的目录
cd  lanmp
vi lanmp.sh 编辑一下文件，然后提交
git add lanmp.sh
git commit -m "sdlfasdf" 
然后再推送到远程服务端
git push


git fetch 
获取

}
分支管理{
git branch //查看分支
git branch aming  //创建分支
git checkout  aming //切换到了aming分支下
再用git branch查看，会看到有两个分支master和aming，当前使用的分支前面会有一个*
在aming分支下 ，编辑2.txt，并提交到新分支
echo "askdfjlksadjflk" >  2.txt
git add 2.txt
git commit -m "laksjdflksjdklfj" 
切换回master分支
git checkout master
此时cat 2.txt发现并没有更改内容

}
分支的合并与删除{
git merge aming   //把aming分支合并到了master
如果master分支和aming分支都对2.txt进行了编辑，当合并时会提示冲突，需要先解决冲突才可以继续合并。
解决冲突的方法是在master分支下，编辑2.txt，改为aming分支里面2.txt的内容。 然后提交2.txt，再合并aming分支。
但是这样有一个问题，万一master分支更改的内容是我们想要的呢？ 可以编辑2.txt内容，改为想要的，然后提交。切换到aming分支，然后合并master分支到aming分支即可。（倒着合并）合并分支有一个原则，那就是要把最新的分支合并到旧的分支。也就是说merge后面跟的分支名字一定是最新的分支。
git  branch -d aming //删除分支
如果分支没有合并，删除之前会提示，那就不合并，强制删除
git branch -D aming

git branch -a
#查看所有的分支，包括远程的
git branch -r -d origin/test
#删除远程分支在本地的目录
git push origin :test
#删除远程分支test


}
远程分支管理{
git remote -v
#查看远程库信息
git ls-remote origin 
#查看远程分支

git push origin  test
#推送test分支到远程分支
git checkout -b test origin/test
#在本地创建 远程分支test的对应副本

git pull  = git fetch  ;git merge origin xx
同步远程仓库到本地
git branch -a
#查看所有的分支，包括远程的
git branch -r -d origin/test
#删除远程分支在本地的目录
git push origin :test
#删除远程分支test
一键拉取本地上不存在的远程分支：
git checkout -b new_branch origin/new_branch


}
标签管理{
#####标签类似 快照 功能,可以给版本库打一个标签,记录某时刻库的状态,也可以随时恢复到改状态

git checkout master
git tag v1.0     #给master打个标签
git tag          #查看标签的状态
git show v1.0  		#查看v1.0标签的详情
版本回退
git reset --hard  xxx #标签详情中commit id


##tag是针对commit来打标签的,故可以针对历史的commit打标签
git log --pretty=oneline --abbrev-commit  #查看历史的commit
git tag v2.0  3dsed		#针对历史commit打标签


git tag -a v0.8 -m "tag just v1.1 and so on"  5aacaf4  //可以对标签进行描述
git tag -d v0.8  #删除标签
git push origin v1.0   //推送指定标签到远程
git push --tag origin   //推送所有标签
如果本地删除了一个标签，远程也想要删除需要这样操作：
git tag v1.0 -d    //删除本地标签
git push origin :refs/tags/v1.0   //删除远程标签


}

git别名设置{
git config --golbal alias.ci commit
#为commit设置别名ci
git config --global aias.br branch
git config --global alias.co checkout

git config --global --unset alias.ci #取消别名
git config --list|grep alias 
#查看别名
git 

查询log小技巧：
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"







}

搭建git服务器{
yum install -y epel-release
yum install git -y
useradd -s /usr/bin/git-shell git
cd /home/git
mkdir .ssh
vim .ssh/authorized_keys
chown -R git.git .ssh
chmod 600  -R .ssh

#定义储存git仓库的目录
mkdir /data/gitroot

cd /data/gitroot

git init --bare sample.git 
#会创建一个裸仓库，裸仓库没有工作区，因为服务器上的Git仓库纯粹是为了共享，所以不让用户直接登录到服务器上去改工作区，并且服务器上的Git仓库通常都以.git结尾
chown -R git.git sample.git



客户端上（自己pc）克隆远程仓库
git clone git@ip:/data/gitroot/sample.git
此时就可以在当前目录下生成一个sample的目录，这个就是我们克隆的远程仓库了。进入到这里面，可以开发一些代码，然后push到远程。





}
git登录,不是不登录,它的shell是/usr/bin/git-shell;
我们平时用的是/bin/bash,是和系统通信的shell, git用户登录后,是要和git自己的shell通信的;如果指定为nologin,就无法使用git服务器了

现场保留{

#当你正在进行项目中某一部分的工作，里面的东西处于一个比较杂乱的状态，而你想转到其他分支上进行一些工作。问题是，你不想提交进行了一半的工作，否则以后你无法回到这个工作点。解决这个问题的办法就是
git stash命令。
比如我们在aming分支，编辑了一个新的文件3.txt
这时候我们需要到其他分支去修复一个bug，所以需要先git add 3.txt
然后 git  stash  保存一下现场
再切换到另外分支去修复bug，修复完bug后，再回到aming分支
git stash list 可以看到我们保存过的现场
用 git stash apply 恢复现场
也可以指定stash：
git stash apply stash@{1}



}























