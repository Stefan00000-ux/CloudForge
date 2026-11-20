#!/bin/bash
apt-get update -y
apt-get install -y nginx curl

# Fetch IMDSv2 Token
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)
PUBLIC_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4)
AZ=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>CloudForge Live Node</title>
  <style>
    body { font-family: system-ui, sans-serif; background: #0f172a; color: #f8fafc; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
    .card { background: #1e293b; border: 1px solid #334155; border-radius: 12px; padding: 32px; max-width: 480px; width: 100%; box-shadow: 0 10px 25px rgba(0,0,0,0.4); }
    h1 { color: #38bdf8; margin-top: 0; font-size: 1.5rem; }
    .badge { background: #065f46; color: #6ee7b7; padding: 4px 10px; border-radius: 999px; font-size: 0.75rem; font-weight: 600; }
    .row { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px solid #334155; }
    .label { color: #94a3b8; }
    .val { font-family: monospace; color: #e2e8f0; }
  </style>
</head>
<body>
  <div class="card">
    <span class="badge">IMDSv2 Hardened &bull; Nginx Active</span>
    <h1>CloudForge Provisioned Node</h1>
    <div class="row"><span class="label">Instance ID</span><span class="val">${INSTANCE_ID}</span></div>
    <div class="row"><span class="label">Public IP</span><span class="val">${PUBLIC_IP}</span></div>
    <div class="row"><span class="label">Private IP</span><span class="val">${PRIVATE_IP}</span></div>
    <div class="row"><span class="label">Availability Zone</span><span class="val">${AZ}</span></div>
  </div>
</body>
</html>
EOF

systemctl enable nginx
systemctl restart nginx