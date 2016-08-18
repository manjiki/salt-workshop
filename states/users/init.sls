{% for user,userinfo in salt['pillar.get']('users').items() %}
{{user}}:
  user.present:
    - fullname: {{ userinfo['fullname'] }}
    - shell: {{ userinfo['shell']|default("/bin/true") }}
    - home: {{ userinfo['home']|default("/home/%s" % user) }}
    - expire: {{ userinfo['expire']|default('20427')}} # Tue, 05 Dec 2034 11:37:57 GMT
    - groups:
      {% for group in userinfo['groups']|d([]) %}
      - {{ group }}
      {% endfor %}
  {% if 'pub_keys' in userinfo %}
  ssh_auth:
    - present
    - user: {{ user }}
    - names:
  {% for pub_ssh_key in userinfo['pub_keys']|default([]) %}
      - {{ pub_ssh_key }}
  {% endfor %}
    - require:
      - user: {{ user }}
  {% endif %}
{% endfor %}
