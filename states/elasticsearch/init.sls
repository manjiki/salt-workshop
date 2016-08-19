elasticsearch.yml:
  file.managed:
    - name: /etc/elasticsearch/elasticsearch.yml
    - source: salt://elasticsearch/elasticsearch.yml.j2
    - template: jinja
    - context:
      elasticsearch: {{salt['pillar.get']('elasticsearch')}}
    - backup: minion
    - makedirs: True

elasticsearch:
  pkgrepo.managed:
    - humanname: Elasticsearch Official Debian Repository
    - name: deb http://packages.elasticsearch.org/elasticsearch/1.5/debian stable main
    - key_url: http://packages.elasticsearch.org/GPG-KEY-elasticsearch
    - file: /etc/apt/sources.list.d/elasticsearch.list
  pkg:
    - installed
    - hold: True
    - require:
      - pkgrepo: elasticsearch
      - file: elasticsearch.yml
      - pkg: oracle-java8-installer
  service:
    - running
    - enable: True
    - require:
      - pkg: PPAelasticsearch
    - watch:
      - file: elasticsearch*
  file.directory:
    - name: /usr/share/elasticsearch
    - user: elasticsearch
    - group: elasticsearch
    - require:
      - pkg: elasticsearch

oracle-java8-installer:
  pkgrepo.managed:
    - humanname: Oracle PPA repo
    - name: deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main
    - file: /etc/apt/sources.list.d/oracle-java.list
    - keyid: EEA14886
    - keyserver: keyserver.ubuntu.com
  debconf.set:
    - data:
        'shared/accepted-oracle-license-v1-1': {'type': 'boolean', 'value': True}
  pkg.installed:
    - name: oracle-java8-installer
    - require:
      - debconf: oracle-java8-installer
      - pkgrepo: oracle-java8-installer
    - hold: True
