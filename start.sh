gunicorn -b 0.0.0.0:8000 -D app:app
sudo /etc/init.d/nginx restart