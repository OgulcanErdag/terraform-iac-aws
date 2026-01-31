#!/bin/bash
# Update and install Apache
dnf update -y
dnf upgrade -y
dnf install httpd -y

# Retrieve Private IP (Requires hop limit 2 in Terraform)
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
            -H "X-aws-ec2-metadata-token-ttl-seconds: 600") 
myip=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
            http://169.254.169.254/latest/meta-data/local-ipv4)

# Create Web Page
cat <<EOF > /var/www/html/index.html
<html>
<head><meta charset="utf-8"></head>
<body bgcolor="black">
    <h2><font color="gold">Build by Power of Terraform <font color="red"> v1.14.3</font></font></h2>
    <br>
    <p>
    <font color="green">Server Private IP: <font color="aqua">$myip</font></font>
    </p>
    <br>
    <font color="magenta">
    <b>Version 3.0 (Highly Available)</b>
    </font>
</body>
</html>
EOF

# Start and enable Apache service
systemctl restart httpd
systemctl enable httpd
