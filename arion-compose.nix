  { pkgs, ... }:
{
    project.name = "webapp";
  services = {

services.uptimekuma = {
    service.image = "louislam/uptime-kuma:1";
    service.volumes = [ "/var/run/docker.sock:/var/run/docker.sock" "/var/lib/docker/volumes/nextcloud_aio_apache/_data/caddy/certificates/acme-v02.api.letsencrypt.org-directory/fff161.ddns.net:/var/lib/docker/volumes/nextcloud_aio_apache/_data/caddy/certificates/acme-v02.api.letsencrypt.org-directory/fff161.ddns.net" "/home/marie/mykuma/data:/app/data" ];
    service.environment.SSL_KEY = "/var/lib/docker/volumes/nextcloud_aio_apache/_data/caddy/certificates/acme-v02.api.letsencrypt.org-directory/fff161.ddns.net/fff161.ddns.net.key";
    service.environment.SSL_CERT = "/var/lib/docker/volumes/nextcloud_aio_apache/_data/caddy/certificates/acme-v02.api.letsencrypt.org-directory/fff161.ddns.net/fff161.ddns.net.crt";
    service.environment.UPTIME_KUMA_DISABLE_FRAME_SAMEORIGIN = "1";
    service.ports = [ "3000:3001" ];
    service.restart = "unless-stopped";
    };
  };

}