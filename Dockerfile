FROM alpine:3.8
 
LABEL maintainer "ept007@latech.edu"
 
RUN apk update && apk upgrade && apk add apache2 && \
    apk add php7-fpm apache2-proxy bash php7-mysqli && \
    apk add php7-gd php7-curl nfs-utils && \
sed -i '/mod_mpm_prefork/s/^/#/' /etc/apache2/httpd.conf && \
sed -i '/^#.*mod_mpm_event/s/^#//' /etc/apache2/httpd.conf && \
sed -i '/^#.*slotmem_shm/s/^#//' /etc/apache2/httpd.conf && \
sed -i '/ServerName www/s/^#//g' /etc/apache2/httpd.conf && \
sed -i $'/<IfModule dir_module>/a \    ProxyPassMatch ^/(.*\.php(/.*)?)$ fcgi://127.0.0.1:9000/var/www/localhost/htdocs' /etc/apache2/httpd.conf && \
sed -i 's/DirectoryIndex index.html/DirectoryIndex index.php index.html/' /etc/apache2/httpd.conf && \
sed -i 's|ErrorLog logs/error.log|ErrorLog /dev/stdout|' /etc/apache2/httpd.conf && \
sed -i 's|CustomLog logs/access.log combined|CustomLog /dev/stdout combined|' /etc/apache2/httpd.conf && \
echo 'PidFile /var/run/httpd.pid' >> /etc/apache2/httpd.conf && \
echo 'fs-07551b789c13c562c.efs.us-east-1.amazonaws.com:/       /var/www/localhost/htdocs    nfs     defaults 0 0' >> /etc/fstab
 
COPY script.sh /usr/sbin/script.sh
 
EXPOSE 80
 
CMD ["/bin/bash", "/usr/sbin/script.sh"]
