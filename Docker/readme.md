# docker exit codes
````
https://www.linkedin.com/pulse/understanding-docker-exit-codesmastering-insights-flawless-dhoble-m5vlc?trackingId=WyDEGIUmTT6kRviuN0fGZw%3D%3D&lipi=urn%3Ali%3Apage%3Ad_flagship3_profile_view_base_recent_activity_content_view%3BSTvtWpEGSjq9zkazyqsaPQ%3D%3D
````

# docker-compose installation

````
sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d'"' -f4)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
````
````
sudo chmod +x /usr/local/bin/docker-compose
````
````
docker-compose --version
````

### docker compose commands
````
vim docker-compose.yaml
````
````
docker-compose build
````
````
docker-compose up -d
````

docker-compose down
````
