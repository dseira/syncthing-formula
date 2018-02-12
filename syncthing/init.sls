# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "syncthing/map.jinja" import syncthing_settings with context %}

include:
    - syncthing.install
    - syncthing.config
