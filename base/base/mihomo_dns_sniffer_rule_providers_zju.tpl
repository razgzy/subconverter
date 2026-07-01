{% if request.target == "clash" or request.target == "clashr" %}

port: {{ default(global.clash.http_port, "7890") }}
socks-port: {{ default(global.clash.socks_port, "7891") }}
allow-lan: {{ default(global.clash.allow_lan, "true") }}
mode: Rule
log-level: {{ default(global.clash.log_level, "info") }}
external-controller: {{ default(global.clash.external_controller, "127.0.0.1:9090") }}
dns:
  enable: true
  listen: ':53'
  enhanced-mode: 'fake-ip'
  fake-ip-range: '198.18.0.1/16'
  fake-ip-filter-mode: 'blacklist'
  prefer-h3: false
  respect-rules: false
  use-hosts: false
  use-system-hosts: true
  ipv6: true
  fake-ip-filter:
    - '+.lan'
    - '+.local'
    - '+.arpa'
    - '+.zju.edu.cn'
    - '+.msftconnecttest.com'
    - '+.msftncsi.com'
    - 'www.msftconnecttest.com'
    - 'localhost.ptlogin2.qq.com'
    - 'localhost.sec.qq.com'
    - 'localhost.work.weixin.qq.com'
    - '+.ntp.org'
    - '+.pool.ntp.org'
    - '+.time.windows.com'
    - '+.time.apple.com'
    - 'time.*.com'
    - 'ntp.*.com'
    - '+.stun.*.*'
    - '+.stun.*.*.*'
    - '+.stun.*.*.*.*'
    - 'stun.*.*'
    - 'stun.*.*.*'
  default-nameserver:
    - '223.5.5.5'
    - '223.6.6.6'
    - '119.29.29.29'
  nameserver:
    - 'https://cloudflare-dns.com/dns-query#🚀 节点选择'
    - 'https://dns.google/dns-query#🚀 节点选择'
  direct-nameserver-follow-policy: true
  fallback-filter:
    geoip: false
    geoip-code: 'CN'
    ipcidr:
      - '240.0.0.0/4'
      - '0.0.0.0/32'
    domain:
      - '+.google.com'
      - '+.facebook.com'
      - '+.youtube.com'
  fallback: []
  proxy-server-nameserver:
    - '223.5.5.5'
    - '223.6.6.6'
    - '119.29.29.29'
  direct-nameserver:
    - 'system'
    - '223.5.5.5'
    - '119.29.29.29'
    - 'https://dns.alidns.com/dns-query'
    - 'https://doh.pub/dns-query'
  nameserver-policy:
    +.zju.edu.cn:
      - 'system'
    geosite:cn:
      - '223.5.5.5'
      - '119.29.29.29'
      - 'https://dns.alidns.com/dns-query'
      - 'https://doh.pub/dns-query'
    geosite:private:
      - 'system'
sniffer:
  enable: true
  force-dns-mapping: true
  parse-pure-ip: true
  override-destination: true
  sniff:
    TLS:
      ports: [443, 8443]
    HTTP:
      ports: [80, 8080-8880]
    QUIC:
      ports: [443, 8443]
{% if local.clash.new_field_name == "true" %}
proxies: ~
proxy-groups: ~
rule-providers: ~
rules: ~
{% else %}
Proxy: ~
Proxy Group: ~
Rule Provider: ~
Rule: ~
{% endif %}

{% endif %}
