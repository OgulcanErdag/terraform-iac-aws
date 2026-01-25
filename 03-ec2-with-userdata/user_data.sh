#!/bin/bash
dnf update -y
dnf upgrade -y 
dnf install httpd -y

 TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
            -H "X-aws-ec2-metadata-token-ttl-seconds: 600") 
myip=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
            http://169.254.169.254/latest/meta-data/local-ipv4)
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform using External Script!" > /var/www/html/index.html
echo '<br><font color="blue">Hello World!!</font>' >> /var/www/html/index.html

systemctl start httpd
systemctl enable httpd
