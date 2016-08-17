import fabric.contrib.files
import yaml
from fabric.api import *

@task
def amazon_setname():
    sudo("echo '{0}.{1}' > /etc/hostname".format(env.name))
    sudo("hostname -F /etc/hostname")

@task
def install_saltminion(minion_conf):
    salt_repo_key = "wget --no-check-certificate -O /tmp/saltkey https://repo.saltstack.com/apt/debian/8/amd64/latest/SALTSTACK-GPG-KEY.pub && apt-key add /tmp/saltkey"
    salt_repo = "echo 'deb http://repo.saltstack.com/apt/debian/8/amd64/latest jessie main' > /etc/apt/sources.list.d/saltstack.list"
    apt_update = "apt-get update"
    install_pkgs = "DEBIAN_FRONTEND=noninteractive apt-get -y -q install salt-minion lsb-release sudo"
    sudo(salt_repo_key)
    sudo(salt_repo)
    sudo(apt_update)
    sudo(install_pkgs)
    sudo("echo '{0}'> /etc/salt/minion".format(minion_conf))
    sudo("echo '{0}'> /etc/salt/minion_id".format(env.name))

@task
def install_saltmaster(master_conf):
    install_pkgs = "DEBIAN_FRONTEND=noninteractive apt-get -y -q install salt-master"
    sudo(install_pkg)
    put(master_conf, "/etc/salt/master", use_sudo=True)



@task
def upgrade():
    sudo("DEBIAN_FRONTEND=noninteractive apt-get -y upgrade")

@task
def reboot(wait=240, **kwargs):
    #sudo("reboot")
    timeout = 5
    # This is from fabric.operations.reboot
    attempts = int(round(float(wait) / float(timeout)))
    with settings(
        hide('running'),
        timeout=timeout,
        connection_attempts=attempts
    ):
        sudo("reboot")
        time.sleep(5)
        connections.connect(env.host_string)
        sudo("uptime")

@task
def amazon_bootstrap(user,key_filename=None, name=None):
    minion_conf = "master: 127.0.0.1\nlog_level_logfile: debug"
    master_conf = "master"
    env.key_filename = key_filename
    env.name = name
    env.user = user
    amazon_setname()
    install_saltminion(minion_conf)
    install_saltmaster(master_conf)
    upgrade()
    reboot()


if __name__ == "__main__":
    main()
