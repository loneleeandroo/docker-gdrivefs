FROM 		base/archlinux
MAINTAINER 	LoneleeAndroo

# Update System and install packer

ADD             https://aur.archlinux.org/packages/pa/packer/packer.tar.gz /tmp/packer.tar.gz

RUN		pacman -Syu --ignore filesystem --noconfirm && \
		pacman -S base-devel fakeroot jshon expac --noconfirm && \
		cd tmp && \
		tar -xzf packer.tar.gz && \
		cd /tmp/packer && \
		makepkg -s --asroot --noconfirm && \
		pacman -U /tmp/packer/packer*.tar.xz --noconfirm

# Install supervisor

RUN		pacman -S supervisor --noconfirm && \
		pacman -Scc --noconfirm

# Install gdrivefs

RUN		packer -S python2-pip python2-six python2-fusepy-git python2-google-api-python-client --noconfirm && \
		pacman -Scc --noconfirm && \
		pip2 install ez-setup && \
		pip2 install --allow-unverified antlr-python-runtime --allow-external antlr-python-runtime gdrivefs

# Setup environment

ENV             HOME /root

RUN		mkdir -p /home/nobody /root && \
		chown -R nobody:users /home/nobody /root && \
		chmod -R 775 /home/nobody /root

# Additional files

ADD             supervisor.conf /etc/supervisor.conf

ADD             start.sh /start.sh
RUN             chmod u+rwx /start.sh

# Finish

ENTRYPOINT 	["/start.sh"]
