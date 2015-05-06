RSA密钥生成命令
=============

###生成RSA私钥
```sh
openssl genrsa -out prikey.pem 1024
```

###生成RSA公钥
```sh
openssl rsa -in privkey.pem -pubout -out pubkey.pem
```

###将RSA私钥转换成PKCS8格式
```sh
openssl pkcs8 -topk8 -inform PEM -in prikey.pem -outform PEM -nocrypt
```

