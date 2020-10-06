echo "Destroying old ISLE state"
docker-compose down -v
echo "building empty snapshot image"
docker-compose build snapshot
echo "[ISLE DC] Starting ISLE..."
docker-compose up -d
echo "[ISLE DC] Composer install..."
docker-compose exec drupal with-contenv bash -lc 'COMPOSER_MEMORY_LIMIT=-1 composer install'
echo "[ISLE DC] make install..."
make install
echo "[ISLE DC] updating/managing settings..."
make update-settings-php update-config-from-environment solr-cores run-islandora-migrations
echo "[ISLE DC] rebuilding Drupal cache..."
docker-compose exec drupal drush cr -y
echo "Taking snapshot of new install"
make snapshot-image
