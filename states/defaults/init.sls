thebase:
  pkg.installed:
    - install_recommends: False
    - pkgs:
      - wget:
      - curl:
      - sysstat:
      - ethtool:
      - screen:

openssh-server:
  pkg.installed

an_ssh_bla:
  pkg.installed:
    - name: openssh-server
