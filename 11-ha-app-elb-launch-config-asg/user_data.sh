#!/bin/bash
# Update system and install Apache
dnf update -y
dnf upgrade -y
dnf install httpd -y

# Fetch Private IP address
# Note: Requires 'http_put_response_hop_limit = 2' in Terraform Launch Template
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
            -H "X-aws-ec2-metadata-token-ttl-seconds: 600") 
myip=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
            http://169.254.169.254/latest/meta-data/local-ipv4)

# Create index.html with styled background
cat <<EOF > /var/www/html/index.html
<html>
<head>
    <title>Terraform Web Server</title>
    <meta charset="utf-8">
</head>
<body bgcolor="black">
    <h2><font color="gold">Build by Power of Terraform <font color="red"> v1.14.3</font></font></h2>
    <br>
    <p>
        <font color="green">Server Private IP: <font color="aqua">$myip</font></font>
    </p>
    <br>
    <font color="magenta">
        <b>Version 3.0</b>
    </font>
</body>
</html>
EOF

# Start and enable the web service using modern commands
systemctl start httpd
systemctl enable httpd
