spicy_add_analyzer(
    NAME Wireguard
    PACKAGE_NAME Wireguard
    SOURCES analyzer.spicy analyzer.evt zeek_analyzer.spicy
    SCRIPTS __load__.zeek main.zeek dpd.sig)
