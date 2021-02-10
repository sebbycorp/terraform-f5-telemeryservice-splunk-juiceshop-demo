# Terraform F5 + Splunk + TS + AS3 + JuceiShop Demo

I will add notes later.. 

My on prem lab setup:
- Deployed the following docker app/services [ Splunk and Jucieshop ] 
- Configures my F5 BIGIP with virtual server (VIP) to load balance juciceshop
- Than i have to manually post my F5 TS configuration because its not support in AS3 terraform provider yet :( 


## Note: more will be added.. this is just a quick sample..

The following is a quick terraform to spin up splunk for your home lab
- Free splunk enterprise for lab testing
- Create standalone with SSL enabled
- Create standalone with HEC
- Run on windows docker with "Expose daemon on tcp://localhost:2375 without TLS"


1. First create Create standalone with SSL enabled
```
openssl req -x509 -newkey rsa:4096 -passout pass:abcd1234 -keyout /home/key.pem -out /home/cert.pem -days 365 -subj /CN=localhost
```

2. Edit the main.tf to make sure the cert and key are in the appropraite location
3. Edit the main.tf to make sure you put in your passwords

To validate HEC is provisioned properly and functional:
```
$ curl -k https://localhost:8088/services/collector/event -H "Authorization: Splunk abcd1234" -d '{"event": "hello world"}'
```
{"text": "Success", "code": 0}
