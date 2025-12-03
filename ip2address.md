ip地址转区域
=======
###百度ip转区域接口：
```
http://api.map.baidu.com/location/ip?ak=F454f8a5efe5e577997931cc01de3974&ip=222.73.202.202
{"address":"CN|\u4e0a\u6d77|\u4e0a\u6d77|None|CHINANET|0|0","content":{"address_detail":{"province":"\u4e0a\u6d77\u5e02","city":"\u4e0a\u6d77\u5e02","district":"","street":"","street_number":"","city_code":289},"address":"\u4e0a\u6d77\u5e02","point":{"y":"3642780.37","x":"13524118.26"}},"status":0}
```

###百度经纬度转区域接口：
```
http://api.map.baidu.com/geocoder?output=json&location=39.983424,%20116.322987&key=37492c0ee6f924cb5e934fa08c6b1676
{
    "status":"OK",
    "result":{
        "location":{
            "lng":116.322987,
            "lat":39.983424
        },
        "formatted_address":"北京市海淀区中关村大街27号1101-08室",
        "business":"中关村,人民大学,苏州街",
        "addressComponent":{
            "city":"北京市",
            "direction":"附近",
            "distance":"7",
            "district":"海淀区",
            "province":"北京市",
            "street":"中关村大街",
            "street_number":"27号1101-08室"
        },
        "cityCode":131
    }
}
```

###淘宝ip转区域接口：
```
http://ip.taobao.com/service/getIpInfo2.php?ip=222.73.202.202
http://ip.taobao.com/service/getIpInfo.php?ip=222.73.202.202
{"code":0,"data":{"country":"\u4e2d\u56fd","country_id":"CN","area":"\u534e\u4e1c","area_id":"300000","region":"\u4e0a\u6d77\u5e02","region_id":"310000","city":"\u4e0a\u6d77\u5e02","city_id":"310100","county":"","county_id":"-1","isp":"\u7535\u4fe1","isp_id":"100017","ip":"222.73.202.202"}}
其中code的值的含义为，0：成功，1：失败。

https://ip.taobao.com/outGetIpInfo?ip=61.242.135.51&accessKey=alibaba-inc
curl 'https://ip.taobao.com/outGetIpInfo' \
  -H 'authority: ip.taobao.com' \
  -H 'accept: */*' \
  -H 'accept-language: zh-CN,zh;q=0.9' \
  -H 'bx-v: 2.2.3' \
  -H 'content-type: application/x-www-form-urlencoded' \
  -H 'cookie: cna=q8YBGdBzP0QCARsSA2QrI365; miid=432800523882726053; enc=8yl9r8vZYQw7IuSSoqGk4r8iSMLY%2BPlhLzPoqpeTh%2BZOvzsdE1OjQMRj6WUyfmlSOmzHsMUWxzj7ssijVq%2FqXVatoX7h24Y3Hq0Q1sy%2B7zGyHhMz832lPYsE8rwLc1Pi; XSRF-TOKEN=be1c01ab-4c4b-423c-908f-ad84760f187b; l=fBEvLQRIT7AW-KIABO5aourza77toIRX1sPzaNbMiIEGa6sFTFTG8NCebYik7dtjgTf2HFtzhD00fdFMSS4LSxi2PY46IMfKC2pBASSloNf..; tfstk=chzhBiNTTA9XK4Q8CJgCoPxAPKBOaEAZp8yQ71Z22x-o9iaZTscWbnoo6GDGh9-5.' \
  -H 'origin: https://ip.taobao.com' \
  -H 'referer: https://ip.taobao.com/ipSearch' \
  -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="102", "Google Chrome";v="102"' \
  -H 'sec-ch-ua-mobile: ?1' \
  -H 'sec-ch-ua-platform: "Android"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.0.0 Mobile Safari/537.36' \
  -H 'x-requested-with: XMLHttpRequest' \
  --data-raw 'ip=61.242.135.51&accessKey=alibaba-inc' \
  --compressed
```
###ipip.net网ip转区域接口：
```
http://freeapi.ipip.net/222.73.202.202
["中国","上海","上海","","电信"]
```

###sina网ip转区域接口：
```
http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=js&ip=222.73.202.202
var remote_ip_info = {"ret":1,"start":-1,"end":-1,"country":"\u4e2d\u56fd","province":"\u4e0a\u6d77","city":"\u4e0a\u6d77","district":"","isp":"","type":"","desc":""};
```

###ip.sb
```
https://ip.sb/api/

https://api.ip.sb/geoip/61.242.135.51
```

###ip.bczs.net
```
国内
http://ip.bczs.net/city
香港
http://ip.bczs.net/country/HK

http://ip.bczs.net/61.242.141.51
```

###ip138
```
https://ip138.com/iplookup.php?ip=61.242.144.255&action=2
```

###itlu.org
```
https://itlu.org/tool/ip/
```

###tool.lu 可以同时查询纯真数据、ipip的数据，还有淘宝数据、ip2region这四个平台
```
https://tool.lu/ip/

curl -L ip.tool.lu
curl -L ip.tool.lu -x socks5://127.0.0.1:1080

curl 'https://tool.lu/ip/ajax.html' \
  -H 'authority: tool.lu' \
  -H 'accept: application/json, text/javascript, */*; q=0.01' \
  -H 'accept-language: zh-CN,zh;q=0.9' \
  -H 'content-type: application/x-www-form-urlencoded; charset=UTF-8' \
  -H 'cookie: _session=%7B%22slim.flash%22%3A%5B%5D%7D; uuid=8ba0fc97-2448-4ce4-8556-270a7a581425; _access=8fb5d9e2d70210ee084eb81953042e8f72ec7e9f9b465d73d8b395e613d50951' \
  -H 'origin: https://tool.lu' \
  -H 'referer: https://tool.lu/ip/' \
  -H 'user-agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.0.0 Mobile Safari/537.36' \
  -H 'x-requested-with: XMLHttpRequest' \
  --data-raw 'ip=61.242.135.51' \
  --compressed
```

###cz88
```
https://www.cz88.net/help?id=free
http://update.cz88.net/ip/qqwry.rar
http://update.cz88.net/ip/copywrite.rar
https://www.cz88.net/api/cz88/ip/base?ip=61.242.135.51
```
