# Salt workshop repo

Setting up salt master and minion

* Login to chuck using your account and ssh key
* `$ git clone https://github.com/manjiki/salt-workshop`
* `$ cd salt-workshop`
* `$ virtualenv saltstack`
* `$ source saltstack/bin/activate`
* `$ fab -H 10.10.10.10 amazon_bootstrap:admin,key_filename=ff.pem,name=firefly`
* get host's eth0 IP address and add it in /etc/hosts 

Getting around

* `$ salt-key -L`
* `$ salt-key -A`
* `$ salt 'firefly' grains.items`
* `$ salt 'firefly' grains.item os_family`
* `$ salt 'firefly' grains.item id`
* `$ salt 'firefly' pillar.data`
* `$ salt 'firefly' status.uptime`  
* `$ salt 'firefly' network.ip_addrs`
* `$ salt 'firefly' cmd.run 'ls -la /tmp'`
* `$ salt 'firefly' pkg.install nginx`
* `$ salt 'firefly' service.restart nginx`
* `$ salt 'firefly' pkg.purge nginx`
* `$ salt '*' test.ping`
* `$ salt-run jobs.list_jobs`

Events

* Open a second terminal, login and do a 
* `$ salt-run state.event pretty=True`
* on your original terminal and run any of the above commands


Highstate and topfiles

* `$ salt firefly state.highstate` (you will get a failed state message)
    * Comment: No Top file or external nodes data matches found.
* Create the following directories: `/etc/salt/pillars, /etc/salt/states, /etc/salt/states/defaults`
* Create the file `/etc/salt/states/top.sls`:
```
base:
  '*':
    - defaults
```
* `$ salt firefly state.highstate` (you will get a failed state message, again)
    * - No matching sls found for 'defaults' in env 'base'
* edit `/etc/salt/states/defaults/init.sls` with the following contents:
```
nginx_lalalal:
  pkg.installed:
    - name: nginx

nginx:
  pkg.installed
```
* `$ salt firefly state.highstate` or `$ salt firefly state.sls defaults`
* Congrats! You just run your first salt state!
