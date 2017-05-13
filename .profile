export LC_CTYPE=en_US.UTF-8

export HISTTIMEFORMAT='%F %T '
export TIMEFORMAT='Elapsed Time: %Rs'

# all manual locations
if [ ! -f /usr/bin/manpath ] ; then
echo "manpath exported"; export MANPATH=/usr/man
[ -d ${HOME}/man ] && export MANPATH=${MANPATH}:${HOME}/man
[ -d /svaha/courier/man ] && export MANPATH=${MANPATH}:/svaha/courier/man
[ -d /svaha/webalizer/man ] && export MANPATH=${MANPATH}:/svaha/webalizer/man
[ -d /svaha/apache2/man ] && export MANPATH=${MANPATH}:/svaha/apache2/man
[ -d /var/qmail/man ] && export MANPATH=${MANPATH}:/var/qmail/man
[ -d /usr/local/ssl/man ] && export MANPATH=${MANPATH}:/usr/local/ssl/man
[ -d /usr/local/man ] && export MANPATH=${MANPATH}:/usr/local/man
[ -d /opt/sfw/man ] && export MANPATH=${MANPATH}:/opt/sfw/man
[ -d /opt/local/man ] && export PATH=${MANPATH}:/opt/local/man
[ -d /usr/sfw/man ] && export MANPATH=${MANPATH}:/usr/sfw/man
[ -d /opt/gnome/man ] && export MANPATH=${MANPATH}:/opt/gnome/man
[ -d /usr/dt/man ] && export MANPATH=${MANPATH}:/usr/dt/man
[ -d /usr/openwin/man ] && export MANPATH=${MANPATH}:/usr/openwin/man
[ -d /usr/skunk/man ] && export MANPATH=${MANPATH}:/usr/skunk/man
[ -d /usr/share/man ] && export MANPATH=${MANPATH}:/usr/share/man
[ -d /usr/man ] && export MANPATH=${MANPATH}:/usr/man
export MANPATH=./man:${MANPATH}
fi

# set up basic path
export PATH=/usr/bin:/bin
[ -d /sbin ] && export PATH=/sbin:${PATH}
[ -d /usr/sbin ] && export PATH=/usr/sbin:${PATH}
[ -d /usr/sadm/bin ] && export PATH=/usr/sadm/bin:${PATH}
[ -d /usr/ccs/bin ] && export PATH=/usr/ccs/bin:${PATH}
[ -d /usr/local/sbin ] && export PATH=/usr/local/sbin:${PATH}
[ -d /usr/bin/X11 ] && export PATH=/usr/bin/X11:${PATH}
[ -d /usr/X11R6/bin ] && export PATH=/usr/X11R6/bin:${PATH}
[ -d /usr/openwin/bin ] && export PATH=/usr/openwin/bin:${PATH}
[ -d /usr/dt/bin ] && export PATH=/usr/dt/bin:${PATH}
[ -d /usr/local/bin ] && export PATH=/usr/local/bin:${PATH}
[ -d /opt/local/bin ] && export PATH=/opt/local/bin:${PATH}
[ -d /opt/local/sbin ] && export PATH=/opt/local/sbin:${PATH}
[ -d /opt/gnome/bin ] && export PATH=/opt/gnome/bin:${PATH}
[ -d /usr/sfw/bin ] && export PATH=/usr/sfw/bin:${PATH}
[ -d /opt/sfw/bin ] && export PATH=/opt/sfw/bin:${PATH}
[ -d /svaha/courier/sbin ] && export PATH=/svaha/courier/sbin:${PATH}
[ -d /usr/local/ssl/bin ] && export PATH=/usr/local/ssl/bin:${PATH}
[ -d /usr/local/BerkeleyDB.3.3/bin ] && export PATH=/usr/local/BerkeleyDB.3.3/bin:${PATH}
test -r /sw/bin/init.sh && . /sw/bin/init.sh
[ -d ${HOME}/bin ] && export PATH=${HOME}/bin:${PATH}
export PATH=${PATH}:.


echo "Sourcing ~/.bashrc"
source ~/.bashrc

