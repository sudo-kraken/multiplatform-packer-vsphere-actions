#!/usr/bin/bash

# Prepares a Ubuntu Server guest operating system.

### Create a cleanup script. ###
echo '> Creating cleanup script ...'
sudo cat <<EOF > /tmp/cleanup.sh
#!/bin/bash

# Apt Cleanup
echo '> Cleaning apt-get ...'
apt autoremove -y
apt clean

# Disable IPv6
echo net.ipv6.conf.all.disable_ipv6=1 | sudo tee -a /etc/sysctl.conf
echo net.ipv6.conf.default.disable_ipv6=1 | sudo tee -a /etc/sysctl.conf
echo net.ipv6.conf.l0.disable_ipv6=1 | sudo tee -a /etc/sysctl.conf
sysctl -p

# Stop services for cleanup
service rsyslog stop

# Cleans all audit logs.
echo '> Cleaning all audit logs ...'
if [ -f /var/log/audit/audit.log ]; then
cat /dev/null > /var/log/audit/audit.log
fi
if [ -f /var/log/wtmp ]; then
cat /dev/null > /var/log/wtmp
fi
if [ -f /var/log/lastlog ]; then
cat /dev/null > /var/log/lastlog
fi

# Cleans persistent udev rules.
echo '> Cleaning persistent udev rules ...'
if [ -f /etc/udev/rules.d/70-persistent-net.rules ]; then
rm /etc/udev/rules.d/70-persistent-net.rules
fi

# Cleans /tmp directories.
echo '> Cleaning /tmp directories ...'
rm -rf /tmp/*
rm -rf /var/tmp/*

# Cleans SSH keys.
echo '> Cleaning SSH keys ...'
rm -f /etc/ssh/ssh_host_*

# Add check for ssh keys on reboot...regenerate if neccessary
cat << 'EOL' | sudo tee /etc/rc.local
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.
# dynamically create hostname (optional)
if hostname | grep localhost; then
    hostnamectl set-hostname "$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '')"
fi
test -f /etc/ssh/ssh_host_dsa_key || dpkg-reconfigure openssh-server
exit 0
EOL

# Make sure the script is executable
chmod +x /etc/rc.local

# Sets hostname to localhost.
# Prevent cloudconfig from preserving the original hostname
sed -i 's/preserve_hostname: false/preserve_hostname: true/g' /etc/cloud/cloud.cfg
truncate -s0 /etc/hostname
hostnamectl set-hostname localhost

# Cleans the machine-id.
echo '> Cleaning the machine-id ...'
truncate -s 0 /etc/machine-id
rm /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id

# Cleans shell history.
echo '> Cleaning shell history ...'
unset HISTFILE
history -cw
echo > ~/.bash_history
rm -fr /root/.bash_history

# Cloud Init Nuclear Option
rm -rf /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg
rm -rf /etc/cloud/cloud.cfg.d/99-installer.cfg
echo "disable_vmware_customization: false" >> /etc/cloud/cloud.cfg
echo "# to update this file, run dpkg-reconfigure cloud-init
datasource_list: [ VMware, OVF, None ]" > /etc/cloud/cloud.cfg.d/90_dpkg.cfg

# Set boot options to not override what we are sending in cloud-init
echo `> modifying grub`
sed -i -e "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\"/" /etc/default/grub
update-grub
EOF

### Change script permissions for execution. ###
echo '> Changeing script permissions for execution ...'
sudo chmod +x /tmp/cleanup.sh

### Executes the cleauup script. ###
echo '> Executing the cleanup script ...'
sudo /tmp/cleanup.sh

### All done. ###
echo '> Done.'

# Make mount point for future data drive
mkdir /mnt/DATA-DRIVE

# Remove Networking
rm /etc/netplan/00-installer-config.yaml

# Echo Complete
echo '> Packer Template Build -- Complete'
