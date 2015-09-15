dir=$(cd `dirname $0`;pwd)

# 先检测本目录下是否存在tmux.conf文件 不存在创建一个
if [ ! -f "$dir/tmux.conf" ];then
    touch "$dir/tmux.conf"
fi

#创建一个plugin目录
if [ ! -d "$dir/plugin" ];then
    mkdir "$dir/plugin"
fi

# 软链接home目录的.tmux.conf 到 本目录下的tmux.conf文件
ln -snf "$dir/tmux.conf" ~/.tmux.conf

# 软链接当前目录到home/.tmux
ln -snf "$dir" ~/.tmux

# 找到powerline的安装目录
pydir=`pip show powerline-status |grep Location |awk -F: '{print $2}'`
pwl=`echo ${pydir//[[:blanl:]]/}/powerline`
# powerline未安装的话就安装
if [ ! -d "$pwl" ];then
    pip=`which pip`
    if [ -n "$pip" ];then
        $pip install powerline-status
    else
        echo "can't find pip, please install powerline-status manully."
    fi
fi
ln -sf "$pwl" "$dir/plugin/"

# 下载sshh插件 可以分割窗口的时候保持ssh连接
wget -O "$dir/plugin/sshh" "https://raw.githubusercontent.com/yudai/sshh/master/sshh" && chmod a+x "$dir/plugin/sshh"

# 需要设置plugin目录到环境变量 这里假设是ubuntu系统
echo "export PATH=$dir/plugin:\$PATH\n" >> ~/.bashrc
. ~/.bashrc
echo ""
echo "Everything done, enjoy tmux, ^-^.";
