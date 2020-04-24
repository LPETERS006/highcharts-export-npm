# highcharts-export-npm (highcharts-export-yarn :-)

# docker-compose:

```
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
  volumes:
    hc_export:
      driver: local
```
