#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>CloudForge | Automated Infrastructure</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #0f172a; color: #f8fafc; text-align: center; padding-top: 100px; }
        .card { background-color: #1e293b; display: inline-block; padding: 40px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.5); }
        h1 { color: #38bdf8; }
        p { font-size: 1.2rem; }
        .badge { background-color: #22c55e; color: #000; padding: 6px 12px; border-radius: 20px; font-weight: bold; }
    </style>
</head>
<body>
    <div class="card">
        <h1>CloudForge Infrastructure Live</h1>
        <p>Status: <span class="badge">PROVISIONED VIA TERRAFORM</span></p>
        <p>This server and network were automatically deployed using Infrastructure as Code.</p>
    </div>
</body>
</html>
EOF