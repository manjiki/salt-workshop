elasticsearch:
  config:
    cluster.name: {{salt['grains.get']('elasticsearch:cluster', "kaylee")}}
    node.name: {{salt['grains.get']('fqdn')}}
    node.master: true
    node.data: true
    bootstrap.mlockall: true
    transport.tcp.compress: true
