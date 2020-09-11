#!/data/data/com.termux/files/usr/bin/bash
pkg install proot -y
folder=ubuntu-fs64
                case `dpkg --print-architecture`
		aarch64)
			archurl="amd64";
			wget https://github.com/AllPlatform/Termux-UbuntuX86_64/raw/master/arm64/qemu-x86_64-static;
			chmod 777 qemu-x86_64-static;
			mv qemu-x86_64-static ~/../usr/bin ;;
		arm)
			archurl="amd64";
			wget https://github.com/AllPlatform/Termux-UbuntuX86_64/raw/master/arm/qemu-x86_64-static;
			chmod 777 qemu-x86_64-static;
			mv qemu-x86_64-static ~/../usr/bin/ ;;
		amd64)
			archurl="amd64" ;;
		x86_64)
			archurl="amd64" ;;	
		i*86)
			archurl="i386" ;;
		x86)
			archurl="i386" ;;
		*)
			echo "unknown architecture"; exit 1 ;;

fi
mkdir -p kali-binds
bin=start-kali.sh
echo "writing launch script"
cat > $bin <<- EOM
#!/bin/bash
cd \$(dirname \$0)
## unset LD_PRELOAD in case termux-exec is installed
unset LD_PRELOAD
command="proot"
command+=" --link2symlink"
command+=" -0"
command+=" -r $folder -q qemu-x86_64-static"
command+=" -b /dev"
command+=" -b /proc"
command+=" -b ubuntu-fs64/root:/dev/shm"
## uncomment the following line to have access to the home directory of termux
#command+=" -b /data/data/com.termux/files/home:/root"
## uncomment the following line to mount /sdcard directly to / 
#command+=" -b /sdcard"
command+=" -w /root"
command+=" /usr/bin/env -i"
command+=" HOME=/root"
command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
command+=" TERM=\$TERM"
command+=" LANG=C.UTF-8"
command+=" /bin/bash --login"
com="\$@"
if [ -z "\$1" ];then
    exec \$command
else
    \$command -c "\$com"
fi
EOM

echo "fixing shebang of $bin"
termux-fix-shebang $bin
echo "making $bin executable"
chmod +x $bin
echo "removing image for some space"
rm $tarball
echo "You can now launch Kali with the ./${bin} script"
