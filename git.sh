##
git��github��ʲô��ϵ������˵����������£�Ҳ��˵�ǲֿ�

git��һ�����ߣ� github��һ����վ github.com �� ��һ����git���ݵĴ������ֿ⣬���ߵ�ƽ̨��




git add;get commit -m "";
git status ;git diff
git checkout -- xx
git reset HEAD 
git reset --hard cxxcxx

yum install -y epel-release 
yum install -y git



��װ��ɺ󣬻���Ҫ���һ������
git config --global user.name "Your Name" //���� abc
git config --global user.email "abc@linux.com" //д�������


�����汾�ֿⲢ�����ļ�{
mkdir /home/gitroot
cd /home/gitroot
git init
#��ʼ��,�����Ŀ¼���git���Թ���Ĳֿ� ls -a ���Կ�������һ��.git�ļ���
echo aaa >1.txt
git add 1.txt
#��1.txt��ӵ��ֿ���
git commit -m "add new file 1.txt" 
#add���˱���Ҫcommit�����������ļ��ύ���ֿ���
echo -e "adads\nadadad" >>1.txt
git  status
#�鿴��ǰ�ֿ��״̬,�����Ƿ��иĶ����ļ�
git diff  1.txt
#��Ƚϲֿ����1.txt,�Աȱ����޸���ʲô����,

}
�汾���{
git log
#�鿴�����ύgit�ֿ�ļ�¼����
git log --pretty=oneline
#ͬ��,ֻ��һ����ʾ
ͨ��git log���Բ鿴��ȥ�ύ�����а汾,������,����ָ������ĳ���汾
git reset  --hard ofadaf
#���˵�ofadaf�汾,�汾�ſ�����д
�����˵�����汾��,git log ��ð汾��İ汾������ʾ��,
git reflog
#��ʾ���а汾

###�汾������޷�push;�Ȱ��뱣�����ļ����Ƶ���ĵط�,�� git pull;�ٰ��ļ�mv����,Ȼ��Ϳ���git push��------------------------------------
���֡����ˡ������ڷ�����ʷ�������������Ҳ�������remote����push�Ժ������ںε��أ�

���ԣ�����������Լ���ʹ�ã���ôǿ��push��������
git push -f ��������˺�������Ư����������revert��

git revert ���� ĳ�β������˴β���֮ǰ��֮���commit��history���ᱣ�������Ұ���γ���
��Ϊһ�����µ��ύ
    * git revert HEAD                  ����ǰһ�� commit
    * git revert HEAD^               ����ǰǰһ�� commit
    * git revert commit �����磺fa042ce57ebbe5bb9c8db709f719cec2c58ee7ff������ָ���İ汾������Ҳ����Ϊһ���ύ���б��档
git revert���ύһ���µİ汾������Ҫrevert�İ汾�������ٷ����޸Ļ�ȥ��
�汾���������Ӱ��֮ǰ�ύ������

}
�ļ��ָ�{
#�����ļ�����,��ָ����ϴ��ύ��״̬,����
git checkout  --1.txt

#���1.txt�޸�����,�����git add 1.txt��,��û��commit,����˵��ϴ��ύ��״̬,����:
git reset HEAD  1.txt
git checkout --1.txt
#Ȼ����checkout
����ļ� add ,Ҳcommit��,�����ð汾����ķ���

}
�ļ�ɾ��{
rm -f xx
#��ɾ��
git rm xx
git commit -m "delete  xx"

}
����һ��Զ�ֿ̲⣨github��{
���ȵ� https://github.com ע��һ���˺ţ������Լ���git����repositories �ٵ�new
�����Զ��壬�����studygit  ѡ��public  �� create repository
���key�����Ͻǵ��Լ�ͷ��ѡ��settings�����ѡ��SSH and GPG keys
����New SSH key����linux�����ϵ�~/.ssh/id_rsa.pub����ճ��������
�ѱ��زֿ����͵�Զ�ֿ̲�
git remote add origin git@github.com:Guanjianwei/studygit.git
####��һ�����ڱ�������һ��Զ�ֿ̲�studygit,���־����ͱ��ص�һ��
git push -u origin master  //Ȼ��ѱ��ص�studygit�ֿ����͵�Զ�̵�studygit
��һ�������ͣ��Ϳ���ֱ�� git push 
git  pull
##ͬ��Զ�ֿ̲⵽����
*****************

}
��¡һ��Զ�ֿ̲�{
cd /home
git clone  git@github.com:aminglinux/lanmp.git
git clone git@github.com:guanjianwei/studygit.git
git init
����ʾ�����ڵ�ǰĿ¼�³�ʼ��һ���ֿ⣬������һ��.git��Ŀ¼������
Initialized empty Git repository in /home/lanmp/.git/
��ɺ�ls���Կ���һ��lanmp��Ŀ¼
cd  lanmp
vi lanmp.sh �༭һ���ļ���Ȼ���ύ
git add lanmp.sh
git commit -m "sdlfasdf" 
Ȼ�������͵�Զ�̷����
git push


git fetch 
��ȡ

}
��֧����{
git branch //�鿴��֧
git branch aming  //������֧
git checkout  aming //�л�����aming��֧��
����git branch�鿴���ῴ����������֧master��aming����ǰʹ�õķ�֧ǰ�����һ��*
��aming��֧�� ���༭2.txt�����ύ���·�֧
echo "askdfjlksadjflk" >  2.txt
git add 2.txt
git commit -m "laksjdflksjdklfj" 
�л���master��֧
git checkout master
��ʱcat 2.txt���ֲ�û�и�������

}
��֧�ĺϲ���ɾ��{
git merge aming   //��aming��֧�ϲ�����master
���master��֧��aming��֧����2.txt�����˱༭�����ϲ�ʱ����ʾ��ͻ����Ҫ�Ƚ����ͻ�ſ��Լ����ϲ���
�����ͻ�ķ�������master��֧�£��༭2.txt����Ϊaming��֧����2.txt�����ݡ� Ȼ���ύ2.txt���ٺϲ�aming��֧��
����������һ�����⣬��һmaster��֧���ĵ�������������Ҫ���أ� ���Ա༭2.txt���ݣ���Ϊ��Ҫ�ģ�Ȼ���ύ���л���aming��֧��Ȼ��ϲ�master��֧��aming��֧���ɡ������źϲ����ϲ���֧��һ��ԭ���Ǿ���Ҫ�����µķ�֧�ϲ����ɵķ�֧��Ҳ����˵merge������ķ�֧����һ�������µķ�֧��
git  branch -d aming //ɾ����֧
�����֧û�кϲ���ɾ��֮ǰ����ʾ���ǾͲ��ϲ���ǿ��ɾ��
git branch -D aming

git branch -a
#�鿴���еķ�֧������Զ�̵�
git branch -r -d origin/test
#ɾ��Զ�̷�֧�ڱ��ص�Ŀ¼
git push origin :test
#ɾ��Զ�̷�֧test


}
Զ�̷�֧����{
git remote -v
#�鿴Զ�̿���Ϣ
git ls-remote origin 
#�鿴Զ�̷�֧

git push origin  test
#����test��֧��Զ�̷�֧
git checkout -b test origin/test
#�ڱ��ش��� Զ�̷�֧test�Ķ�Ӧ����

git pull  = git fetch  ;git merge origin xx
ͬ��Զ�ֿ̲⵽����
git branch -a
#�鿴���еķ�֧������Զ�̵�
git branch -r -d origin/test
#ɾ��Զ�̷�֧�ڱ��ص�Ŀ¼
git push origin :test
#ɾ��Զ�̷�֧test
һ����ȡ�����ϲ����ڵ�Զ�̷�֧��
git checkout -b new_branch origin/new_branch


}
��ǩ����{
#####��ǩ���� ���� ����,���Ը��汾���һ����ǩ,��¼ĳʱ�̿��״̬,Ҳ������ʱ�ָ�����״̬

git checkout master
git tag v1.0     #��master�����ǩ
git tag          #�鿴��ǩ��״̬
git show v1.0  		#�鿴v1.0��ǩ������
�汾����
git reset --hard  xxx #��ǩ������commit id


##tag�����commit�����ǩ��,�ʿ��������ʷ��commit���ǩ
git log --pretty=oneline --abbrev-commit  #�鿴��ʷ��commit
git tag v2.0  3dsed		#�����ʷcommit���ǩ


git tag -a v0.8 -m "tag just v1.1 and so on"  5aacaf4  //���ԶԱ�ǩ��������
git tag -d v0.8  #ɾ����ǩ
git push origin v1.0   //����ָ����ǩ��Զ��
git push --tag origin   //�������б�ǩ
�������ɾ����һ����ǩ��Զ��Ҳ��Ҫɾ����Ҫ����������
git tag v1.0 -d    //ɾ�����ر�ǩ
git push origin :refs/tags/v1.0   //ɾ��Զ�̱�ǩ


}

