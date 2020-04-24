# highcharts-export-npm (highcharts-export-yarn :-)

- docker-compose:

version: "3.7"
services:
  portainer:
    container_name: hc_export
    image: 'lpeters999/highcharts-export-npm:latest'
    restart: always
    ports:
      - "51180:8080"
    volumes:
      - hc_export:/usr/share/export/
    healthcheck:
      test: curl --fail -s http://localhost:8080/ || exit 1
      interval: 1m30s
      timeout: 10s
      retries: 3
volumes:
  hc_export:
    driver: local
