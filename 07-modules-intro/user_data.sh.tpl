#!/bin/bash
dnf update -y
dnf upgrade -y
dnf install httpd -y

cat <<EOF > /var/www/html/index.html
<html>
<head>
    <meta charset="utf-8">
</head>
<body>
    <h2>Build by Power of Terraform <font color="red"> v1.14.3</font></h2><br>
    Owner ${f_name} ${l_name} <br>
    <p>
    %{ for x in names ~}
    Hello to ${x} from ${f_name}<br>
    %{ endfor ~}
    
</body>
</html>
EOF

systemctl start httpd
systemctl enable httpd