git��������{
git config --golbal alias.ci commit
#Ϊcommit���ñ���ci
git config --global aias.br branch
git config --global alias.co checkout

git config --global --unset alias.ci #ȡ������
git config --list|grep alias 
#�鿴����
git 

��ѯlogС���ɣ�
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"







}

�git������{
yum install -y epel-release
yum install git -y
useradd -s /usr/bin/git-shell git
cd /home/git
mkdir .ssh
vim .ssh/authorized_keys
chown -R git.git .ssh
chmod 600  -R .ssh

#���崢��git�ֿ��Ŀ¼
mkdir /data/gitroot

cd /data/gitroot

git init --bare sample.git 
#�ᴴ��һ����ֿ⣬��ֿ�û�й���������Ϊ�������ϵ�Git�ֿⴿ����Ϊ�˹������Բ����û�ֱ�ӵ�¼����������ȥ�Ĺ����������ҷ������ϵ�Git�ֿ�ͨ������.git��β
chown -R git.git sample.git



�ͻ����ϣ��Լ�pc����¡Զ�ֿ̲�
git clone git@ip:/data/gitroot/sample.git
��ʱ�Ϳ����ڵ�ǰĿ¼������һ��sample��Ŀ¼������������ǿ�¡��Զ�ֿ̲��ˡ����뵽�����棬���Կ���һЩ���룬Ȼ��push��Զ�̡�





}
git��¼,���ǲ���¼,����shell��/usr/bin/git-shell;
����ƽʱ�õ���/bin/bash,�Ǻ�ϵͳͨ�ŵ�shell, git�û���¼��,��Ҫ��git�Լ���shellͨ�ŵ�;���ָ��Ϊnologin,���޷�ʹ��git��������

�ֳ�����{

#�������ڽ�����Ŀ��ĳһ���ֵĹ���������Ķ�������һ���Ƚ����ҵ�״̬��������ת��������֧�Ͻ���һЩ�����������ǣ��㲻���ύ������һ��Ĺ����������Ժ����޷��ص���������㡣����������İ취����
git stash���
����������aming��֧���༭��һ���µ��ļ�3.txt
��ʱ��������Ҫ��������֧ȥ�޸�һ��bug��������Ҫ��git add 3.txt
Ȼ�� git  stash  ����һ���ֳ�
���л��������֧ȥ�޸�bug���޸���bug���ٻص�aming��֧
git stash list ���Կ������Ǳ�������ֳ�
�� git stash apply �ָ��ֳ�
Ҳ����ָ��stash��
git stash apply stash@{1}



}























