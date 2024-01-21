#!/bin/bash -eux

pip3 uninstall -y ansible

echo "Installing cloud-init..."
dnf -y install cloud-init

# Manage Ansible access
groupadd -g 1001 ansible
useradd -m -g 1001 -u 1001 ansible
mkdir /home/ansible/.ssh
mkdir -p /home/admin/.ssh/
echo -e "ssh_pub_key_here" >  /home/ansible/.ssh/authorized_keys
echo -e "ssh_pub_key_here" >  /home/admin/.ssh/authorized_keys
chown -R ansible:ansible /home/ansible/.ssh
chown -R admin:admin /home/admin/.ssh
chmod 700 /home/ansible/.ssh
chmod 700 /home/admin/.ssh
chmod 600 /home/ansible/.ssh/authorized_keys
chmod 600 /home/admin/.ssh/authorized_keys
echo "ansible ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible
echo "admin ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/admin
chmod 440 /etc/sudoers.d/ansible
chmod 440 /etc/sudoers.d/admin

systemctl enable vmtoolsd
systemctl start vmtoolsd

# see https://bugs.launchpad.net/cloud-init/+bug/1712680
# and https://kb.vmware.com/s/article/71264
# Virtual Machine customized with cloud-init is set to DHCP after reboot
echo "manual_cache_clean: True " > /etc/cloud/cloud.cfg.d/99-manual.cfg

echo "Disable NetworkManager-wait-online.service"
systemctl disable NetworkManager-wait-online.service

# cleanup current SSH keys so templated VMs get fresh key
rm -f /etc/ssh/ssh_host_*

# Avoid ~200 meg firmware package we don't need
# this cannot be done in the KS file so we do it here
echo "Removing extra firmware packages"
dnf -y remove linux-firmware
dnf -y autoremove

echo "Remove previous kernels that preserved for rollbacks"
dnf -y remove -y $(dnf repoquery --installonly --latest-limit=-1 -q)
dnf -y clean all  --enablerepo=\*;

echo "truncate any logs that have built up during the install"
find /var/log -type f -exec truncate --size=0 {} \;

echo "remove the install log"
rm -f /root/anaconda-ks.cfg /root/original-ks.cfg

echo "remove the contents of /tmp and /var/tmp"
rm -rf /tmp/* /var/tmp/*

echo "Force a new random seed to be generated"
rm -f /var/lib/systemd/random-seed

echo "Wipe netplan machine-id (DUID) so machines get unique ID generated on boot"
truncate -s 0 /etc/machine-id

echo "Configuring SSH for password and public key authentication"
sed -i '/^PasswordAuthentication/d' /etc/ssh/sshd_config
sed -i '/^PubkeyAuthentication/d' /etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
echo "UsePAM yes" >> /etc/ssh/sshd_config
sed -i 's/^Include \/etc\/ssh\/sshd_config.d\/\*.conf/#&/' /etc/ssh/sshd_config
rm -r /etc/ssh/sshd_config.d/50-redhat.conf
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

echo "Clear the history so our install commands aren't there"
rm -f /root/.wget-hsts
export HISTSIZE=0

# Add `sync` so Packer doesn't quit too early
sync
