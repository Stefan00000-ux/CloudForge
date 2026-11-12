#!/bin/bash
yum update -y
yum install -y nginx
systemctl start nginx
systemctl enable nginx

# Fetch live AWS EC2 Instance Metadata (IMDSv2)
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)
PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)

cat <<EOF > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>CloudForge | Live Automated Infrastructure</title>
  <style>
    body { font-family: 'Segoe UI', sans-serif; background: #0f172a; color: #f8fafc; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
    .card { background: #1e293b; border: 1px solid #334155; border-radius: 12px; padding: 32px; max-width: 520px; width: 90%; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.5); }
    .badge { display: inline-block; background: #10b981; color: #022c22; font-weight: bold; padding: 4px 12px; border-radius: 999px; font-size: 12px; margin-bottom: 16px; }
    h1 { margin: 0 0 8px 0; font-size: 24px; color: #38bdf8; }
    p { color: #94a3b8; font-size: 14px; margin-bottom: 24px; }
    .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
    .box { background: #0f172a; padding: 12px; border-radius: 8px; border: 1px solid #334155; }
    .label { font-size: 11px; color: #64748b; text-transform: uppercase; }
    .val { font-size: 14px; font-weight: bold; color: #e2e8f0; margin-top: 4px; }
  </style>
</head>
<body>
  <div class="card">
    <div class="badge">● LIVE & SECURED VIA DEVSECOPS</div>
    <h1>CloudForge Infrastructure</h1>
    <p>Provisioned automatically via Reusable Terraform Module & GitHub Actions CI/CD.</p>
    <div class="grid">
      <div class="box"><div class="label">EC2 Instance ID</div><div class="val">$INSTANCE_ID</div></div>
      <div class="box"><div class="label">Availability Zone</div><div class="val">$AZ</div></div>
      <div class="box"><div class="label">Private IP</div><div class="val">$PRIVATE_IP</div></div>
      <div class="box"><div class="label">Security Scan</div><div class="val">tfsec Verified ✓</div></div>
    </div>
  </div>
</body>
</html>
EOF