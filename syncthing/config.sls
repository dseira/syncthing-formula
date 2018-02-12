# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "syncthing/map.jinja" import syncthing_settings with context %}

{% if syncthing_settings.source_path is defined %}
{% set syncthing_config = syncthing_settings.source_path %}
{% else %}
{% set syncthing_config = 'salt://syncthing/files/config.xml.jinja' %}
{% endif %}

syncthing.configdir:
    file.directory:
        - name: {{ syncthing_settings.configdir }}/.config/syncthing
        - user: {{ syncthing_settings.user }}
        - group: {{ syncthing_settings.group }}
        - makedirs: True

syncthing.config:
    file.managed:
        - name: {{ syncthing_settings.configdir }}/.config/syncthing/config.xml
        - source: {{ syncthing_config }}
        - user: {{ syncthing_settings.user }}
        - group: {{ syncthing_settings.group }}
        - mode: '600'
        - template: jinja

{% if syncthing_settings.folders is defined %}
{% for folder,folder_options in syncthing_settings.folders.items() %}
{% if folder_options.stignore is defined %}

{% if folder_options.stignore.source_path is defined %}
{% set syncthing_stignore = folder_options.stignore.source_path %}
{% else %}
{% set syncthing_stignore = 'salt://syncthing/files/stignore.jinja' %}
{% endif %}

syncthing.folder.{{ folder }}:
    {% if ( folder_options.stignore.enabled is defined and folder_options.stignore.enabled ) or folder_options.stignore.enabled is not defined %}
    file.managed:
        - name: {{ folder }}/.stignore
        - source: {{ syncthing_stignore }}
        - user: {{ syncthing_settings.user }}
        - group: {{ syncthing_settings.group }}
        - mode: '644'
        - template: jinja
        - context: 
            folder: {{ folder }}
    {% else %}
    file.absent:
        - name: {{ folder }}/.stignore
    {% endif %}

{% endif %}
{% endfor %}
{% endif %}

syncthing.upload_certificate:
    file.managed:
        {% if syncthing_settings.certificate_path is defined %}
        - name: {{ syncthing_settings.certificate_path }}
        {% else %}
        - name: {{ syncthing_settings.configdir }}/.config/syncthing/cert.pem
        {% endif %}
        {% if syncthing_settings.certificate_file is defined %}
        - source: {{ syncthing_settings.certificate_file }}
        {% elif syncthing_settings.certificate is defined %}
        - contents_pillar: syncthing:certificate
        {% endif %}
        - user: {{ syncthing_settings.user }}
        - group: {{ syncthing_settings.group }}
        - mode: '644'

syncthing.upload_key:
    file.managed:
        {% if syncthing_settings.key_path is defined %}
        - name: {{ syncthing_settings.key_path }}
        {% else %}
        - name: {{ syncthing_settings.configdir }}/.config/syncthing/key.pem
        {% endif %}
        {% if syncthing_settings.key_file is defined %}
        - source: {{ syncthing_settings.key_file }}
        {% elif syncthing_settings.key is defined %}
        - contents_pillar: syncthing:key
        {% endif %}
        - user: {{ syncthing_settings.user }}
        - group: {{ syncthing_settings.group }}
        - mode: '600'
