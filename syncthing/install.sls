# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "syncthing/map.jinja" import syncthing_settings with context %}

syncthing.install:
    archive.extracted:
        - name: {{ syncthing_settings.installdir }}
        - source: {{ syncthing_settings.download_link }}
        - archive_format: tar
        - source_hash: md5={{ syncthing_settings.download_md5 }}
        - if_missing: {{ syncthing_settings.installdir }}/bin/syncthing
    cmd.run:
        - name: mkdir -p {{ syncthing_settings.installdir }}/bin && mv {{ syncthing_settings.installdir }}/syncthing-*/syncthing {{ syncthing_settings.installdir }}/bin/syncthing && rm -rf {{ syncthing_settings.installdir }}/syncthing-*
        - cwd: /tmp
        - creates: {{ syncthing_settings.installdir }}/bin/syncthing
