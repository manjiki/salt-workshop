{% for user,info in salt['pillar.get']('users').items() %}
{{user}}:
  user.present:
    - fullname: {{ info['fullname'] }}
    - shell: {{ info['shell']|default("/bin/true") }}
    - home: {{ info['home']|default("/home/%s" % user) }}
    - groups:
      {% for group in info['groups']|default([]) %}
      - {{ group }}
      {% endfor %} 
  {% if 'pub_keys' in info %}
  ssh_auth:
    - present
    - user: {{ user }}
    - names:
  {% for pub_ssh_key in info['pub_keys']|default([]) %}
      - {{ pub_ssh_key }}
  {% endfor %}
    - require:
      - user: {{ user }}
  {% endif %}
{% endfor %}
